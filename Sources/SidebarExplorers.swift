import AppKit
import Darwin
import Foundation
import SwiftUI
#if canImport(Security)
import Security
#endif

enum ExplorerDocumentLocation: Equatable {
    case local(URL)
    case remote(destination: String, path: String)
}

struct SSHConfigHostEntry: Identifiable, Equatable {
    let alias: String
    let hostname: String?
    let user: String?
    let port: Int?
    let identityFile: String?
    let sourcePath: String

    var id: String { alias }

    var subtitle: String {
        var parts: [String] = []
        if let user, let hostname {
            parts.append("\(user)@\(hostname)")
        } else if let hostname {
            parts.append(hostname)
        }
        if let port {
            parts.append(":\(port)")
        }
        if parts.isEmpty {
            return sourceDisplayName
        }
        return parts.joined(separator: "")
    }

    var sourceDisplayName: String {
        URL(fileURLWithPath: sourcePath).lastPathComponent
    }

    func workspaceConfiguration() -> WorkspaceRemoteConfiguration {
        let controlPath = Self.makeControlSocketPath(alias: alias)
        return WorkspaceRemoteConfiguration(
            destination: alias,
            port: port,
            identityFile: identityFile,
            sshOptions: [
                "ControlPath=\(controlPath)",
            ],
            localProxyPort: nil,
            relayPort: nil,
            relayID: nil,
            relayToken: nil,
            localSocketPath: nil,
            terminalStartupCommand: Self.interactiveSSHCommand(alias: alias, controlPath: controlPath)
        )
    }

    private static func interactiveSSHCommand(alias: String, controlPath: String) -> String {
        let shell = """
        alias_name=\(shellSingleQuoted(alias))
        control_path=\(shellSingleQuoted(controlPath))
        password="$(/usr/bin/security find-generic-password -s \(shellSingleQuoted(RemoteHostPasswordStore.serviceName)) -a "$alias_name" -w 2>/dev/null || true)"
        if [ -n "$password" ] && command -v /usr/bin/expect >/dev/null 2>&1; then
          CMUX_SSH_ALIAS="$alias_name" \
          CMUX_SSH_CONTROL_PATH="$control_path" \
          CMUX_SSH_PASSWORD="$password" \
          /usr/bin/expect <<'CMUX_EXPECT'
        set timeout -1
        log_user 1
        set alias_name $env(CMUX_SSH_ALIAS)
        set control_path $env(CMUX_SSH_CONTROL_PATH)
        set password $env(CMUX_SSH_PASSWORD)
        set sent_password 0
        spawn ssh -M -o ControlPersist=yes -o ControlPath=$control_path $alias_name
        expect {
            -re "(?i)are you sure you want to continue connecting.*" {
                send "yes\\r"
                exp_continue
            }
            -re "(?i)(password|passphrase).*:" {
                if {$sent_password} {
                    interact
                    return
                }
                set sent_password 1
                send -- "$password\\r"
                exp_continue
            }
            -re "(?i)permission denied" {
                interact
                return
            }
            timeout {
                interact
                return
            }
            eof {
                return
            }
        }
        interact
        CMUX_EXPECT
        else
          exec ssh -M -o ControlPersist=yes -o ControlPath="$control_path" "$alias_name"
        fi
        """
        return "sh -lc \(shellSingleQuoted(shell))"
    }

    private static func makeControlSocketPath(alias: String) -> String {
        let sanitizedAlias = alias
            .lowercased()
            .replacingOccurrences(of: "[^a-z0-9_-]+", with: "-", options: .regularExpression)
            .trimmingCharacters(in: CharacterSet(charactersIn: "-_"))
        let fallbackAlias = sanitizedAlias.isEmpty ? "remote" : sanitizedAlias
        let uniqueSuffix = UUID().uuidString.replacingOccurrences(of: "-", with: "").prefix(10)
        return "/tmp/iatlas-\(fallbackAlias)-\(uniqueSuffix).sock"
    }

    private static func shellSingleQuoted(_ value: String) -> String {
        "'" + value.replacingOccurrences(of: "'", with: "'\"'\"'") + "'"
    }
}

enum RemoteHostPasswordStore {
    static let serviceName = "com.icc.app.remote-ssh"

    static func loadPassword(for account: String) -> String? {
#if canImport(Security)
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: serviceName,
            kSecAttrAccount: account,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne,
        ]
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess, let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
#else
        return nil
#endif
    }

    static func hasPassword(for account: String) -> Bool {
        loadPassword(for: account)?.isEmpty == false
    }

    static func savePassword(_ password: String, for account: String) throws {
#if canImport(Security)
        let trimmedPassword = password.trimmingCharacters(in: .newlines)
        if trimmedPassword.isEmpty {
            try clearPassword(for: account)
            return
        }
        let data = Data(trimmedPassword.utf8)
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: serviceName,
            kSecAttrAccount: account,
        ]
        let attributes: [CFString: Any] = [
            kSecValueData: data,
        ]
        let updateStatus = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        if updateStatus == errSecSuccess {
            return
        }
        guard updateStatus == errSecItemNotFound else {
            throw NSError(domain: NSOSStatusErrorDomain, code: Int(updateStatus))
        }
        var createQuery = query
        createQuery[kSecValueData] = data
        let addStatus = SecItemAdd(createQuery as CFDictionary, nil)
        guard addStatus == errSecSuccess else {
            throw NSError(domain: NSOSStatusErrorDomain, code: Int(addStatus))
        }
#endif
    }

    static func clearPassword(for account: String) throws {
#if canImport(Security)
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: serviceName,
            kSecAttrAccount: account,
        ]
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw NSError(domain: NSOSStatusErrorDomain, code: Int(status))
        }
#endif
    }
}

private struct SSHConfigBlock {
    let aliases: [String]
    let sourcePath: String
    var hostname: String?
    var user: String?
    var port: Int?
    var identityFile: String?
}

enum SSHConfigLoader {
    static func load(fileManager: FileManager = .default) -> [SSHConfigHostEntry] {
        let rootPath = NSString(string: "~/.ssh/config").expandingTildeInPath
        let urls = resolvedConfigURLs(
            forPattern: rootPath,
            relativeTo: nil,
            fileManager: fileManager
        )

        var visited: Set<String> = []
        var blocks: [SSHConfigBlock] = []
        for url in urls {
            loadBlocks(
                from: url,
                visited: &visited,
                fileManager: fileManager,
                into: &blocks
            )
        }

        var entriesByAlias: [String: SSHConfigHostEntry] = [:]
        for block in blocks {
            for alias in block.aliases {
                entriesByAlias[alias] = SSHConfigHostEntry(
                    alias: alias,
                    hostname: block.hostname,
                    user: block.user,
                    port: block.port,
                    identityFile: block.identityFile,
                    sourcePath: block.sourcePath
                )
            }
        }

        return entriesByAlias.values.sorted { lhs, rhs in
            lhs.alias.localizedCaseInsensitiveCompare(rhs.alias) == .orderedAscending
        }
    }

    private static func loadBlocks(
        from url: URL,
        visited: inout Set<String>,
        fileManager: FileManager,
        into blocks: inout [SSHConfigBlock]
    ) {
        let standardizedPath = url.standardizedFileURL.path
        guard visited.insert(standardizedPath).inserted,
              let content = try? String(contentsOf: url, encoding: .utf8) else {
            return
        }

        var currentAliases: [String] = []
        var currentHostname: String?
        var currentUser: String?
        var currentPort: Int?
        var currentIdentityFile: String?

        func flushCurrentBlock() {
            guard !currentAliases.isEmpty else { return }
            blocks.append(
                SSHConfigBlock(
                    aliases: currentAliases,
                    sourcePath: standardizedPath,
                    hostname: currentHostname,
                    user: currentUser,
                    port: currentPort,
                    identityFile: currentIdentityFile
                )
            )
            currentAliases = []
            currentHostname = nil
            currentUser = nil
            currentPort = nil
            currentIdentityFile = nil
        }

        for rawLine in content.components(separatedBy: .newlines) {
            let line = rawLine.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !line.isEmpty, !line.hasPrefix("#") else { continue }

            let parts = splitConfigLine(line)
            guard let key = parts.first?.lowercased() else { continue }
            let value = parts.dropFirst().joined(separator: " ").trimmingCharacters(in: .whitespacesAndNewlines)
            guard !value.isEmpty else { continue }

            switch key {
            case "include":
                flushCurrentBlock()
                for includeURL in resolvedConfigURLs(
                    forPattern: value,
                    relativeTo: url.deletingLastPathComponent(),
                    fileManager: fileManager
                ) {
                    loadBlocks(from: includeURL, visited: &visited, fileManager: fileManager, into: &blocks)
                }
            case "host":
                flushCurrentBlock()
                currentAliases = value
                    .split(whereSeparator: \.isWhitespace)
                    .map(String.init)
                    .filter { !$0.contains("*") && !$0.contains("?") && !$0.contains("!") }
            case "hostname":
                currentHostname = value
            case "user":
                currentUser = value
            case "port":
                currentPort = Int(value)
            case "identityfile":
                currentIdentityFile = value
            default:
                continue
            }
        }

        flushCurrentBlock()
    }

    private static func splitConfigLine(_ line: String) -> [String] {
        if let firstWhitespace = line.firstIndex(where: \.isWhitespace) {
            let key = String(line[..<firstWhitespace])
            let value = String(line[firstWhitespace...]).trimmingCharacters(in: .whitespacesAndNewlines)
            return [key, value]
        }
        return [line]
    }

    private static func resolvedConfigURLs(
        forPattern rawPattern: String,
        relativeTo baseURL: URL?,
        fileManager: FileManager
    ) -> [URL] {
        let expandedPattern = NSString(string: rawPattern).expandingTildeInPath
        let normalizedPattern: String
        if expandedPattern.hasPrefix("/") {
            normalizedPattern = expandedPattern
        } else if let baseURL {
            normalizedPattern = baseURL.appendingPathComponent(expandedPattern).path
        } else {
            normalizedPattern = expandedPattern
        }

        let matchedPaths = globbedPaths(pattern: normalizedPattern)
        if !matchedPaths.isEmpty {
            return matchedPaths.map { URL(fileURLWithPath: $0) }
        }
        if fileManager.fileExists(atPath: normalizedPattern) {
            return [URL(fileURLWithPath: normalizedPattern)]
        }
        return []
    }

    private static func globbedPaths(pattern: String) -> [String] {
        var result = glob_t()
        defer { globfree(&result) }

        let status = pattern.withCString { glob($0, GLOB_TILDE, nil, &result) }
        guard status == 0 else { return [] }

        let count = Int(result.gl_matchc)
        guard let pathv = result.gl_pathv else { return [] }
        return (0..<count).compactMap { index in
            guard let pointer = pathv[index] else { return nil }
            return String(cString: pointer)
        }
    }
}

struct RemoteExplorerEntry: Identifiable, Equatable {
    let path: String
    let name: String
    let isDirectory: Bool

    var id: String { path }
}

enum RemoteSSHFileService {
    static func resolveInitialDirectory(
        configuration: WorkspaceRemoteConfiguration,
        preferredPath: String?
    ) throws -> String {
        let trimmedPreferred = preferredPath?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if !trimmedPreferred.isEmpty, trimmedPreferred != "/" {
            let script = """
            target=\(shellSingleQuoted(trimmedPreferred))
            if [ -d "$target" ]; then
              printf '%s\n' "$target"
              exit 0
            fi
            pwd
            """
            let result = try runSSH(configuration: configuration, remoteCommand: "sh -lc \(shellSingleQuoted(script))", timeout: 10, batchMode: false)
            let resolved = result.stdout.trimmingCharacters(in: .whitespacesAndNewlines)
            if result.status == 0, !resolved.isEmpty {
                return resolved
            }
        }

        let result = try runSSH(configuration: configuration, remoteCommand: "pwd", timeout: 10, batchMode: false)
        let resolved = result.stdout.trimmingCharacters(in: .whitespacesAndNewlines)
        guard result.status == 0, !resolved.isEmpty else {
            let detail = bestErrorLine(stderr: result.stderr, stdout: result.stdout) ?? "Failed to resolve remote directory."
            throw NSError(domain: "cmux.remote.explorer", code: 1, userInfo: [
                NSLocalizedDescriptionKey: detail
            ])
        }
        return resolved
    }

    static func listDirectory(
        configuration: WorkspaceRemoteConfiguration,
        path: String
    ) throws -> [RemoteExplorerEntry] {
        let script = """
        target=\(shellSingleQuoted(path))
        if [ ! -d "$target" ]; then
          echo "__CMUX_ERROR__ Not a directory: $target" >&2
          exit 3
        fi
        find "$target" -mindepth 1 -maxdepth 1 -exec sh -c '
          for entry do
            if [ -d "$entry" ]; then
              kind="d"
            else
              kind="f"
            fi
            name="${entry##*/}"
            printf "%s\t%s\t%s\n" "$kind" "$name" "$entry"
          done
        ' sh {} +
        """
        let result = try runSSH(
            configuration: configuration,
            remoteCommand: "sh -lc \(shellSingleQuoted(script))",
            timeout: 15,
            batchMode: false
        )
        guard result.status == 0 else {
            let detail = bestErrorLine(stderr: result.stderr, stdout: result.stdout) ?? "Failed to list remote directory."
            throw NSError(domain: "cmux.remote.explorer", code: 2, userInfo: [
                NSLocalizedDescriptionKey: detail
            ])
        }

        let entries = result.stdout
            .split(separator: "\n", omittingEmptySubsequences: true)
            .compactMap { line -> RemoteExplorerEntry? in
                let parts = line.split(separator: "\t", omittingEmptySubsequences: false)
                guard parts.count >= 3 else { return nil }
                return RemoteExplorerEntry(
                    path: String(parts[2]),
                    name: String(parts[1]),
                    isDirectory: String(parts[0]) == "d"
                )
            }

        return entries.sorted { lhs, rhs in
            if lhs.isDirectory != rhs.isDirectory {
                return lhs.isDirectory && !rhs.isDirectory
            }
            return lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
        }
    }

    static func loadTextFile(
        configuration: WorkspaceRemoteConfiguration,
        path: String
    ) throws -> ExplorerTextDocument {
        let script = """
        target=\(shellSingleQuoted(path))
        if [ ! -f "$target" ]; then
          echo "__CMUX_ERROR__ File not found: $target" >&2
          exit 4
        fi
        size=$(wc -c < "$target" | tr -d '[:space:]')
        if [ -n "$size" ] && [ "$size" -gt 1048576 ]; then
          echo "__CMUX_ERROR__ File is larger than 1 MB." >&2
          exit 5
        fi
        cat "$target"
        """
        let result = try runSSH(
            configuration: configuration,
            remoteCommand: "sh -lc \(shellSingleQuoted(script))",
            timeout: 20,
            batchMode: false
        )
        guard result.status == 0 else {
            let detail = bestErrorLine(stderr: result.stderr, stdout: result.stdout) ?? "Failed to read remote file."
            throw NSError(domain: "cmux.remote.explorer", code: 3, userInfo: [
                NSLocalizedDescriptionKey: detail
            ])
        }

        let encodedDestination = configuration.destination.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? configuration.destination
        let encodedPath = path.split(separator: "/").map {
            String($0).addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? String($0)
        }.joined(separator: "/")
        let url = URL(string: "ssh://\(encodedDestination)/\(encodedPath)") ?? URL(string: "ssh://\(encodedDestination)")!
        return ExplorerTextDocument(
            location: .remote(destination: configuration.destination, path: path),
            url: url,
            originalText: result.stdout,
            text: result.stdout,
            isEditable: true,
            errorMessage: nil
        )
    }

    static func saveTextFile(
        configuration: WorkspaceRemoteConfiguration,
        path: String,
        text: String
    ) throws {
        let script = """
        target=\(shellSingleQuoted(path))
        parent="$(dirname "$target")"
        mkdir -p "$parent" && cat > "$target"
        """
        let result = try runSSH(
            configuration: configuration,
            remoteCommand: "sh -lc \(shellSingleQuoted(script))",
            stdin: Data(text.utf8),
            timeout: 20,
            batchMode: false
        )
        guard result.status == 0 else {
            let detail = bestErrorLine(stderr: result.stderr, stdout: result.stdout) ?? "Failed to save remote file."
            throw NSError(domain: "cmux.remote.explorer", code: 4, userInfo: [
                NSLocalizedDescriptionKey: detail
            ])
        }
    }

    private static func runSSH(
        configuration: WorkspaceRemoteConfiguration,
        remoteCommand: String,
        stdin: Data? = nil,
        timeout: TimeInterval,
        batchMode: Bool
    ) throws -> (status: Int32, stdout: String, stderr: String) {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/ssh")
        process.arguments = sshArguments(configuration: configuration, batchMode: batchMode) + [configuration.destination, remoteCommand]

        let stdoutPipe = Pipe()
        let stderrPipe = Pipe()
        process.standardOutput = stdoutPipe
        process.standardError = stderrPipe
        if stdin != nil {
            process.standardInput = Pipe()
        }

        try process.run()
        if let stdin,
           let pipe = process.standardInput as? Pipe {
            pipe.fileHandleForWriting.write(stdin)
            try? pipe.fileHandleForWriting.close()
        }

        let deadline = Date().addingTimeInterval(timeout)
        while process.isRunning, Date() < deadline {
            Thread.sleep(forTimeInterval: 0.05)
        }
        if process.isRunning {
            process.terminate()
            throw NSError(domain: "cmux.remote.explorer", code: 5, userInfo: [
                NSLocalizedDescriptionKey: "SSH request timed out."
            ])
        }

        let stdout = String(data: stdoutPipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? ""
        let stderr = String(data: stderrPipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? ""
        return (process.terminationStatus, stdout, stderr)
    }

    private static func sshArguments(
        configuration: WorkspaceRemoteConfiguration,
        batchMode: Bool
    ) -> [String] {
        var args: [String] = []
        if batchMode {
            args += ["-o", "BatchMode=yes"]
        } else {
            args += ["-o", "BatchMode=no"]
        }
        args += ["-o", "ControlMaster=no"]
        if let port = configuration.port {
            args += ["-p", String(port)]
        }
        if let identityFile = configuration.identityFile,
           !identityFile.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            args += ["-i", NSString(string: identityFile).expandingTildeInPath]
        }
        if !hasSSHOptionKey(configuration.sshOptions, key: "StrictHostKeyChecking") {
            args += ["-o", "StrictHostKeyChecking=accept-new"]
        }
        for option in configuration.sshOptions {
            let trimmed = option.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmed.isEmpty { continue }
            args += ["-o", trimmed]
        }
        return args
    }

    private static func hasSSHOptionKey(_ options: [String], key: String) -> Bool {
        options.contains { option in
            optionKey(option) == key.lowercased()
        }
    }

    private static func optionKey(_ option: String) -> String? {
        let trimmed = option.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        return trimmed
            .split(whereSeparator: { $0 == "=" || $0.isWhitespace })
            .first
            .map(String.init)?
            .lowercased()
    }

    private static func shellSingleQuoted(_ value: String) -> String {
        "'" + value.replacingOccurrences(of: "'", with: "'\"'\"'") + "'"
    }

    private static func bestErrorLine(stderr: String, stdout: String) -> String? {
        for source in [stderr, stdout] {
            let line = source
                .split(separator: "\n")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .first(where: { !$0.isEmpty })
            if let line, !line.isEmpty {
                return line
            }
        }
        return nil
    }
}

@MainActor
final class LocalFileExplorerNode: ObservableObject, Identifiable {
    let url: URL
    let isDirectory: Bool
    let depth: Int
    let rootPath: String

    @Published var isExpanded = false
    @Published var isLoading = false
    @Published var children: [LocalFileExplorerNode] = []
    @Published var didLoadChildren = false

    init(url: URL, isDirectory: Bool, depth: Int, rootPath: String) {
        self.url = url
        self.isDirectory = isDirectory
        self.depth = depth
        self.rootPath = rootPath
    }

    var id: String { url.path }
    var name: String { url.lastPathComponent.isEmpty ? url.path : url.lastPathComponent }

    func loadChildren(fileManager: FileManager = .default, forceRefresh: Bool = false) {
        guard isDirectory, (!didLoadChildren || forceRefresh || children.isEmpty), !isLoading else { return }
        let parentURL = url
        let nextDepth = depth + 1
        let path = parentURL.path

        if let cachedEntries = LocalFileExplorerCache.entries(for: path) {
            didLoadChildren = true
            children = reconcileLocalChildNodes(
                existing: children,
                from: cachedEntries,
                depth: nextDepth,
                rootPath: rootPath
            )
        } else if !didLoadChildren {
            didLoadChildren = true
        }

        isLoading = true

        Task.detached(priority: .userInitiated) {
            let entries = loadLocalExplorerChildren(
                at: parentURL,
                fileManager: fileManager
            )
            await MainActor.run {
                LocalFileExplorerCache.store(entries: entries, for: path)
                self.isLoading = false
                self.children = reconcileLocalChildNodes(
                    existing: self.children,
                    from: entries,
                    depth: nextDepth,
                    rootPath: self.rootPath
                )
            }
        }
    }
}

private struct LocalFileExplorerEntrySnapshot {
    let url: URL
    let isDirectory: Bool
    let name: String
}

@MainActor
private enum LocalFileExplorerCache {
    private static var entriesByPath: [String: [LocalFileExplorerEntrySnapshot]] = [:]
    private static var expandedPathsByRootPath: [String: Set<String>] = [:]

    static func entries(for path: String) -> [LocalFileExplorerEntrySnapshot]? {
        entriesByPath[path]
    }

    static func store(entries: [LocalFileExplorerEntrySnapshot], for path: String) {
        entriesByPath[path] = entries
    }

    static func expandedPaths(for rootPath: String) -> Set<String> {
        expandedPathsByRootPath[rootPath] ?? []
    }

    static func isExpanded(_ path: String, within rootPath: String) -> Bool {
        expandedPaths(for: rootPath).contains(path)
    }

    static func setExpanded(_ expanded: Bool, for path: String, within rootPath: String) {
        var paths = expandedPathsByRootPath[rootPath] ?? []
        if expanded {
            paths.insert(path)
        } else {
            paths.remove(path)
        }
        expandedPathsByRootPath[rootPath] = paths
    }
}

@MainActor
private func reconcileLocalChildNodes(
    existing: [LocalFileExplorerNode],
    from entries: [LocalFileExplorerEntrySnapshot],
    depth: Int,
    rootPath: String
) -> [LocalFileExplorerNode] {
    let existingByPath = Dictionary(uniqueKeysWithValues: existing.map { ($0.url.path, $0) })

    return entries.map { entry in
        let node = existingByPath[entry.url.path] ?? LocalFileExplorerNode(
            url: entry.url,
            isDirectory: entry.isDirectory,
            depth: depth,
            rootPath: rootPath
        )

        let shouldBeExpanded = entry.isDirectory && LocalFileExplorerCache.isExpanded(entry.url.path, within: rootPath)
        node.isExpanded = shouldBeExpanded

        guard shouldBeExpanded else {
            if !node.isLoading {
                node.didLoadChildren = false
                node.children = []
            }
            return node
        }

        if let cachedChildren = LocalFileExplorerCache.entries(for: entry.url.path) {
            node.didLoadChildren = true
            node.children = reconcileLocalChildNodes(
                existing: node.children,
                from: cachedChildren,
                depth: depth + 1,
                rootPath: rootPath
            )
        }
        return node
    }
}

private func loadLocalExplorerChildren(
    at url: URL,
    fileManager: FileManager = .default
) -> [LocalFileExplorerEntrySnapshot] {
    let keys: Set<URLResourceKey> = [.isDirectoryKey, .localizedNameKey]
    let urls = (try? fileManager.contentsOfDirectory(
        at: url,
        includingPropertiesForKeys: Array(keys),
        options: [.skipsPackageDescendants]
    )) ?? []

    let entries = urls.compactMap { childURL -> LocalFileExplorerEntrySnapshot? in
        let values = try? childURL.resourceValues(forKeys: keys)
        let isDirectory = values?.isDirectory ?? false
        let displayName = childURL.lastPathComponent.isEmpty ? childURL.path : childURL.lastPathComponent
        return LocalFileExplorerEntrySnapshot(url: childURL, isDirectory: isDirectory, name: displayName)
    }

    return entries.sorted { lhs, rhs in
        if lhs.isDirectory != rhs.isDirectory {
            return lhs.isDirectory && !rhs.isDirectory
        }
        return lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
    }
}

struct LocalFileExplorerSidebar: View {
    let rootPath: String
    let selectedFilePath: String?
    let onOpenFile: (URL) -> Void

    @State private var rootNode: LocalFileExplorerNode?
    @State private var errorMessage: String?
    @State private var isLoading = false
    @State private var displayedRootPath: String?

    var body: some View {
        VStack(spacing: 0) {
            explorerHeader

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 2) {
                    if let errorMessage {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(12)
                    } else if let rootNode {
                        FileExplorerNodeRows(
                            node: rootNode,
                            selectedFilePath: selectedFilePath,
                            onOpenFile: onOpenFile
                        )
                    } else if isLoading {
                        HStack(spacing: 8) {
                            ProgressView()
                                .controlSize(.small)
                            Text("正在读取目录…")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(12)
                    } else {
                        Text("没有可显示的文件")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(12)
                    }
                }
                .padding(.vertical, 8)
            }
            .overlay(alignment: .topTrailing) {
                if isLoading, rootNode != nil {
                    HStack(spacing: 8) {
                        ProgressView()
                            .controlSize(.small)
                        Text("正在刷新")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.ultraThinMaterial, in: Capsule(style: .continuous))
                    .padding(.top, 8)
                    .padding(.trailing, 10)
                    .transition(.opacity)
                }
            }
        }
        .background(SidebarBackdrop().ignoresSafeArea())
        .task(id: rootPath) {
            await reload()
        }
    }

    private var explorerHeader: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("目录")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.secondary)
            Text(SidebarPathFormatter.shortenedPath(rootPath))
                .font(.system(size: 12, weight: .medium))
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
        .padding(.top, 12)
        .padding(.bottom, 8)
    }

    private func reload() async {
        let trimmedPath = rootPath.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedPath.isEmpty else {
            rootNode = nil
            errorMessage = "Current workspace has no directory."
            isLoading = false
            displayedRootPath = nil
            return
        }

        var isDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: trimmedPath, isDirectory: &isDirectory), isDirectory.boolValue else {
            rootNode = nil
            errorMessage = "Directory not found: \(trimmedPath)"
            isLoading = false
            displayedRootPath = nil
            return
        }

        let pathChanged = displayedRootPath != trimmedPath
        if pathChanged, let cachedEntries = LocalFileExplorerCache.entries(for: trimmedPath) {
            rootNode = makeRootNode(path: trimmedPath, entries: cachedEntries, existingRoot: rootNode)
            displayedRootPath = trimmedPath
        }

        isLoading = true
        errorMessage = nil

        let rootURL = URL(fileURLWithPath: trimmedPath)
        let entries = await Task.detached(priority: .userInitiated) {
            loadLocalExplorerChildren(at: rootURL)
        }.value

        LocalFileExplorerCache.store(entries: entries, for: trimmedPath)
        rootNode = makeRootNode(path: trimmedPath, entries: entries, existingRoot: rootNode)
        errorMessage = nil
        isLoading = false
        displayedRootPath = trimmedPath
    }

    private func makeRootNode(
        path: String,
        entries: [LocalFileExplorerEntrySnapshot],
        existingRoot: LocalFileExplorerNode?
    ) -> LocalFileExplorerNode {
        let node = existingRoot?.url.path == path
            ? existingRoot!
            : LocalFileExplorerNode(url: URL(fileURLWithPath: path), isDirectory: true, depth: 0, rootPath: path)
        node.isExpanded = true
        node.didLoadChildren = true
        node.children = reconcileLocalChildNodes(
            existing: node.children,
            from: entries,
            depth: 1,
            rootPath: path
        )
        return node
    }
}

private struct FileExplorerNodeRows: View {
    @ObservedObject var node: LocalFileExplorerNode
    let selectedFilePath: String?
    let onOpenFile: (URL) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            if node.depth > 0 {
                FileExplorerRow(
                    node: node,
                    isSelected: selectedFilePath == node.url.path,
                    onOpenFile: onOpenFile
                )
            }

            if node.isExpanded {
                ForEach(node.children) { child in
                    FileExplorerNodeRows(
                        node: child,
                        selectedFilePath: selectedFilePath,
                        onOpenFile: onOpenFile
                    )
                }
            }
        }
    }
}

private struct FileExplorerRow: View {
    @ObservedObject var node: LocalFileExplorerNode
    let isSelected: Bool
    let onOpenFile: (URL) -> Void
    @State private var isHovering = false

    var body: some View {
        Button {
            if node.isDirectory {
                let nextExpandedState = !node.isExpanded
                LocalFileExplorerCache.setExpanded(
                    nextExpandedState,
                    for: node.url.path,
                    within: node.rootPath
                )
                if nextExpandedState, (!node.didLoadChildren || node.children.isEmpty) {
                    node.loadChildren()
                }
                node.isExpanded = nextExpandedState
            } else {
                onOpenFile(node.url)
            }
        } label: {
            HStack(spacing: 6) {
                if node.isDirectory {
                    Image(systemName: node.isExpanded ? "chevron.down" : "chevron.right")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .frame(width: 10)
                    Image(systemName: "folder")
                } else {
                    Color.clear.frame(width: 10)
                    Image(systemName: "doc")
                }
                Text(node.name)
                    .font(.system(size: 12))
                    .lineLimit(1)

                if node.isLoading {
                    ProgressView()
                        .controlSize(.small)
                        .scaleEffect(0.8)
                }

                Spacer(minLength: 0)
            }
            .padding(.leading, CGFloat(max(0, node.depth - 1)) * 14 + 10)
            .padding(.trailing, 8)
            .padding(.vertical, 5)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(
                        isSelected
                            ? Color.accentColor.opacity(0.14)
                            : (isHovering ? Color.primary.opacity(0.05) : Color.clear)
                    )
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            isHovering = hovering
        }
        .onDrag {
            NSItemProvider(object: node.url as NSURL)
        }
        .contextMenu {
            if !node.isDirectory {
                Button("Copy Path") {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(node.url.path, forType: .string)
                }
            }

            Button(node.isDirectory ? "Reveal in Finder" : "Show in Finder") {
                NSWorkspace.shared.activateFileViewerSelecting([node.url])
            }
        }
    }
}

final class RemoteFileExplorerNode: ObservableObject, Identifiable {
    let path: String
    let name: String
    let isDirectory: Bool
    let depth: Int
    let configuration: WorkspaceRemoteConfiguration

    @Published var isExpanded = false
    @Published var isLoading = false
    @Published var didLoadChildren = false
    @Published var children: [RemoteFileExplorerNode] = []

    init(
        path: String,
        name: String,
        isDirectory: Bool,
        depth: Int,
        configuration: WorkspaceRemoteConfiguration
    ) {
        self.path = path
        self.name = name
        self.isDirectory = isDirectory
        self.depth = depth
        self.configuration = configuration
    }

    var id: String { path }

    func loadChildren() {
        guard isDirectory, !didLoadChildren, !isLoading else { return }
        isLoading = true

        DispatchQueue.global(qos: .userInitiated).async { [configuration, path, depth] in
            let result: Result<[RemoteFileExplorerNode], Error> = Result {
                try RemoteSSHFileService.listDirectory(configuration: configuration, path: path).map { entry in
                    RemoteFileExplorerNode(
                        path: entry.path,
                        name: entry.name,
                        isDirectory: entry.isDirectory,
                        depth: depth + 1,
                        configuration: configuration
                    )
                }
            }

            DispatchQueue.main.async {
                self.isLoading = false
                self.didLoadChildren = true
                switch result {
                case .success(let nodes):
                    self.children = nodes
                case .failure:
                    self.children = []
                }
            }
        }
    }
}

private struct RemoteFileExplorerNodeRows: View {
    @ObservedObject var node: RemoteFileExplorerNode
    let selectedRemotePath: String?
    let onOpenFile: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            if node.depth > 0 {
                RemoteFileExplorerRow(
                    node: node,
                    isSelected: selectedRemotePath == node.path,
                    onOpenFile: onOpenFile
                )
            }

            if node.isExpanded {
                ForEach(node.children) { child in
                    RemoteFileExplorerNodeRows(
                        node: child,
                        selectedRemotePath: selectedRemotePath,
                        onOpenFile: onOpenFile
                    )
                }
            }
        }
    }
}

private struct RemoteFileExplorerRow: View {
    @ObservedObject var node: RemoteFileExplorerNode
    let isSelected: Bool
    let onOpenFile: (String) -> Void

    var body: some View {
        Button {
            if node.isDirectory {
                if !node.didLoadChildren {
                    node.loadChildren()
                }
                node.isExpanded.toggle()
            } else {
                onOpenFile(node.path)
            }
        } label: {
            HStack(spacing: 6) {
                if node.isDirectory {
                    Image(systemName: node.isExpanded ? "chevron.down" : "chevron.right")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .frame(width: 10)
                    Image(systemName: "folder")
                } else {
                    Color.clear.frame(width: 10)
                    Image(systemName: "doc")
                }

                Text(node.name)
                    .font(.system(size: 12))
                    .lineLimit(1)

                if node.isLoading {
                    ProgressView()
                        .controlSize(.small)
                }

                Spacer(minLength: 0)
            }
            .padding(.leading, CGFloat(max(0, node.depth - 1)) * 14 + 10)
            .padding(.trailing, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(isSelected ? Color.accentColor.opacity(0.14) : Color.clear)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onDrag {
            NSItemProvider(object: node.path as NSString)
        }
    }
}

struct ExplorerTextDocument: Equatable {
    let location: ExplorerDocumentLocation
    let url: URL
    let originalText: String
    let text: String
    let isEditable: Bool
    let errorMessage: String?

    var fileName: String {
        url.lastPathComponent
    }

    var isDirty: Bool {
        isEditable && text != originalText
    }

    var displayPath: String {
        switch location {
        case .local(let url):
            return url.path
        case .remote(_, let path):
            return path
        }
    }
}

enum ExplorerTextDocumentLoader {
    static func load(url: URL) -> ExplorerTextDocument {
        guard url.isFileURL else {
            return ExplorerTextDocument(
                location: .local(url),
                url: url,
                originalText: "",
                text: "",
                isEditable: false,
                errorMessage: "Only local files can be opened."
            )
        }

        var resourceValues: URLResourceValues?
        do {
            resourceValues = try url.resourceValues(forKeys: [.isDirectoryKey, .fileSizeKey, .contentTypeKey])
        } catch {
            resourceValues = nil
        }

        if resourceValues?.isDirectory == true {
            return ExplorerTextDocument(
                location: .local(url),
                url: url,
                originalText: "",
                text: "",
                isEditable: false,
                errorMessage: "Directories cannot be opened in the editor."
            )
        }

        if let size = resourceValues?.fileSize, size > 1_000_000 {
            return ExplorerTextDocument(
                location: .local(url),
                url: url,
                originalText: "",
                text: "",
                isEditable: false,
                errorMessage: "File is larger than 1 MB and was not opened in the inline editor."
            )
        }

        if let contentType = resourceValues?.contentType,
           contentType.conforms(to: .image) || contentType.conforms(to: .audiovisualContent) || contentType.conforms(to: .archive) {
            return ExplorerTextDocument(
                location: .local(url),
                url: url,
                originalText: "",
                text: "",
                isEditable: false,
                errorMessage: "This file type is not supported by the inline text editor."
            )
        }

        do {
            let text = try loadText(url: url)
            return ExplorerTextDocument(
                location: .local(url),
                url: url,
                originalText: text,
                text: text,
                isEditable: true,
                errorMessage: nil
            )
        } catch {
            return ExplorerTextDocument(
                location: .local(url),
                url: url,
                originalText: "",
                text: "",
                isEditable: false,
                errorMessage: "Could not read file: \(error.localizedDescription)"
            )
        }
    }

    static func save(text: String, to url: URL) throws {
        try text.write(to: url, atomically: true, encoding: .utf8)
    }

    private static func loadText(url: URL) throws -> String {
        if let text = try? String(contentsOf: url, encoding: .utf8) {
            return text
        }
        if let text = try? String(contentsOf: url, encoding: .unicode) {
            return text
        }
        if let text = try? String(contentsOf: url, encoding: .ascii) {
            return text
        }
        throw NSError(domain: "cmux.explorer.editor", code: 1, userInfo: [
            NSLocalizedDescriptionKey: "Unsupported text encoding"
        ])
    }
}

struct ExplorerTextEditorView: View {
    let document: ExplorerTextDocument
    let onClose: () -> Void
    let onSave: (String) -> Void

    @State private var draftText: String = ""
    @State private var statusMessage: String?

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(document.fileName)
                            .font(.system(size: 12, weight: .semibold))
                        if document.isEditable && draftText != document.originalText {
                            Text("已修改")
                                .font(.system(size: 10, weight: .semibold))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Capsule().fill(Color.orange.opacity(0.18)))
                        }
                    }
                    Text(document.displayPath)
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                Spacer(minLength: 0)

                if document.isEditable {
                    Button("保存") {
                        onSave(draftText)
                        statusMessage = "已保存"
                    }
                    .keyboardShortcut("s", modifiers: [.command])
                }

                Button("关闭") {
                    onClose()
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(.ultraThinMaterial)

            if let errorMessage = document.errorMessage {
                ScrollView {
                    Text(errorMessage)
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                }
            } else {
                PlainTextEditorRepresentable(text: $draftText, isEditable: document.isEditable)
            }

            if let statusMessage {
                HStack {
                    Text(statusMessage)
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.primary.opacity(0.04))
            }
        }
        .background(Color.primary.opacity(0.02))
        .onAppear {
            draftText = document.text
        }
        .onChange(of: document.url.path) {
            draftText = document.text
            statusMessage = nil
        }
    }
}

private struct PlainTextEditorRepresentable: NSViewRepresentable {
    @Binding var text: String
    let isEditable: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = true
        scrollView.autohidesScrollers = true
        scrollView.borderType = .noBorder
        scrollView.drawsBackground = false

        let textView = NSTextView()
        textView.isRichText = false
        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.isAutomaticDashSubstitutionEnabled = false
        textView.isAutomaticTextReplacementEnabled = false
        textView.isAutomaticSpellingCorrectionEnabled = false
        textView.isContinuousSpellCheckingEnabled = false
        textView.font = .monospacedSystemFont(ofSize: 12, weight: .regular)
        textView.textColor = .labelColor
        textView.backgroundColor = .clear
        textView.allowsUndo = true
        textView.isEditable = isEditable
        textView.isSelectable = true
        textView.string = text
        textView.delegate = context.coordinator
        textView.textContainerInset = NSSize(width: 12, height: 12)
        textView.autoresizingMask = [.width]
        textView.isHorizontallyResizable = true
        textView.isVerticallyResizable = true
        textView.maxSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        textView.minSize = NSSize(width: 0, height: 0)

        scrollView.documentView = textView
        context.coordinator.textView = textView
        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        guard let textView = context.coordinator.textView else { return }
        if textView.string != text {
            textView.string = text
        }
        textView.isEditable = isEditable
    }

    final class Coordinator: NSObject, NSTextViewDelegate {
        @Binding var text: String
        weak var textView: NSTextView?

        init(text: Binding<String>) {
            _text = text
        }

        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            text = textView.string
        }
    }
}

struct RemoteHostsSidebar: View {
    let onConnect: (SSHConfigHostEntry) -> Void

    @State private var hosts: [SSHConfigHostEntry] = []
    @State private var editingCredentialHost: SSHConfigHostEntry?
    @State private var credentialDraft = ""
    @State private var credentialStatusMessage: String?
    @State private var credentialStatusIsError = false

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text("SSH 主机")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.secondary)
                Text("来自 ~/.ssh/config")
                    .font(.system(size: 12, weight: .medium))
                Text("密码仅保存在本机钥匙串中。")
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 12)
            .padding(.top, 12)
            .padding(.bottom, 8)

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 2) {
                    if hosts.isEmpty {
                        Text("未找到 SSH 主机。")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(12)
                    } else {
                        ForEach(hosts) { host in
                            HStack(spacing: 8) {
                                Button {
                                    onConnect(host)
                                } label: {
                                    VStack(alignment: .leading, spacing: 2) {
                                        HStack(spacing: 6) {
                                            Text(host.alias)
                                                .font(.system(size: 12, weight: .semibold))
                                            if RemoteHostPasswordStore.hasPassword(for: host.alias) {
                                                Image(systemName: "key.fill")
                                                    .font(.system(size: 10, weight: .semibold))
                                                    .foregroundStyle(.orange)
                                            }
                                        }
                                        Text(host.subtitle)
                                            .font(.system(size: 11))
                                            .foregroundStyle(.secondary)
                                            .lineLimit(1)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(Color.primary.opacity(0.04))
                                    )
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(.plain)

                                Button {
                                    editingCredentialHost = host
                                    credentialDraft = RemoteHostPasswordStore.loadPassword(for: host.alias) ?? ""
                                    credentialStatusMessage = nil
                                    credentialStatusIsError = false
                                } label: {
                                    Image(systemName: RemoteHostPasswordStore.hasPassword(for: host.alias) ? "key.fill" : "key")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundStyle(RemoteHostPasswordStore.hasPassword(for: host.alias) ? Color.orange : Color.secondary)
                                        .frame(width: 30, height: 30)
                                        .background(
                                            RoundedRectangle(cornerRadius: 9, style: .continuous)
                                                .fill(Color.primary.opacity(0.05))
                                        )
                                }
                                .buttonStyle(.plain)
                                .help("保存到钥匙串")
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 2)
                        }
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .background(SidebarBackdrop().ignoresSafeArea())
        .task {
            hosts = SSHConfigLoader.load()
        }
        .sheet(item: $editingCredentialHost) { host in
            NavigationStack {
                Form {
                    Section("主机") {
                        LabeledContent("别名", value: host.alias)
                        LabeledContent("目标", value: host.subtitle)
                    }
                    Section("密码") {
                        SecureField("密码", text: $credentialDraft)
                        Text("密码仅保存在当前 Mac 的本地钥匙串中，iatlas 会在后续连接时复用它。")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        if let credentialStatusMessage {
                            Text(credentialStatusMessage)
                                .font(.caption)
                                .foregroundStyle(credentialStatusIsError ? Color.red : Color.secondary)
                        }
                    }
                }
                .formStyle(.grouped)
                .navigationTitle("远程凭据")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("关闭") {
                            editingCredentialHost = nil
                        }
                    }
                    ToolbarItemGroup(placement: .confirmationAction) {
                        Button("清除") {
                            do {
                                try RemoteHostPasswordStore.clearPassword(for: host.alias)
                                credentialDraft = ""
                                credentialStatusMessage = "已从钥匙串移除密码。"
                                credentialStatusIsError = false
                            } catch {
                                credentialStatusMessage = "清除钥匙串密码失败：\(error.localizedDescription)"
                                credentialStatusIsError = true
                            }
                        }
                        Button("保存") {
                            do {
                                try RemoteHostPasswordStore.savePassword(credentialDraft, for: host.alias)
                                credentialStatusMessage = "密码已保存到钥匙串。"
                                credentialStatusIsError = false
                            } catch {
                                credentialStatusMessage = "保存到钥匙串失败：\(error.localizedDescription)"
                                credentialStatusIsError = true
                            }
                        }
                    }
                }
            }
            .frame(minWidth: 460, minHeight: 250)
        }
    }
}

struct RemoteWorkspaceExplorerSidebar: View {
    @ObservedObject var workspace: Workspace
    let selectedRemotePath: String?
    let onOpenRemoteFile: (String) -> Void

    @State private var rootNode: RemoteFileExplorerNode?
    @State private var resolvedRootPath: String?
    @State private var errorMessage: String?
    @State private var isLoading = false

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 2) {
                    if let errorMessage {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(12)
                    } else if isLoading {
                        HStack(spacing: 8) {
                            ProgressView()
                                .controlSize(.small)
                            Text("正在连接远程主机并读取文件...")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(12)
                    } else if let rootNode {
                        RemoteFileExplorerNodeRows(
                            node: rootNode,
                            selectedRemotePath: selectedRemotePath,
                            onOpenFile: onOpenRemoteFile
                        )
                    } else {
                        emptyStateView
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .background(SidebarBackdrop().ignoresSafeArea())
        .task(id: refreshFingerprint) {
            await reload()
        }
    }

    private var refreshFingerprint: String {
        [
            workspace.remoteConfiguration?.displayTarget ?? "none",
            workspace.remoteConnectionState.rawValue,
            workspace.currentDirectory
        ].joined(separator: "|")
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("远程文件")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.secondary)
                    Text(workspace.remoteDisplayTarget ?? "未连接")
                        .font(.system(size: 12, weight: .medium))
                        .lineLimit(1)
                }

                Spacer(minLength: 0)

                Text(remoteStatusText)
                    .font(.system(size: 10, weight: .semibold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(remoteStatusColor.opacity(0.15)))
                    .foregroundStyle(remoteStatusColor)
            }

            if let resolvedRootPath {
                Text(resolvedRootPath)
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            HStack(spacing: 8) {
                Button("连接") {
                    workspace.reconnectRemoteConnection()
                }
                .disabled(
                    workspace.remoteConfiguration == nil ||
                    workspace.remoteConnectionState == .connecting ||
                    !canAttemptRemoteConnection
                )

                Button("刷新") {
                    Task { await reload(forceRootReload: false) }
                }
                .disabled(workspace.remoteConfiguration == nil || workspace.remoteConnectionState != .connected)

                Button("断开") {
                    workspace.disconnectRemoteConnection(clearConfiguration: false)
                }
                .disabled(workspace.remoteConfiguration == nil)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
        .padding(.top, 12)
        .padding(.bottom, 8)
    }

    private var remoteStatusText: String {
        switch workspace.remoteConnectionState {
        case .connected:
            return "已连接"
        case .connecting:
            return "连接中"
        case .error:
            return "错误"
        case .disconnected:
            return workspace.hasInteractiveRemoteSSHSession ? "等待登录" : "未连接"
        }
    }

    private var remoteStatusColor: Color {
        switch workspace.remoteConnectionState {
        case .connected:
            return .green
        case .connecting:
            return .blue
        case .error:
            return .red
        case .disconnected:
            return workspace.hasInteractiveRemoteSSHSession ? .orange : .secondary
        }
    }

    private var canAttemptRemoteConnection: Bool {
        workspace.hasInteractiveRemoteSSHSession
    }

    @ViewBuilder
    private var emptyStateView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(emptyStateTitle)
                .font(.system(size: 12, weight: .semibold))
            Text(emptyStateMessage)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
    }

    private var emptyStateTitle: String {
        switch workspace.remoteConnectionState {
        case .connected:
            return "尚未加载文件"
        case .connecting:
            return "正在连接远程工作区"
        case .error:
            return "远程连接失败"
        case .disconnected:
            return canAttemptRemoteConnection ? "请先在终端完成 SSH 登录" : "请先从终端发起 SSH 登录"
        }
    }

    private var emptyStateMessage: String {
        if let detail = workspace.remoteConnectionDetail?.trimmingCharacters(in: .whitespacesAndNewlines),
           !detail.isEmpty,
           workspace.remoteConnectionState != .connected {
            return detail
        }
        switch workspace.remoteConnectionState {
        case .connected:
            return "如果远程文件树没有出现，请点击刷新。"
        case .connecting:
            return "iatlas 正在启动远程工作区服务。SSH 连接准备完成后，文件树会自动出现。"
        case .error:
            return "先在终端完成 SSH 登录，然后再点击连接。"
        case .disconnected:
            if canAttemptRemoteConnection {
                return "终端完成 SSH 登录后，点击连接即可启用远程文件树和远程文件编辑。"
            }
            return "先选择主机，在终端中打开交互式 SSH 会话。登录成功前，右侧不会展示远程文件树。"
        }
    }

    private func reload(forceRootReload: Bool = true) async {
        guard let configuration = workspace.remoteConfiguration else {
            rootNode = nil
            resolvedRootPath = nil
            errorMessage = "Select a remote host first."
            return
        }

        guard workspace.remoteConnectionState == .connected else {
            isLoading = false
            rootNode = nil
            resolvedRootPath = nil
            errorMessage = nil
            return
        }

        isLoading = true
        errorMessage = nil
        let preferredCurrentDirectory = workspace.currentDirectory
        let existingResolvedRootPath = resolvedRootPath

        await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                let result: Result<(String, [RemoteExplorerEntry]), Error> = Result {
                    let rootPath: String
                    if let existingRoot = existingResolvedRootPath, !forceRootReload {
                        rootPath = existingRoot
                    } else {
                        rootPath = try RemoteSSHFileService.resolveInitialDirectory(
                            configuration: configuration,
                            preferredPath: preferredCurrentDirectory
                        )
                    }
                    let entries = try RemoteSSHFileService.listDirectory(configuration: configuration, path: rootPath)
                    return (rootPath, entries)
                }

                DispatchQueue.main.async {
                    self.isLoading = false
                    switch result {
                    case .success(let payload):
                        let node = RemoteFileExplorerNode(
                            path: payload.0,
                            name: URL(fileURLWithPath: payload.0).lastPathComponent.isEmpty ? payload.0 : URL(fileURLWithPath: payload.0).lastPathComponent,
                            isDirectory: true,
                            depth: 0,
                            configuration: configuration
                        )
                        node.isExpanded = true
                        node.didLoadChildren = true
                        node.children = payload.1.map {
                            RemoteFileExplorerNode(
                                path: $0.path,
                                name: $0.name,
                                isDirectory: $0.isDirectory,
                                depth: 1,
                                configuration: configuration
                            )
                        }
                        self.resolvedRootPath = payload.0
                        self.rootNode = node
                        self.errorMessage = nil
                    case .failure(let error):
                        self.rootNode = nil
                        self.errorMessage = error.localizedDescription
                    }
                    continuation.resume()
                }
            }
        }
    }
}

extension Workspace {
    func loadRemoteExplorerDocument(path: String) throws -> ExplorerTextDocument {
        guard let configuration = remoteConfiguration else {
            throw NSError(domain: "cmux.remote.explorer", code: 10, userInfo: [
                NSLocalizedDescriptionKey: "Remote workspace is not configured."
            ])
        }
        return try RemoteSSHFileService.loadTextFile(configuration: configuration, path: path)
    }

    func saveRemoteExplorerDocument(path: String, text: String) throws {
        guard let configuration = remoteConfiguration else {
            throw NSError(domain: "cmux.remote.explorer", code: 11, userInfo: [
                NSLocalizedDescriptionKey: "Remote workspace is not configured."
            ])
        }
        try RemoteSSHFileService.saveTextFile(configuration: configuration, path: path, text: text)
    }
}
