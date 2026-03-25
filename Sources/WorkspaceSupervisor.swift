import Foundation
import SwiftUI

struct WorkspaceSupervisorTaskCharter: Codable, Equatable, Sendable {
    var goal: String
    var doneDefinition: String
    var constraints: String
    var scopeNotes: String

    init(
        goal: String = "",
        doneDefinition: String = "",
        constraints: String = "",
        scopeNotes: String = ""
    ) {
        self.goal = goal
        self.doneDefinition = doneDefinition
        self.constraints = constraints
        self.scopeNotes = scopeNotes
    }

    var isEmpty: Bool {
        goal.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            doneDefinition.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            constraints.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            scopeNotes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

struct WorkspaceSupervisorRunEntry: Codable, Equatable, Identifiable, Sendable {
    var id: UUID
    var title: String
    var summary: String
    var outcome: String
    var nextAction: String
    var source: String
    var timestamp: TimeInterval

    init(
        id: UUID = UUID(),
        title: String,
        summary: String,
        outcome: String,
        nextAction: String,
        source: String,
        timestamp: TimeInterval = Date().timeIntervalSince1970
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.outcome = outcome
        self.nextAction = nextAction
        self.source = source
        self.timestamp = timestamp
    }
}

struct WorkspaceSupervisorLoopSettings: Codable, Equatable, Sendable {
    var maxIterations: Int
    var intervalSeconds: Double
    var useLLMReview: Bool
    var stopOnBlocked: Bool
    var stopOnCompleted: Bool

    init(
        maxIterations: Int = 3,
        intervalSeconds: Double = 4,
        useLLMReview: Bool = false,
        stopOnBlocked: Bool = true,
        stopOnCompleted: Bool = true
    ) {
        self.maxIterations = maxIterations
        self.intervalSeconds = intervalSeconds
        self.useLLMReview = useLLMReview
        self.stopOnBlocked = stopOnBlocked
        self.stopOnCompleted = stopOnCompleted
    }
}

enum WorkspaceSupervisorLoopState: String, Codable, Sendable {
    case idle
    case running
    case completed
    case blocked
    case stopped

    var displayText: String {
        switch self {
        case .idle: "空闲"
        case .running: "循环中"
        case .completed: "已完成"
        case .blocked: "已阻塞"
        case .stopped: "已停止"
        }
    }
}

enum WorkspaceSupervisorHealth: String, Codable, CaseIterable, Sendable {
    case idle
    case running
    case attention
    case blocked
    case completed

    var displayText: String {
        switch self {
        case .idle: "待配置"
        case .running: "执行中"
        case .attention: "需关注"
        case .blocked: "已阻塞"
        case .completed: "已完成"
        }
    }

    var tint: Color {
        switch self {
        case .idle: .secondary
        case .running: .blue
        case .attention: .orange
        case .blocked: .red
        case .completed: .green
        }
    }
}

struct WorkspaceSupervisorReview: Codable, Equatable, Sendable {
    var health: WorkspaceSupervisorHealth
    var summary: String
    var reason: String
    var nextAction: String
    var suggestedPrompt: String
    var source: String
    var model: String?
    var generatedAt: TimeInterval
}

struct WorkspaceSupervisorStartupPlan: Codable, Equatable, Sendable {
    var goal: String
    var progressSummary: String
    var recommendedAction: String
    var starterPrompt: String
    var assumptions: String
    var source: String
    var model: String?
    var generatedAt: TimeInterval
}

struct WorkspaceSupervisorExecutionBrief: Codable, Equatable, Sendable {
    var title: String
    var objective: String
    var executionSteps: [String]
    var successSignals: [String]
    var risks: [String]
    var operatorPrompt: String
    var source: String
    var model: String?
    var generatedAt: TimeInterval
}

struct WorkspaceSupervisorPanelHandoff: Codable, Equatable, Identifiable, Sendable {
    var id: UUID
    var panelID: UUID
    var panelTitle: String
    var panelType: String
    var workingDirectory: String
    var objective: String
    var nextAction: String
    var status: String
    var operatorPrompt: String
    var source: String
    var generatedAt: TimeInterval
}

struct WorkspaceSupervisorPanelRoundEntry: Codable, Equatable, Identifiable, Sendable {
    var id: UUID
    var iteration: Int
    var panelID: UUID
    var status: String
    var summary: String
    var outcome: String
    var nextAction: String
    var source: String
    var timestamp: TimeInterval

    init(
        id: UUID = UUID(),
        iteration: Int,
        panelID: UUID,
        status: String,
        summary: String,
        outcome: String,
        nextAction: String,
        source: String,
        timestamp: TimeInterval = Date().timeIntervalSince1970
    ) {
        self.id = id
        self.iteration = iteration
        self.panelID = panelID
        self.status = status
        self.summary = summary
        self.outcome = outcome
        self.nextAction = nextAction
        self.source = source
        self.timestamp = timestamp
    }
}

struct WorkspaceSupervisorPanelRoundState: Codable, Equatable, Identifiable, Sendable {
    var id: UUID
    var panelID: UUID
    var panelTitle: String
    var panelType: String
    var workingDirectory: String
    var status: String
    var iterationCount: Int
    var lastSummary: String
    var lastOutcome: String
    var nextAction: String
    var source: String
    var lastUpdatedAt: TimeInterval
    var history: [WorkspaceSupervisorPanelRoundEntry]
}

struct WorkspaceSupervisorQueueItem: Codable, Equatable, Identifiable, Sendable {
    var id: UUID
    var panelID: UUID
    var panelTitle: String
    var role: String
    var priority: Int
    var dependsOnPanelID: UUID?
    var readiness: String
    var nextMilestone: String
    var rotationRule: String
    var generatedAt: TimeInterval
}

struct WorkspaceSupervisorLoopTarget: Codable, Equatable, Sendable {
    var panelID: UUID
    var panelTitle: String
    var workingDirectory: String
    var selectedAt: TimeInterval
}

struct WorkspaceSupervisorSnapshot: Sendable {
    var title: String
    var customTitle: String?
    var currentDirectory: String
    var observedDirectories: [String]
    var goal: String
    var doneDefinition: String
    var constraints: String
    var scopeNotes: String
    var progressValue: Double?
    var progressLabel: String?
    var gitBranch: String?
    var gitDirty: Bool
    var remoteTarget: String?
    var remoteState: String
    var remoteDetail: String?
    var statusEntries: [(key: String, value: String)]
    var recentLogs: [String]
    var recentRunHeadlines: [String]
    var focusedPanelDirectory: String?
}

enum WorkspaceSupervisorHeuristics {
    private static func stageLabel(snapshot: WorkspaceSupervisorSnapshot, interactions: String = "") -> String {
        let normalizedGoal = snapshot.goal.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedInteractions = interactions.lowercased()
        let recentSignals = (
            snapshot.recentLogs
            + snapshot.statusEntries.map(\.value)
            + snapshot.recentRunHeadlines
        )
        .joined(separator: "\n")
        .lowercased()

        if normalizedGoal.isEmpty {
            return "待澄清"
        }
        if recentSignals.contains("completed successfully")
            || recentSignals.contains("task_complete")
            || snapshot.progressValue.map({ $0 >= 0.999 }) == true {
            return "已完成"
        }
        if recentSignals.contains("error")
            || recentSignals.contains("failed")
            || recentSignals.contains("blocked")
            || recentSignals.contains("permission denied") {
            return "阻塞中"
        }
        if normalizedInteractions.contains("规划")
            || normalizedInteractions.contains("目标")
            || snapshot.recentRunHeadlines.isEmpty {
            return "准备开工"
        }
        if snapshot.gitDirty || snapshot.progressValue != nil {
            return "执行中"
        }
        return "推进中"
    }

    private static func contextBulletLines(snapshot: WorkspaceSupervisorSnapshot) -> [String] {
        var lines: [String] = []
        lines.append("当前目录：\(snapshot.currentDirectory)")
        if let focusedPanelDirectory = snapshot.focusedPanelDirectory, !focusedPanelDirectory.isEmpty {
            lines.append("聚焦面板目录：\(focusedPanelDirectory)")
        }
        if !snapshot.observedDirectories.isEmpty {
            lines.append("已访问目录：\(snapshot.observedDirectories.joined(separator: ", "))")
        }
        if let gitBranch = snapshot.gitBranch, !gitBranch.isEmpty {
            lines.append("Git：\(gitBranch)\(snapshot.gitDirty ? "（有未提交改动）" : "（干净）")")
        }
        if let remoteTarget = snapshot.remoteTarget, !remoteTarget.isEmpty {
            let remoteDetail = snapshot.remoteDetail?.trimmingCharacters(in: .whitespacesAndNewlines)
            lines.append("远程：\(remoteTarget) / \(snapshot.remoteState)\(remoteDetail?.isEmpty == false ? " / \(remoteDetail!)" : "")")
        }
        if !snapshot.recentRunHeadlines.isEmpty {
            lines.append("最近监督记录：\(snapshot.recentRunHeadlines.joined(separator: " | "))")
        }
        return lines
    }

    static func evaluate(snapshot: WorkspaceSupervisorSnapshot) -> WorkspaceSupervisorReview {
        let normalizedGoal = snapshot.goal.trimmingCharacters(in: .whitespacesAndNewlines)
        let recentText = ([snapshot.remoteDetail] + snapshot.statusEntries.map(\.value) + snapshot.recentLogs + snapshot.recentRunHeadlines)
            .compactMap { $0?.lowercased() }
            .joined(separator: "\n")

        let health: WorkspaceSupervisorHealth
        let reason: String
        let summary: String
        let nextAction: String
        let suggestedPrompt: String

        if normalizedGoal.isEmpty {
            health = .idle
            reason = "当前工作区还没有设置明确目标。"
            summary = "监督器处于待配置状态，因为工作区缺少明确目标。"
            nextAction = snapshot.doneDefinition.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                ? "先补充一个可以验收的目标，再让监督器判断进度和下一步。"
                : "先补充明确目标，再结合完成标准让监督器判断进度和下一步。"
            suggestedPrompt = "目标：请描述这个工作区最终必须交付的结果。"
        } else if recentText.contains("task_complete")
            || recentText.contains("completed successfully")
            || snapshot.progressValue.map({ $0 >= 0.999 }) == true {
            health = .completed
            reason = "最近的工作区信号显示任务已经完成。"
            summary = "当前工作区看起来已经达成目标。"
            nextAction = "先核验交付物，再决定归档工作区还是分配新的目标。"
            suggestedPrompt = "请确认目标是否已完全完成，总结交付结果，并列出剩余风险。"
        } else if recentText.contains("error")
            || recentText.contains("failed")
            || recentText.contains("exception")
            || recentText.contains("traceback")
            || recentText.contains("permission denied")
            || recentText.contains("blocked") {
            health = .blocked
            reason = "最近的日志或侧边栏元数据里出现了明确报错或阻塞。"
            summary = "当前工作区已被阻塞，需要人工干预。"
            nextAction = "先检查最新失败命令或工具输出，再给出最小修正动作。"
            suggestedPrompt = "你当前被阻塞。请仔细阅读最近错误，定位根因，并给出继续推进“\(normalizedGoal)”的最小修复步骤。"
        } else if snapshot.remoteState == "disconnected" && snapshot.remoteDetail?.isEmpty == false {
            health = .attention
            reason = "当前工作区的远程连接存在问题，可能影响继续执行。"
            summary = "远程会话状态异常，需要优先关注。"
            nextAction = "优先恢复远程连接，或者切回本地工作区继续推进。"
            suggestedPrompt = "远程会话不健康。如果安全可行，请重连；否则说明是什么阻碍了“\(normalizedGoal)”的推进。"
        } else {
            health = .running
            reason = "工作区已有明确目标，且当前没有检测到明显阻塞。"
            summary = "当前工作区看起来在正常推进中。"
            if let label = snapshot.progressLabel, !label.isEmpty {
                nextAction = "继续当前计划，并围绕“\(label)”定期核对进展。"
            } else {
                nextAction = "继续执行，并把最新输出与工作区目标逐条比对。"
            }
            suggestedPrompt = "当前目标：\(normalizedGoal)\n请评估最新状态，判断任务是否在正轨上，并给出最安全的下一步。"
        }

        return WorkspaceSupervisorReview(
            health: health,
            summary: summary,
            reason: reason,
            nextAction: nextAction,
            suggestedPrompt: suggestedPrompt,
            source: "heuristic",
            model: nil,
            generatedAt: Date().timeIntervalSince1970
        )
    }

    static func prepareStartupPlan(
        snapshot: WorkspaceSupervisorSnapshot,
        interactions: String
    ) -> WorkspaceSupervisorStartupPlan {
        let trimmed = interactions.trimmingCharacters(in: .whitespacesAndNewlines)
        let interactionLines = trimmed
            .split(whereSeparator: \.isNewline)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        let stage = stageLabel(snapshot: snapshot, interactions: trimmed)
        let contextLines = contextBulletLines(snapshot: snapshot)
        let inferredGoal = snapshot.goal.isEmpty
            ? (interactionLines.first ?? "整理需求并形成一个可执行、可验收的工作目标。")
            : snapshot.goal
        let progress = snapshot.recentLogs.isEmpty && snapshot.recentRunHeadlines.isEmpty
            ? "当前项目进度信息较少，需要先根据用户最近 2-3 轮交流补齐上下文；当前阶段判断为“\(stage)”。"
            : "已读取到最近工作区日志、监督记录与运行状态；当前阶段判断为“\(stage)”，可以据此快速定位当前进展与阻塞点。"
        let nextAction = interactionLines.isEmpty
            ? "先补充 2-3 轮用户需求或补充说明，再生成可执行开工建议。"
            : "基于最近交流整理目标、确认约束、拆出第一步可执行动作，然后立即开工。"
        let prompt = """
        请根据以下用户交流，提炼最终目标、当前进度判断、约束条件，并直接给出第一步执行动作。
        请优先结合这些工作区信号：
        \(contextLines.joined(separator: "\n"))

        当前判断阶段：\(stage)

        输出要求：
        1. 先用一句话说明当前到底处于哪个阶段。
        2. 给出一个可以立即执行的第一步。
        3. 如果信息不足，只允许提出一个最关键的澄清问题。

        最近用户交流：
        \(trimmed.isEmpty ? "暂无交流内容" : trimmed)
        """

        return WorkspaceSupervisorStartupPlan(
            goal: inferredGoal,
            progressSummary: progress,
            recommendedAction: nextAction,
            starterPrompt: prompt,
            assumptions: interactionLines.isEmpty ? "缺少最近交流内容，当前建议偏保守。" : "已根据最近 2-3 轮交流做了初步目标提炼，仍需你最终确认。",
            source: "heuristic",
            model: nil,
            generatedAt: Date().timeIntervalSince1970
        )
    }

    static func prepareExecutionBrief(
        snapshot: WorkspaceSupervisorSnapshot,
        review: WorkspaceSupervisorReview?,
        startupPlan: WorkspaceSupervisorStartupPlan?
    ) -> WorkspaceSupervisorExecutionBrief {
        let effectiveGoal = snapshot.goal.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? (startupPlan?.goal.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false
                ? startupPlan?.goal ?? "推进当前工作区任务。"
                : "推进当前工作区任务。")
            : snapshot.goal
        let effectiveAction = review?.nextAction ?? startupPlan?.recommendedAction ?? "检查当前状态并执行最小下一步。"
        let stage = stageLabel(snapshot: snapshot)
        let executionDirectory = snapshot.focusedPanelDirectory?.isEmpty == false
            ? snapshot.focusedPanelDirectory ?? snapshot.currentDirectory
            : snapshot.currentDirectory

        var executionSteps: [String] = [
            "先核对目标、完成标准和当前目录，确认本轮只推进“\(effectiveGoal)”。",
            effectiveAction,
            "优先在目录 \(executionDirectory) 内执行本轮动作，并记录关键输出。"
        ]
        if let remoteTarget = snapshot.remoteTarget, !remoteTarget.isEmpty {
            executionSteps.append("如果动作依赖远程环境，先确认 \(remoteTarget) 连接正常，再继续执行。")
        }

        var successSignals: [String] = []
        if let progressLabel = snapshot.progressLabel, !progressLabel.isEmpty {
            successSignals.append("进度标签出现新的推进信号：\(progressLabel)")
        }
        successSignals.append("最新日志不再出现明显错误，且输出能证明当前动作已经完成。")
        successSignals.append("完成后可以明确判断任务状态是继续推进、已阻塞，还是已完成。")

        var risks: [String] = []
        if snapshot.gitDirty {
            risks.append("仓库存在未提交修改，执行动作时不要覆盖已有改动。")
        }
        if let review, review.health == .blocked {
            risks.append("监督器已判断为阻塞状态，本轮应优先解阻，而不是继续扩张范围。")
        }
        if let remoteTarget = snapshot.remoteTarget, !remoteTarget.isEmpty {
            risks.append("当前动作可能依赖远程目标 \(remoteTarget)，需要避免在断连状态下误判执行结果。")
        }
        if risks.isEmpty {
            risks.append("不要扩大任务范围；如果信息不足，只补一个最关键的缺口。")
        }

        let constraintsText = (snapshot.constraints + "\n" + snapshot.scopeNotes)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let operatorPrompt = """
        You are executing one bounded step inside this workspace.

        Goal:
        \(effectiveGoal)

        Current stage:
        \(stage)

        Working directory:
        \(executionDirectory)

        Constraints:
        \(constraintsText.isEmpty ? "Use minimal, scope-safe changes only." : constraintsText)

        Do exactly this next:
        \(effectiveAction)

        Success signals:
        \(successSignals.enumerated().map { "\($0.offset + 1). \($0.element)" }.joined(separator: "\n"))

        Before stopping, summarize what changed, what remains, and whether the task is blocked, running, or complete.
        """

        return WorkspaceSupervisorExecutionBrief(
            title: "执行简报: \(stage)",
            objective: effectiveGoal,
            executionSteps: executionSteps,
            successSignals: successSignals,
            risks: risks,
            operatorPrompt: operatorPrompt,
            source: "heuristic",
            model: nil,
            generatedAt: Date().timeIntervalSince1970
        )
    }

    static func handoffStatus(for review: WorkspaceSupervisorReview?) -> String {
        switch review?.health {
        case .completed: return "completed"
        case .blocked: return "blocked"
        case .attention: return "attention"
        case .running: return "running"
        default: return "ready"
        }
    }

    static func handoffDisplayStatus(_ status: String) -> String {
        switch status {
        case "completed": return "已完成"
        case "blocked": return "已阻塞"
        case "attention": return "需关注"
        case "running": return "执行中"
        case "supporting": return "支援中"
        case "pending": return "待处理"
        default: return "就绪"
        }
    }
}

enum WorkspaceSupervisorSettings {
    static let endpointKey = "workspaceSupervisor.endpoint"
    static let apiKeyKey = "workspaceSupervisor.apiKey"
    static let modelKey = "workspaceSupervisor.model"
    static let defaultEndpoint = "https://api.openai.com/v1/chat/completions"
    static let defaultModel = "gpt-4.1-mini"
}

struct SupervisorPaneView: View {
    @ObservedObject var workspace: Workspace
    @AppStorage(WorkspaceSupervisorSettings.endpointKey) private var endpoint = WorkspaceSupervisorSettings.defaultEndpoint
    @AppStorage(WorkspaceSupervisorSettings.apiKeyKey) private var apiKey = ""
    @AppStorage(WorkspaceSupervisorSettings.modelKey) private var model = WorkspaceSupervisorSettings.defaultModel
    @State private var isQuickStarting = false
    @State private var isRunningLLMReview = false
    @State private var isGeneratingStartupPlan = false
    @State private var isGeneratingExecutionBrief = false
    @State private var isRefreshingPanelHandoffs = false
    @State private var supervisorDispatchStatus: String?
    @State private var llmSettingsSavedAt = Date()

    private var review: WorkspaceSupervisorReview? {
        workspace.supervisorLastReview
    }

    private var updatedText: String {
        guard let date = workspace.supervisorUpdatedAt else { return "尚未生成评估" }
        return date.formatted(date: .abbreviated, time: .shortened)
    }

    private var llmSavedText: String {
        "LLM 设置已自动保存到本机 \(llmSettingsSavedAt.formatted(date: .omitted, time: .shortened))"
    }

    private var reviewHealth: WorkspaceSupervisorHealth {
        review?.health ?? .idle
    }

    private var recentRuns: [WorkspaceSupervisorRunEntry] {
        Array(workspace.supervisorRunJournal.prefix(6))
    }

    private var recentPanelStates: [WorkspaceSupervisorPanelRoundState] {
        Array(
            workspace.supervisorPanelRoundStates
                .sorted { lhs, rhs in
                    lhs.lastUpdatedAt > rhs.lastUpdatedAt
                }
                .prefix(6)
        )
    }

    private var queueItems: [WorkspaceSupervisorQueueItem] {
        Array(workspace.supervisorExecutionQueue.prefix(6))
    }

    private var canSendToCurrentWindow: Bool {
        workspace.canDispatchSupervisorPrompt(preferredPanelID: workspace.focusedPanelId)
    }

    private var canSendToActiveWindow: Bool {
        workspace.canDispatchSupervisorPrompt(preferredPanelID: workspace.supervisorActiveLoopTarget?.panelID)
    }

    private var loopStateText: String {
        workspace.supervisorLoopState.displayText
    }

    private var interactionLines: [String] {
        workspace.supervisorInteractionNotes
            .split(whereSeparator: \.isNewline)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    private var interactionCharacterCount: Int {
        workspace.supervisorInteractionNotes
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .count
    }

    private var canQuickStartSupervisor: Bool {
        !workspace.supervisorTaskCharter.goal.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || interactionLines.count >= 2
            || interactionCharacterCount >= 32
    }

    private var quickStartStatusText: String {
        if !workspace.supervisorTaskCharter.goal.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "已具备明确目标，可以直接生成执行简报并进入监督。"
        }
        if interactionLines.count >= 2 || interactionCharacterCount >= 32 {
            return "最近交流信息已足够，监督器可以直接提炼目标并开工。"
        }
        return "再补充 2-3 轮用户交流，或直接填写目标，即可一键进入自动化监督。"
    }

    private var quickStartButtonTitle: String {
        apiKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "一键开工" : "一键开工（LLM 增强）"
    }

    private var metricColumns: [GridItem] {
        [GridItem(.adaptive(minimum: 118, maximum: 180), spacing: 10, alignment: .top)]
    }

    private var compactInfoColumns: [GridItem] {
        [GridItem(.adaptive(minimum: 220, maximum: .infinity), spacing: 12, alignment: .top)]
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                SupervisorSurface {
                    VStack(alignment: .leading, spacing: 14) {
                        HStack(alignment: .top, spacing: 12) {
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [reviewHealth.tint.opacity(0.92), reviewHealth.tint.opacity(0.62)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 40, height: 40)
                                .overlay {
                                    Image(systemName: "brain")
                                        .font(.system(size: 17, weight: .bold))
                                        .foregroundStyle(.white)
                                }

                            VStack(alignment: .leading, spacing: 5) {
                                HStack(alignment: .center, spacing: 8) {
                                    Text("监督器")
                                        .font(.title3.weight(.semibold))
                                    Text(reviewHealth.displayText)
                                        .font(.caption.weight(.semibold))
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .foregroundStyle(reviewHealth == .idle ? Color.primary : Color.white)
                                        .background(
                                            Capsule(style: .continuous)
                                                .fill(reviewHealth == .idle ? reviewHealth.tint.opacity(0.16) : reviewHealth.tint)
                                        )
                                }

                                Text("根据目标、目录、远程状态和最近交流，快速判断是否已经具备开工条件。")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }

                            Spacer(minLength: 0)
                        }

                        LazyVGrid(columns: metricColumns, alignment: .leading, spacing: 10) {
                            SupervisorMetricPill(title: "目标", value: workspace.supervisorTaskCharter.goal.isEmpty ? "未设置" : "已设定")
                            SupervisorMetricPill(title: "开工建议", value: workspace.supervisorStartupPlan == nil ? "未生成" : "已生成")
                            SupervisorMetricPill(title: "执行简报", value: workspace.supervisorExecutionBrief == nil ? "未生成" : "已生成")
                            SupervisorMetricPill(title: "窗口交接", value: "\(workspace.supervisorPanelHandoffs.count) 个")
                            SupervisorMetricPill(title: "当前窗口", value: workspace.supervisorActiveLoopTarget?.panelTitle ?? "未选定")
                            SupervisorMetricPill(title: "自动循环", value: loopStateText)
                            SupervisorMetricPill(title: "运行记录", value: "\(workspace.supervisorRunJournal.count) 条")
                            SupervisorMetricPill(title: "最近更新", value: updatedText)
                        }

                        HStack(alignment: .center, spacing: 10) {
                            Toggle("启用监督", isOn: $workspace.supervisorEnabled)
                                .toggleStyle(.switch)

                            Spacer(minLength: 0)

                            Button("刷新判断") {
                                workspace.refreshSupervisorHeuristicReview()
                            }
                            .buttonStyle(SupervisorSecondaryButtonStyle())
                            .disabled(!workspace.supervisorEnabled)

                            Button(isRunningLLMReview ? "评估中..." : "运行 LLM 评估") {
                                Task {
                                    isRunningLLMReview = true
                                    await workspace.requestSupervisorLLMReview(
                                        endpoint: endpoint,
                                        apiKey: apiKey,
                                        model: model
                                    )
                                    isRunningLLMReview = false
                                }
                            }
                            .buttonStyle(SupervisorPrimaryButtonStyle())
                            .disabled(!workspace.supervisorEnabled || isRunningLLMReview)
                        }
                    }
                }

                LazyVGrid(columns: compactInfoColumns, alignment: .leading, spacing: 12) {
                    SupervisorSection(title: "任务章程", subtitle: "先补全目标、完成标准、约束和执行范围，再进入自动监督。") {
                        SupervisorLabeledEditor(
                            title: "目标",
                            text: Binding(
                                get: { workspace.supervisorTaskCharter.goal },
                                set: {
                                    workspace.supervisorTaskCharter.goal = $0
                                    workspace.supervisorGoal = $0
                                }
                            ),
                            minHeight: 86
                        )
                        SupervisorLabeledEditor(title: "完成标准", text: $workspace.supervisorTaskCharter.doneDefinition, minHeight: 72)
                        SupervisorLabeledEditor(title: "约束条件", text: $workspace.supervisorTaskCharter.constraints, minHeight: 72)
                        SupervisorLabeledEditor(title: "执行范围", text: $workspace.supervisorTaskCharter.scopeNotes, minHeight: 72)
                    }

                    SupervisorSection(title: "自动循环", subtitle: "为每个窗口自动轮转监督，适合多窗口并行推进。") {
                        VStack(alignment: .leading, spacing: 10) {
                            Stepper("最大轮次 \(workspace.supervisorLoopSettings.maxIterations)", value: $workspace.supervisorLoopSettings.maxIterations, in: 1...12)
                            Stepper(
                                "间隔 \(Int(workspace.supervisorLoopSettings.intervalSeconds)) 秒",
                                value: $workspace.supervisorLoopSettings.intervalSeconds,
                                in: 1...30,
                                step: 1
                            )
                        }

                        Divider()

                        Toggle("循环时使用 LLM 评估", isOn: $workspace.supervisorLoopSettings.useLLMReview)
                        Toggle("遇到阻塞时停止", isOn: $workspace.supervisorLoopSettings.stopOnBlocked)
                        Toggle("识别完成时停止", isOn: $workspace.supervisorLoopSettings.stopOnCompleted)

                        HStack(spacing: 10) {
                            Button(workspace.supervisorLoopState == .running ? "循环执行中..." : "启动自动循环") {
                                Task {
                                    await workspace.runSupervisorAutonomyLoop(
                                        endpoint: endpoint,
                                        apiKey: apiKey,
                                        model: model
                                    )
                                }
                            }
                            .buttonStyle(SupervisorPrimaryButtonStyle())
                            .disabled(!workspace.supervisorEnabled || workspace.supervisorLoopState == .running)

                            Button("停止循环") {
                                workspace.stopSupervisorAutonomyLoop(reason: "manual")
                            }
                            .buttonStyle(SupervisorSecondaryButtonStyle())
                            .disabled(workspace.supervisorLoopState != .running)
                        }

                        if let summary = workspace.supervisorLoopStatusSummary, !summary.isEmpty {
                            Text(summary)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }

                SupervisorSection(title: "最近 2-3 轮用户交流", subtitle: "整理用户刚刚给出的目标、限制和偏好，监督器会据此生成开工建议。") {
                    SupervisorLabeledEditor(title: "交流摘要", text: $workspace.supervisorInteractionNotes, minHeight: 132)

                    SupervisorReviewCard(
                        title: "最快开工路径",
                        content: quickStartStatusText
                    )

                    HStack(spacing: 10) {
                        Button(isQuickStarting ? "开工中..." : quickStartButtonTitle) {
                            Task {
                                isQuickStarting = true
                                await workspace.quickStartSupervisor(
                                    endpoint: endpoint,
                                    apiKey: apiKey,
                                    model: model
                                )
                                isQuickStarting = false
                            }
                        }
                        .buttonStyle(SupervisorPrimaryButtonStyle())
                        .disabled(!canQuickStartSupervisor || isQuickStarting)

                        Button(isGeneratingStartupPlan ? "生成中..." : "生成开工建议") {
                            Task {
                                isGeneratingStartupPlan = true
                                await workspace.requestSupervisorStartupPlan(
                                    endpoint: endpoint,
                                    apiKey: apiKey,
                                    model: model
                                )
                                isGeneratingStartupPlan = false
                            }
                        }
                        .buttonStyle(SupervisorSecondaryButtonStyle())

                        if let startupPlan = workspace.supervisorStartupPlan, !startupPlan.goal.isEmpty {
                            Button("采用建议目标") {
                                workspace.supervisorTaskCharter.goal = startupPlan.goal
                                workspace.supervisorGoal = startupPlan.goal
                                workspace.supervisorEnabled = true
                                workspace.scheduleSupervisorHeuristicRefresh(delay: 0.1)
                            }
                            .buttonStyle(SupervisorSecondaryButtonStyle())
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("环境上下文")
                        .font(.headline)
                    LazyVGrid(columns: compactInfoColumns, alignment: .leading, spacing: 12) {
                        SupervisorReviewCard(title: "当前目录", content: workspace.supervisorSnapshot.currentDirectory, monospaced: true)
                        if let remoteTarget = workspace.supervisorSnapshot.remoteTarget, !remoteTarget.isEmpty {
                            SupervisorReviewCard(title: "远程目标", content: remoteTarget)
                        }
                        if !workspace.supervisorSnapshot.observedDirectories.isEmpty {
                            SupervisorReviewCard(
                                title: "已记录目录",
                                content: workspace.supervisorSnapshot.observedDirectories.joined(separator: "\n"),
                                monospaced: true
                            )
                        }
                    }
                }

                if let startupPlan = workspace.supervisorStartupPlan {
                    VStack(alignment: .leading, spacing: 10) {
                        SupervisorReviewCard(title: "建议目标", content: startupPlan.goal)
                        SupervisorReviewCard(title: "当前进度判断", content: startupPlan.progressSummary)
                        SupervisorReviewCard(title: "建议下一步", content: startupPlan.recommendedAction)
                        SupervisorReviewCard(title: "可直接开工的提示词", content: startupPlan.starterPrompt, monospaced: true)
                        SupervisorReviewCard(title: "前提假设", content: startupPlan.assumptions)
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("执行简报")
                            .font(.headline)
                        Spacer()
                        Button("发送到当前窗口") {
                            supervisorDispatchStatus = workspace.dispatchSupervisorPromptToCurrentPanel()
                        }
                        .buttonStyle(SupervisorSecondaryButtonStyle())
                        .disabled(!canSendToCurrentWindow)

                        Button("发送到循环窗口") {
                            supervisorDispatchStatus = workspace.dispatchSupervisorPromptToActiveLoopPanel()
                        }
                        .buttonStyle(SupervisorPrimaryButtonStyle())
                        .disabled(!canSendToActiveWindow)

                        Button(isGeneratingExecutionBrief ? "生成中..." : "生成执行简报") {
                            Task {
                                isGeneratingExecutionBrief = true
                                await workspace.requestSupervisorExecutionBrief(
                                    endpoint: endpoint,
                                    apiKey: apiKey,
                                    model: model
                                )
                                isGeneratingExecutionBrief = false
                            }
                        }
                        .buttonStyle(SupervisorSecondaryButtonStyle())
                    }

                    if let supervisorDispatchStatus,
                       !supervisorDispatchStatus.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        Text(supervisorDispatchStatus)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.secondary)
                    }

                    if let executionBrief = workspace.supervisorExecutionBrief {
                        SupervisorReviewCard(title: "执行标题", content: executionBrief.title)
                        SupervisorReviewCard(title: "执行目标", content: executionBrief.objective)
                        SupervisorReviewCard(title: "执行步骤", content: executionBrief.executionSteps.joined(separator: "\n"))
                        SupervisorReviewCard(title: "成功信号", content: executionBrief.successSignals.joined(separator: "\n"))
                        SupervisorReviewCard(title: "风险提醒", content: executionBrief.risks.joined(separator: "\n"))
                        SupervisorReviewCard(title: "可直接交给执行模型的提示词", content: executionBrief.operatorPrompt, monospaced: true)
                    } else {
                        SupervisorReviewCard(
                            title: "尚无执行简报",
                            content: "生成后会提供一个有边界的任务包，包含当前目标、执行步骤、成功信号和可直接交给执行模型的提示词。"
                        )
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("窗口交接")
                            .font(.headline)
                        Spacer()
                        Button(isRefreshingPanelHandoffs ? "刷新中..." : "刷新窗口交接") {
                            isRefreshingPanelHandoffs = true
                            workspace.refreshSupervisorPanelHandoffs()
                            isRefreshingPanelHandoffs = false
                        }
                        .buttonStyle(SupervisorSecondaryButtonStyle())
                    }

                    if let activeTarget = workspace.supervisorActiveLoopTarget {
                        SupervisorReviewCard(
                            title: "当前循环目标",
                            content: """
                            窗口: \(activeTarget.panelTitle)
                            目录: \(activeTarget.workingDirectory)
                            选定时间: \(Date(timeIntervalSince1970: activeTarget.selectedAt).formatted(date: .omitted, time: .shortened))
                            """,
                            monospaced: true
                        )
                    }

                    if workspace.supervisorPanelHandoffs.isEmpty {
                        SupervisorReviewCard(
                            title: "尚无窗口交接",
                            content: "交接合同会按当前活跃面板生成，每个窗口都会有自己的目标、下一步动作和执行提示词。"
                        )
                    } else {
                        ForEach(workspace.supervisorPanelHandoffs.prefix(6)) { handoff in
                            SupervisorReviewCard(
                                title: "\(handoff.panelTitle) [\(handoff.status)]",
                                content: """
                                类型: \(handoff.panelType)
                                目录: \(handoff.workingDirectory)
                                目标: \(handoff.objective)
                                下一步: \(handoff.nextAction)

                                \(handoff.operatorPrompt)
                                """,
                                monospaced: true
                            )
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("执行队列")
                        .font(.headline)

                    if queueItems.isEmpty {
                        SupervisorReviewCard(
                            title: "尚无执行队列",
                            content: "生成窗口交接后，这里会显示窗口优先级、依赖关系和何时轮转到下一个窗口。"
                        )
                    } else {
                        ForEach(queueItems) { item in
                            SupervisorReviewCard(
                                title: "#\(item.priority) \(item.panelTitle)",
                                content: """
                                角色: \(item.role)
                                就绪状态: \(item.readiness)
                                依赖窗口: \(item.dependsOnPanelID?.uuidString ?? "无")
                                下一里程碑: \(item.nextMilestone)
                                轮转规则: \(item.rotationRule)
                                """,
                                monospaced: true
                            )
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("窗口轮次状态")
                        .font(.headline)

                    if recentPanelStates.isEmpty {
                        SupervisorReviewCard(
                            title: "尚无轮次状态",
                            content: "自动循环运行后，会在这里记录每个窗口最近一轮的状态、动作和结果。"
                        )
                    } else {
                        ForEach(recentPanelStates) { state in
                            let historyText = state.history.prefix(3).map { entry in
                                "第 \(entry.iteration) 轮 [\(WorkspaceSupervisorHeuristics.handoffDisplayStatus(entry.status))] \(entry.summary)"
                            }.joined(separator: "\n")
                            SupervisorReviewCard(
                                title: "\(state.panelTitle) [\(WorkspaceSupervisorHeuristics.handoffDisplayStatus(state.status))]",
                                content: """
                                类型: \(state.panelType)
                                目录: \(state.workingDirectory)
                                已运行轮次: \(state.iterationCount)
                                最近摘要: \(state.lastSummary)
                                最近结果: \(state.lastOutcome)
                                下一步: \(state.nextAction)

                                最近历史:
                                \(historyText.isEmpty ? "暂无历史记录" : historyText)
                                """,
                                monospaced: true
                            )
                        }
                    }
                }

                if let review {
                    VStack(alignment: .leading, spacing: 10) {
                        SupervisorReviewCard(title: "进度摘要", content: review.summary)
                        SupervisorReviewCard(title: "判断依据", content: review.reason)
                        SupervisorReviewCard(title: "当前建议动作", content: review.nextAction)
                        SupervisorReviewCard(title: "监督提示词", content: review.suggestedPrompt, monospaced: true)
                    }
                } else {
                    SupervisorReviewCard(
                        title: "进度摘要",
                        content: "正在整理当前工作区状态，稍后会生成监督判断。"
                    )
                }

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("运行日志")
                            .font(.headline)
                        Spacer()
                        Button("记录当前判断") {
                            workspace.recordSupervisorCheckpoint(source: "manual")
                        }
                        .buttonStyle(SupervisorSecondaryButtonStyle())
                    }

                    if recentRuns.isEmpty {
                        SupervisorReviewCard(
                            title: "暂无运行记录",
                            content: "生成开工建议、刷新判断或运行 LLM 评估后，这里会保留最近的监督循环记录。"
                        )
                    } else {
                        ForEach(recentRuns) { entry in
                            SupervisorRunEntryCard(entry: entry)
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("LLM 设置")
                        .font(.headline)
                    TextField("接口地址", text: $endpoint)
                        .textFieldStyle(.roundedBorder)
                    TextField("模型名称", text: $model)
                        .textFieldStyle(.roundedBorder)
                    SecureField("API Key", text: $apiKey)
                        .textFieldStyle(.roundedBorder)
                    Text(llmSavedText)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Text("最近更新时间：\(updatedText)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(16)
        }
        .background(Color.clear)
        .onAppear {
            if workspace.supervisorEnabled, workspace.supervisorLastReview == nil {
                workspace.scheduleSupervisorHeuristicRefresh(delay: 0.1)
            }
        }
        .onChange(of: endpoint) { llmSettingsSavedAt = Date() }
        .onChange(of: model) { llmSettingsSavedAt = Date() }
        .onChange(of: apiKey) { llmSettingsSavedAt = Date() }
        .onChange(of: workspace.supervisorEnabled) {
            if workspace.supervisorEnabled {
                workspace.scheduleSupervisorHeuristicRefresh(delay: 0.1)
            } else {
                workspace.publishSupervisorStatusEntry()
            }
        }
        .onChange(of: workspace.supervisorGoal) {
            guard workspace.supervisorEnabled else { return }
            workspace.scheduleSupervisorHeuristicRefresh(delay: 0.45)
        }
        .onChange(of: workspace.supervisorTaskCharter.doneDefinition) {
            guard workspace.supervisorEnabled else { return }
            workspace.scheduleSupervisorHeuristicRefresh(delay: 0.45)
        }
        .onChange(of: workspace.supervisorTaskCharter.constraints) {
            guard workspace.supervisorEnabled else { return }
            workspace.scheduleSupervisorHeuristicRefresh(delay: 0.45)
        }
        .onChange(of: workspace.supervisorTaskCharter.scopeNotes) {
            guard workspace.supervisorEnabled else { return }
            workspace.scheduleSupervisorHeuristicRefresh(delay: 0.45)
        }
        .onChange(of: workspace.supervisorInteractionNotes) {
            let trimmed = workspace.supervisorInteractionNotes.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { return }
            workspace.supervisorStartupPlan = WorkspaceSupervisorHeuristics.prepareStartupPlan(
                snapshot: workspace.supervisorSnapshot,
                interactions: trimmed
            )
            workspace.supervisorExecutionBrief = WorkspaceSupervisorHeuristics.prepareExecutionBrief(
                snapshot: workspace.supervisorSnapshot,
                review: workspace.supervisorLastReview,
                startupPlan: workspace.supervisorStartupPlan
            )
            if workspace.supervisorEnabled {
                workspace.scheduleSupervisorHeuristicRefresh(delay: 0.45)
            }
        }
    }
}

private struct SupervisorMetricPill: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
            Text(value)
                .font(.system(size: 13, weight: .semibold))
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, minHeight: 60, alignment: .leading)
        .padding(.horizontal, 11)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 13, style: .continuous)
                .fill(Color.primary.opacity(0.055))
        )
        .overlay {
            RoundedRectangle(cornerRadius: 13, style: .continuous)
                .strokeBorder(Color.primary.opacity(0.06), lineWidth: 1)
        }
    }
}

private struct SupervisorSurface<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            content
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.primary.opacity(0.042))
        )
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(Color.primary.opacity(0.05), lineWidth: 1)
        }
    }
}

private struct SupervisorSection<Content: View>: View {
    let title: String
    let subtitle: String
    @ViewBuilder let content: Content

    var body: some View {
        SupervisorSurface {
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                content
            }
        }
    }
}

private struct SupervisorLabeledEditor: View {
    let title: String
    @Binding var text: String
    let minHeight: CGFloat

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.secondary)
            TextEditor(text: $text)
                .font(.system(size: 12, design: .monospaced))
                .frame(minHeight: minHeight)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 11, style: .continuous)
                        .fill(Color.primary.opacity(0.05))
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 11, style: .continuous)
                        .strokeBorder(Color.primary.opacity(0.05), lineWidth: 1)
                }
        }
    }
}

private struct SupervisorPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 12, weight: .semibold))
            .padding(.horizontal, 14)
            .padding(.vertical, 9)
            .foregroundStyle(.white)
            .background(
                RoundedRectangle(cornerRadius: 11, style: .continuous)
                    .fill(Color.accentColor.opacity(configuration.isPressed ? 0.8 : 1))
            )
            .scaleEffect(configuration.isPressed ? 0.99 : 1)
    }
}

private struct SupervisorRunEntryCard: View {
    let entry: WorkspaceSupervisorRunEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                Text(entry.title)
                    .font(.headline)
                Spacer()
                Text(Date(timeIntervalSince1970: entry.timestamp).formatted(date: .omitted, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Text(entry.summary)
                .font(.system(size: 12))
                .foregroundStyle(.primary)

            HStack(alignment: .top, spacing: 8) {
                Text("结果")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .frame(width: 56, alignment: .leading)
                Text(entry.outcome)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            HStack(alignment: .top, spacing: 8) {
                Text("下一步")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .frame(width: 56, alignment: .leading)
                Text(entry.nextAction)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.primary.opacity(0.045))
        )
    }
}

private struct SupervisorSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 12, weight: .semibold))
            .padding(.horizontal, 14)
            .padding(.vertical, 9)
            .foregroundStyle(Color.primary)
            .background(
                RoundedRectangle(cornerRadius: 11, style: .continuous)
                    .fill(Color.primary.opacity(configuration.isPressed ? 0.12 : 0.07))
            )
            .overlay {
                RoundedRectangle(cornerRadius: 11, style: .continuous)
                    .strokeBorder(Color.primary.opacity(0.08), lineWidth: 1)
            }
            .scaleEffect(configuration.isPressed ? 0.99 : 1)
    }
}

private struct SupervisorReviewCard: View {
    let title: String
    let content: String
    var monospaced: Bool = false

    var bodyView: some View {
        Text(content.isEmpty ? "暂无内容" : content)
            .font(monospaced ? .system(size: 12, design: .monospaced) : .system(size: 12))
            .foregroundStyle(.primary)
            .textSelection(.enabled)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
            bodyView
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.primary.opacity(0.05))
        )
    }
}

private struct WorkspaceSupervisorLLMResponse: Decodable {
    struct Choice: Decodable {
        struct Message: Decodable {
            let content: String?
        }
        let message: Message
    }
    let choices: [Choice]
}

enum WorkspaceSupervisorLLMClient {
    static func review(
        snapshot: WorkspaceSupervisorSnapshot,
        endpoint: String,
        apiKey: String,
        model: String
    ) async throws -> WorkspaceSupervisorReview {
        let heuristic = WorkspaceSupervisorHeuristics.evaluate(snapshot: snapshot)
        guard let url = URL(string: endpoint) else {
            throw NSError(domain: "cmux.supervisor", code: 10, userInfo: [NSLocalizedDescriptionKey: "Invalid LLM endpoint URL"])
        }

        let prompt = """
        Return strict JSON with keys:
        health, summary, reason, nextAction, suggestedPrompt

        Health must be one of: idle, running, attention, blocked, completed.
        Ground your answer in the workspace charter, observed directories, remote state, and recent supervisor run history.
        Prefer concrete next actions over generic advice.

        Workspace snapshot:
        \(serializedSnapshot(snapshot))

        Heuristic baseline:
        \(serializedReview(heuristic))
        """

        let body: [String: Any] = [
            "model": model,
            "temperature": 0.2,
            "response_format": ["type": "json_object"],
            "messages": [
                [
                    "role": "system",
                    "content": "You are a cautious engineering supervisor for a terminal workspace. Focus on current state, blockers, and the safest next prompt."
                ],
                [
                    "role": "user",
                    "content": prompt
                ]
            ]
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            let errorText = String(data: data, encoding: .utf8) ?? "Unknown API error"
            throw NSError(domain: "cmux.supervisor", code: 11, userInfo: [NSLocalizedDescriptionKey: errorText])
        }

        let decoded = try JSONDecoder().decode(WorkspaceSupervisorLLMResponse.self, from: data)
        let content = decoded.choices.first?.message.content ?? ""
        guard let payloadData = content.data(using: .utf8),
              let payload = try JSONSerialization.jsonObject(with: payloadData) as? [String: Any] else {
            throw NSError(domain: "cmux.supervisor", code: 12, userInfo: [NSLocalizedDescriptionKey: "LLM returned invalid JSON"])
        }

        let health = WorkspaceSupervisorHealth(rawValue: String(describing: payload["health"] ?? "")) ?? heuristic.health
        return WorkspaceSupervisorReview(
            health: health,
            summary: stringValue(payload["summary"]) ?? heuristic.summary,
            reason: stringValue(payload["reason"]) ?? heuristic.reason,
            nextAction: stringValue(payload["nextAction"]) ?? heuristic.nextAction,
            suggestedPrompt: stringValue(payload["suggestedPrompt"]) ?? heuristic.suggestedPrompt,
            source: "llm",
            model: model,
            generatedAt: Date().timeIntervalSince1970
        )
    }

    static func startupPlan(
        snapshot: WorkspaceSupervisorSnapshot,
        interactions: String,
        endpoint: String,
        apiKey: String,
        model: String
    ) async throws -> WorkspaceSupervisorStartupPlan {
        let heuristic = WorkspaceSupervisorHeuristics.prepareStartupPlan(snapshot: snapshot, interactions: interactions)
        guard let url = URL(string: endpoint) else {
            throw NSError(domain: "cmux.supervisor", code: 10, userInfo: [NSLocalizedDescriptionKey: "无效的 LLM 接口地址"])
        }

        let prompt = """
        你是一个终端工作区的项目监督器。请根据当前工作区状态和最近 2-3 轮用户交流，输出严格 JSON，包含以下字段：
        goal, progressSummary, recommendedAction, starterPrompt, assumptions

        额外要求：
        1. progressSummary 必须明确指出当前项目阶段，例如“准备开工 / 执行中 / 阻塞中 / 已完成”。
        2. recommendedAction 必须是一个可以立刻执行的动作，不要写成泛泛建议。
        3. starterPrompt 必须像真正要发给执行模型的提示词，包含目标、约束、当前目录或远程信息。
        4. assumptions 里只保留最关键的 1-3 条前提，不要写空话。

        工作区状态：
        \(serializedSnapshot(snapshot))

        最近用户交流：
        \(interactions)

        本地启发式基线：
        \(serializedStartupPlan(heuristic))
        """

        let body: [String: Any] = [
            "model": model,
            "temperature": 0.2,
            "response_format": ["type": "json_object"],
            "messages": [
                [
                    "role": "system",
                    "content": "你是一个谨慎、务实的工程监督器。你的任务是根据有限交流快速形成可以开工的执行建议。"
                ],
                [
                    "role": "user",
                    "content": prompt
                ]
            ]
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            let errorText = String(data: data, encoding: .utf8) ?? "Unknown API error"
            throw NSError(domain: "cmux.supervisor", code: 11, userInfo: [NSLocalizedDescriptionKey: errorText])
        }

        let decoded = try JSONDecoder().decode(WorkspaceSupervisorLLMResponse.self, from: data)
        let content = decoded.choices.first?.message.content ?? ""
        guard let payloadData = content.data(using: .utf8),
              let payload = try JSONSerialization.jsonObject(with: payloadData) as? [String: Any] else {
            throw NSError(domain: "cmux.supervisor", code: 12, userInfo: [NSLocalizedDescriptionKey: "LLM 返回了无效 JSON"])
        }

        return WorkspaceSupervisorStartupPlan(
            goal: stringValue(payload["goal"]) ?? heuristic.goal,
            progressSummary: stringValue(payload["progressSummary"]) ?? heuristic.progressSummary,
            recommendedAction: stringValue(payload["recommendedAction"]) ?? heuristic.recommendedAction,
            starterPrompt: stringValue(payload["starterPrompt"]) ?? heuristic.starterPrompt,
            assumptions: stringValue(payload["assumptions"]) ?? heuristic.assumptions,
            source: "llm",
            model: model,
            generatedAt: Date().timeIntervalSince1970
        )
    }

    static func executionBrief(
        snapshot: WorkspaceSupervisorSnapshot,
        review: WorkspaceSupervisorReview?,
        startupPlan: WorkspaceSupervisorStartupPlan?,
        endpoint: String,
        apiKey: String,
        model: String
    ) async throws -> WorkspaceSupervisorExecutionBrief {
        let heuristic = WorkspaceSupervisorHeuristics.prepareExecutionBrief(
            snapshot: snapshot,
            review: review,
            startupPlan: startupPlan
        )
        guard let url = URL(string: endpoint) else {
            throw NSError(domain: "cmux.supervisor", code: 10, userInfo: [NSLocalizedDescriptionKey: "Invalid LLM endpoint URL"])
        }

        let prompt = """
        Return strict JSON with keys:
        title, objective, executionSteps, successSignals, risks, operatorPrompt

        Requirements:
        - executionSteps, successSignals, and risks must be JSON arrays of strings.
        - Keep the plan bounded to one concrete execution slice.
        - operatorPrompt must be directly usable as an executor model prompt.

        Workspace snapshot:
        \(serializedSnapshot(snapshot))

        Latest review:
        \(review.map(serializedReview) ?? "{}")

        Startup plan:
        \(startupPlan.map(serializedStartupPlan) ?? "{}")

        Heuristic baseline:
        \(serializedExecutionBrief(heuristic))
        """

        let body: [String: Any] = [
            "model": model,
            "temperature": 0.2,
            "response_format": ["type": "json_object"],
            "messages": [
                [
                    "role": "system",
                    "content": "You are an engineering supervisor producing a bounded execution brief for one workspace. Be concrete, scope-safe, and operational."
                ],
                [
                    "role": "user",
                    "content": prompt
                ]
            ]
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            let errorText = String(data: data, encoding: .utf8) ?? "Unknown API error"
            throw NSError(domain: "cmux.supervisor", code: 11, userInfo: [NSLocalizedDescriptionKey: errorText])
        }

        let decoded = try JSONDecoder().decode(WorkspaceSupervisorLLMResponse.self, from: data)
        let content = decoded.choices.first?.message.content ?? ""
        guard let payloadData = content.data(using: .utf8),
              let payload = try JSONSerialization.jsonObject(with: payloadData) as? [String: Any] else {
            throw NSError(domain: "cmux.supervisor", code: 12, userInfo: [NSLocalizedDescriptionKey: "LLM returned invalid JSON"])
        }

        return WorkspaceSupervisorExecutionBrief(
            title: stringValue(payload["title"]) ?? heuristic.title,
            objective: stringValue(payload["objective"]) ?? heuristic.objective,
            executionSteps: stringArray(payload["executionSteps"]) ?? heuristic.executionSteps,
            successSignals: stringArray(payload["successSignals"]) ?? heuristic.successSignals,
            risks: stringArray(payload["risks"]) ?? heuristic.risks,
            operatorPrompt: stringValue(payload["operatorPrompt"]) ?? heuristic.operatorPrompt,
            source: "llm",
            model: model,
            generatedAt: Date().timeIntervalSince1970
        )
    }

    private static func serializedSnapshot(_ snapshot: WorkspaceSupervisorSnapshot) -> String {
        let payload: [String: Any] = [
            "title": snapshot.title,
            "customTitle": snapshot.customTitle as Any,
            "currentDirectory": snapshot.currentDirectory,
            "observedDirectories": snapshot.observedDirectories,
            "goal": snapshot.goal,
            "doneDefinition": snapshot.doneDefinition,
            "constraints": snapshot.constraints,
            "scopeNotes": snapshot.scopeNotes,
            "progressValue": snapshot.progressValue as Any,
            "progressLabel": snapshot.progressLabel as Any,
            "gitBranch": snapshot.gitBranch as Any,
            "gitDirty": snapshot.gitDirty,
            "remoteTarget": snapshot.remoteTarget as Any,
            "remoteState": snapshot.remoteState,
            "remoteDetail": snapshot.remoteDetail as Any,
            "statusEntries": snapshot.statusEntries.map { ["key": $0.key, "value": $0.value] },
            "recentLogs": snapshot.recentLogs,
            "recentRunHeadlines": snapshot.recentRunHeadlines,
            "focusedPanelDirectory": snapshot.focusedPanelDirectory as Any
        ]
        let data = try? JSONSerialization.data(withJSONObject: payload, options: [.prettyPrinted, .sortedKeys])
        return data.flatMap { String(data: $0, encoding: .utf8) } ?? "{}"
    }

    private static func serializedReview(_ review: WorkspaceSupervisorReview) -> String {
        let payload: [String: Any] = [
            "health": review.health.rawValue,
            "summary": review.summary,
            "reason": review.reason,
            "nextAction": review.nextAction,
            "suggestedPrompt": review.suggestedPrompt
        ]
        let data = try? JSONSerialization.data(withJSONObject: payload, options: [.prettyPrinted, .sortedKeys])
        return data.flatMap { String(data: $0, encoding: .utf8) } ?? "{}"
    }

    private static func serializedStartupPlan(_ plan: WorkspaceSupervisorStartupPlan) -> String {
        let payload: [String: Any] = [
            "goal": plan.goal,
            "progressSummary": plan.progressSummary,
            "recommendedAction": plan.recommendedAction,
            "starterPrompt": plan.starterPrompt,
            "assumptions": plan.assumptions
        ]
        let data = try? JSONSerialization.data(withJSONObject: payload, options: [.prettyPrinted, .sortedKeys])
        return data.flatMap { String(data: $0, encoding: .utf8) } ?? "{}"
    }

    private static func serializedExecutionBrief(_ brief: WorkspaceSupervisorExecutionBrief) -> String {
        let payload: [String: Any] = [
            "title": brief.title,
            "objective": brief.objective,
            "executionSteps": brief.executionSteps,
            "successSignals": brief.successSignals,
            "risks": brief.risks,
            "operatorPrompt": brief.operatorPrompt
        ]
        let data = try? JSONSerialization.data(withJSONObject: payload, options: [.prettyPrinted, .sortedKeys])
        return data.flatMap { String(data: $0, encoding: .utf8) } ?? "{}"
    }

    private static func stringValue(_ value: Any?) -> String? {
        guard let value else { return nil }
        let text = String(describing: value).trimmingCharacters(in: .whitespacesAndNewlines)
        return text.isEmpty ? nil : text
    }

    private static func stringArray(_ value: Any?) -> [String]? {
        guard let array = value as? [Any] else { return nil }
        let strings = array
            .map { String(describing: $0).trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        return strings.isEmpty ? nil : strings
    }
}

extension Workspace {
    private func supervisorTerminalPanel(for panelID: UUID?) -> TerminalPanel? {
        guard let panelID,
              let terminalPanel = panels[panelID] as? TerminalPanel else {
            return nil
        }
        return terminalPanel
    }

    private func supervisorResolvedDispatchTarget(preferredPanelID: UUID?) -> WorkspaceSupervisorPanelHandoff? {
        refreshSupervisorPanelHandoffs()

        let terminalPanelIDs = Set(
            sidebarOrderedPanelIds().filter { supervisorTerminalPanel(for: $0) != nil }
        )

        guard !terminalPanelIDs.isEmpty else { return nil }

        if let preferredPanelID,
           terminalPanelIDs.contains(preferredPanelID),
           let exact = supervisorPanelHandoffs.first(where: { $0.panelID == preferredPanelID }) {
            return exact
        }

        if let activePanelID = supervisorActiveLoopTarget?.panelID,
           terminalPanelIDs.contains(activePanelID),
           let active = supervisorPanelHandoffs.first(where: { $0.panelID == activePanelID }) {
            return active
        }

        if let focusedPanelId,
           terminalPanelIDs.contains(focusedPanelId),
           let focused = supervisorPanelHandoffs.first(where: { $0.panelID == focusedPanelId }) {
            return focused
        }

        return supervisorPanelHandoffs.first(where: { terminalPanelIDs.contains($0.panelID) })
    }

    private func supervisorDispatchPrompt(for handoff: WorkspaceSupervisorPanelHandoff?) -> String? {
        let prompt = handoff?.operatorPrompt.trimmingCharacters(in: .whitespacesAndNewlines)
            ?? supervisorExecutionBrief?.operatorPrompt.trimmingCharacters(in: .whitespacesAndNewlines)

        guard let prompt, !prompt.isEmpty else { return nil }
        return prompt.hasSuffix("\n") ? prompt : prompt + "\n"
    }

    func canDispatchSupervisorPrompt(preferredPanelID: UUID?) -> Bool {
        guard let handoff = supervisorResolvedDispatchTarget(preferredPanelID: preferredPanelID),
              supervisorTerminalPanel(for: handoff.panelID) != nil else {
            return false
        }
        return supervisorDispatchPrompt(for: handoff) != nil
    }

    @discardableResult
    func dispatchSupervisorPromptToCurrentPanel() -> String {
        dispatchSupervisorPrompt(preferredPanelID: focusedPanelId, source: "dispatch-current-panel")
    }

    @discardableResult
    func dispatchSupervisorPromptToActiveLoopPanel() -> String {
        dispatchSupervisorPrompt(
            preferredPanelID: supervisorActiveLoopTarget?.panelID,
            source: "dispatch-active-loop-panel"
        )
    }

    @discardableResult
    func dispatchSupervisorPrompt(preferredPanelID: UUID?, source: String) -> String {
        guard let handoff = supervisorResolvedDispatchTarget(preferredPanelID: preferredPanelID) else {
            let message = "No terminal window is available for supervisor dispatch."
            appendLogEntry(message, level: .warning, source: "supervisor")
            return message
        }

        guard let terminalPanel = supervisorTerminalPanel(for: handoff.panelID) else {
            let message = "The selected supervisor target is not a terminal window."
            appendLogEntry(message, level: .warning, source: "supervisor")
            return message
        }

        guard let prompt = supervisorDispatchPrompt(for: handoff) else {
            let message = "No supervisor prompt is ready to send yet."
            appendLogEntry(message, level: .warning, source: "supervisor")
            return message
        }

        supervisorActiveLoopTarget = WorkspaceSupervisorLoopTarget(
            panelID: handoff.panelID,
            panelTitle: handoff.panelTitle,
            workingDirectory: handoff.workingDirectory,
            selectedAt: Date().timeIntervalSince1970
        )

        focusPanel(handoff.panelID)
        terminalPanel.sendText(prompt)

        let message = "Supervisor prompt sent to \(handoff.panelTitle)."
        appendSupervisorRun(
            title: "派发执行提示词",
            summary: "已向 \(handoff.panelTitle) 派发执行提示词。",
            outcome: "目标目录：\(handoff.workingDirectory)",
            nextAction: handoff.nextAction,
            source: source
        )
        appendLogEntry(message, level: .info, source: "supervisor")
        publishSupervisorStatusEntry()
        return message
    }

    private func supervisorPanelEvidenceLines(panelID: UUID) -> [String] {
        var lines: [String] = []
        let directory = normalizedPanelDirectory(for: panelID)
        lines.append("Directory: \(directory)")
        if let gitBranch, !gitBranch.branch.isEmpty {
            lines.append("Git: \(gitBranch.branch)\(gitBranch.isDirty ? " (dirty)" : " (clean)")")
        }
        if let remoteTarget = remoteDisplayTarget, !remoteTarget.isEmpty {
            let detail = remoteConnectionDetail?.trimmingCharacters(in: .whitespacesAndNewlines)
            lines.append("Remote: \(remoteTarget) / \(remoteConnectionState)\(detail?.isEmpty == false ? " / \(detail!)" : "")")
        }
        let recentSignals = Array(logEntries.suffix(3).map(\.message))
        if !recentSignals.isEmpty {
            lines.append("Recent signals: \(recentSignals.joined(separator: " | "))")
        }
        let recentRuns = supervisorRunJournal.prefix(2).map(\.summary).filter { !$0.isEmpty }
        if !recentRuns.isEmpty {
            lines.append("Recent supervisor notes: \(recentRuns.joined(separator: " | "))")
        }
        return lines
    }

    private func supervisorPanelRole(
        panelType: PanelType,
        isActiveTarget: Bool,
        isFocused: Bool,
        status: String
    ) -> String {
        if status == "completed" {
            return "Completed"
        }
        if status == "blocked" {
            return "Blocked"
        }
        if isActiveTarget {
            switch panelType {
            case .terminal:
                return "Lead Executor"
            case .browser:
                return "Lead Research"
            case .markdown:
                return "Lead Spec"
            }
        }
        if isFocused {
            switch panelType {
            case .terminal:
                return "Ready Executor"
            case .browser:
                return "Ready Research"
            case .markdown:
                return "Ready Spec"
            }
        }
        switch panelType {
        case .terminal:
            return "Support Executor"
        case .browser:
            return "Support Research"
        case .markdown:
            return "Support Notes"
        }
    }

    private func supervisorPanelFallbackAction(
        panelType: PanelType,
        role: String,
        fallbackAction: String
    ) -> String {
        if role.hasPrefix("Lead") || role.hasPrefix("Ready") {
            switch panelType {
            case .terminal:
                return fallbackAction
            case .browser:
                return "Inspect the references or remote state needed for the current step, then extract only the facts needed to unblock execution."
            case .markdown:
                return "Capture the current goal, acceptance criteria, and latest decision so execution can continue without ambiguity."
            }
        }

        switch panelType {
        case .terminal:
            return "Prepare a verification command, compare recent terminal output with the workspace goal, and surface the next safe terminal action."
        case .browser:
            return "Gather a minimal supporting reference or remote confirmation for the active step; avoid drifting into broad exploration."
        case .markdown:
            return "Update notes, checklist, or acceptance criteria for the active step so the execution window can move faster."
        }
    }

    private func supervisorPanelPrompt(
        panelTitle: String,
        panelType: PanelType,
        role: String,
        directory: String,
        objective: String,
        status: String,
        nextAction: String,
        evidenceLines: [String]
    ) -> String {
        let executionRules: String = {
            switch panelType {
            case .terminal:
                return """
                Use this panel to execute or verify concrete commands. Keep scope tight. When you act, report the exact command, the key output, and whether the result changes the task state.
                """
            case .browser:
                return """
                Use this panel to inspect references, docs, web UI state, or remote evidence. Extract facts, do not brainstorm. Summarize only the details that change the next action.
                """
            case .markdown:
                return """
                Use this panel to maintain structured notes, specs, or checklists. Convert ambiguity into a concrete acceptance checklist or decision record for the active task.
                """
            }
        }()

        return """
        You own the panel "\(panelTitle)".
        Role: \(role)
        Panel type: \(panelType.rawValue)
        Working directory: \(directory)
        Workspace objective: \(objective)
        Current status: \(WorkspaceSupervisorHeuristics.handoffDisplayStatus(status))

        Evidence:
        \(evidenceLines.joined(separator: "\n"))

        Next action:
        \(nextAction)

        Operating rules:
        \(executionRules)

        Before stopping, report:
        1. what changed in this panel,
        2. the most important evidence you found,
        3. whether this panel is now blocked, running, ready, or complete.
        """
    }

    private func buildSupervisorExecutionQueue(
        orderedPanelIds: [UUID],
        stateByPanelID: [UUID: WorkspaceSupervisorPanelRoundState],
        activeTargetPanelID: UUID?,
        fallbackAction: String
    ) -> [WorkspaceSupervisorQueueItem] {
        var items: [WorkspaceSupervisorQueueItem] = []
        var previousTerminalLikePanelID: UUID?

        for panelId in orderedPanelIds {
            guard let panel = panels[panelId] else { continue }
            let state = stateByPanelID[panelId]
            let title = panelTitle(panelId: panelId)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? panel.displayTitle
            let isFocused = panelId == focusedPanelId
            let isActiveTarget = panelId == activeTargetPanelID
            let status = state?.status ?? (isActiveTarget ? "running" : "pending")
            let role = supervisorPanelRole(
                panelType: panel.panelType,
                isActiveTarget: isActiveTarget,
                isFocused: isFocused,
                status: status
            )

            let readiness: String = {
                switch status {
                case "completed": return "completed"
                case "blocked": return "blocked"
                case "attention": return "needs_attention"
                case "running": return "active"
                case "supporting": return "supporting"
                default: return "ready"
                }
            }()

            let priority: Int = {
                if isActiveTarget { return 1 }
                switch panel.panelType {
                case .terminal:
                    return isFocused ? 2 : 3
                case .browser:
                    return 4
                case .markdown:
                    return 5
                }
            }()

            let nextMilestone = state?.nextAction.isEmpty == false
                ? state!.nextAction
                : supervisorPanelFallbackAction(
                    panelType: panel.panelType,
                    role: role,
                    fallbackAction: fallbackAction
                )

            let dependsOnPanelID: UUID? = {
                switch panel.panelType {
                case .terminal:
                    return nil
                case .browser, .markdown:
                    return previousTerminalLikePanelID
                }
            }()

            let rotationRule: String = {
                switch panel.panelType {
                case .terminal:
                    return "Rotate after a command result changes state, the panel becomes blocked, or no new evidence appears for two rounds."
                case .browser:
                    return "Rotate back once the needed fact, remote confirmation, or reference has been extracted for the executor."
                case .markdown:
                    return "Rotate after the checklist, spec, or decision note removes ambiguity for the active execution step."
                }
            }()

            items.append(
                WorkspaceSupervisorQueueItem(
                    id: panelId,
                    panelID: panelId,
                    panelTitle: title,
                    role: role,
                    priority: priority,
                    dependsOnPanelID: dependsOnPanelID,
                    readiness: readiness,
                    nextMilestone: nextMilestone,
                    rotationRule: rotationRule,
                    generatedAt: Date().timeIntervalSince1970
                )
            )

            if panel.panelType == .terminal {
                previousTerminalLikePanelID = panelId
            }
        }

        return items.sorted { lhs, rhs in
            if lhs.priority != rhs.priority { return lhs.priority < rhs.priority }
            return lhs.panelTitle.localizedCaseInsensitiveCompare(rhs.panelTitle) == .orderedAscending
        }
    }

    private func supervisorPanelStateMap() -> [UUID: WorkspaceSupervisorPanelRoundState] {
        Dictionary(uniqueKeysWithValues: supervisorPanelRoundStates.map { ($0.panelID, $0) })
    }

    private func normalizedPanelDirectory(for panelId: UUID) -> String {
        let candidate = panelDirectories[panelId]?.trimmingCharacters(in: .whitespacesAndNewlines)
        return candidate?.isEmpty == false ? candidate! : currentDirectory
    }

    private func upsertSupervisorPanelState(
        panelID: UUID,
        status: String,
        summary: String,
        outcome: String,
        nextAction: String,
        source: String,
        iteration: Int? = nil
    ) {
        guard let panel = panels[panelID] else { return }
        let title = panelTitle(panelId: panelID)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? panel.displayTitle
        let directory = normalizedPanelDirectory(for: panelID)
        let timestamp = Date().timeIntervalSince1970

        var state = supervisorPanelRoundStates.first(where: { $0.panelID == panelID }) ?? WorkspaceSupervisorPanelRoundState(
            id: panelID,
            panelID: panelID,
            panelTitle: title,
            panelType: panel.panelType.rawValue,
            workingDirectory: directory,
            status: "pending",
            iterationCount: 0,
            lastSummary: "",
            lastOutcome: "",
            nextAction: "",
            source: source,
            lastUpdatedAt: timestamp,
            history: []
        )

        state.panelTitle = title
        state.panelType = panel.panelType.rawValue
        state.workingDirectory = directory
        state.status = status
        state.lastSummary = summary
        state.lastOutcome = outcome
        state.nextAction = nextAction
        state.source = source
        state.lastUpdatedAt = timestamp
        if let iteration {
            state.iterationCount = max(state.iterationCount, iteration)
            state.history.insert(
                WorkspaceSupervisorPanelRoundEntry(
                    iteration: iteration,
                    panelID: panelID,
                    status: status,
                    summary: summary,
                    outcome: outcome,
                    nextAction: nextAction,
                    source: source,
                    timestamp: timestamp
                ),
                at: 0
            )
            if state.history.count > 8 {
                state.history.removeLast(state.history.count - 8)
            }
        }

        if let index = supervisorPanelRoundStates.firstIndex(where: { $0.panelID == panelID }) {
            supervisorPanelRoundStates[index] = state
        } else {
            supervisorPanelRoundStates.append(state)
        }
        supervisorPanelRoundStates.sort { lhs, rhs in
            lhs.lastUpdatedAt > rhs.lastUpdatedAt
        }
    }

    private func pruneSupervisorPanelStates(validPanelIDs: Set<UUID>) {
        supervisorPanelRoundStates.removeAll { validPanelIDs.contains($0.panelID) == false }
    }

    private func supervisorQueueMap() -> [UUID: WorkspaceSupervisorQueueItem] {
        Dictionary(uniqueKeysWithValues: supervisorExecutionQueue.map { ($0.panelID, $0) })
    }

    private func supervisorQueuePriority(for panelID: UUID, queueByPanelID: [UUID: WorkspaceSupervisorQueueItem]) -> Int {
        queueByPanelID[panelID]?.priority ?? Int.max
    }

    private func supervisorDependencyResolutionTarget(
        preferredDependencyPanelID: UUID? = nil,
        handoffs: [WorkspaceSupervisorPanelHandoff],
        stateByPanelID: [UUID: WorkspaceSupervisorPanelRoundState],
        queueByPanelID: [UUID: WorkspaceSupervisorQueueItem]
    ) -> WorkspaceSupervisorPanelHandoff? {
        let eligibleStatuses = Set(["ready", "pending", "running", "attention", "supporting"])

        func isEligible(_ handoff: WorkspaceSupervisorPanelHandoff) -> Bool {
            eligibleStatuses.contains(handoff.status)
        }

        let dependencyCandidates: [UUID] = {
            let prioritized = preferredDependencyPanelID.map { [$0] } ?? []
            let queued = supervisorExecutionQueue
                .map(\.panelID)
                .filter { prioritized.contains($0) == false }
            return prioritized + queued
        }()

        for dependencyPanelID in dependencyCandidates {
            guard let dependencyState = stateByPanelID[dependencyPanelID],
                  dependencyState.status == "blocked" || dependencyState.status == "attention" else {
                continue
            }

            let items = handoffs
                .filter { handoff in
                    guard isEligible(handoff) else { return false }
                    guard let queueItem = queueByPanelID[handoff.panelID] else { return false }
                    guard queueItem.dependsOnPanelID == dependencyPanelID else { return false }
                    return stateByPanelID[handoff.panelID]?.status != "completed"
                }
                .sorted { lhs, rhs in
                    let lhsState = stateByPanelID[lhs.panelID]
                    let rhsState = stateByPanelID[rhs.panelID]
                    let dependencyIteration = dependencyState.iterationCount
                    let lhsNeedsTurn = (lhsState?.iterationCount ?? 0) <= dependencyIteration
                    let rhsNeedsTurn = (rhsState?.iterationCount ?? 0) <= dependencyIteration
                    if lhsNeedsTurn != rhsNeedsTurn {
                        return lhsNeedsTurn && !rhsNeedsTurn
                    }
                    let lhsPriority = supervisorQueuePriority(for: lhs.panelID, queueByPanelID: queueByPanelID)
                    let rhsPriority = supervisorQueuePriority(for: rhs.panelID, queueByPanelID: queueByPanelID)
                    if lhsPriority != rhsPriority {
                        return lhsPriority < rhsPriority
                    }
                    let lhsUpdated = lhsState?.lastUpdatedAt ?? 0
                    let rhsUpdated = rhsState?.lastUpdatedAt ?? 0
                    if lhsUpdated != rhsUpdated {
                        return lhsUpdated < rhsUpdated
                    }
                    return lhs.panelTitle.localizedCaseInsensitiveCompare(rhs.panelTitle) == .orderedAscending
                }

            if let item = items.first {
                return item
            }
        }

        return nil
    }

    private func supervisorCanContinuePastBlockedReview(
        activePanelID: UUID?,
        handoffs: [WorkspaceSupervisorPanelHandoff],
        stateByPanelID: [UUID: WorkspaceSupervisorPanelRoundState],
        queueByPanelID: [UUID: WorkspaceSupervisorQueueItem]
    ) -> Bool {
        supervisorDependencyResolutionTarget(
            preferredDependencyPanelID: activePanelID,
            handoffs: handoffs,
            stateByPanelID: stateByPanelID,
            queueByPanelID: queueByPanelID
        ) != nil
    }

    func refreshSupervisorPanelHandoffs() {
        let orderedPanelIds = sidebarOrderedPanelIds()
        pruneSupervisorPanelStates(validPanelIDs: Set(orderedPanelIds))
        let fallbackObjective: String? = {
            if let objective = supervisorExecutionBrief?.objective, !objective.isEmpty {
                return objective
            }
            if let goal = supervisorStartupPlan?.goal, !goal.isEmpty {
                return goal
            }
            let charterGoal = supervisorTaskCharter.goal.trimmingCharacters(in: .whitespacesAndNewlines)
            return charterGoal.isEmpty ? nil : charterGoal
        }()
        let fallbackAction = supervisorExecutionBrief?.executionSteps.first
            ?? supervisorLastReview?.nextAction
            ?? supervisorStartupPlan?.recommendedAction
            ?? "Inspect the current panel state and make the smallest safe move."
        let globalStatus = WorkspaceSupervisorHeuristics.handoffStatus(for: supervisorLastReview)
        let stateByPanelID = supervisorPanelStateMap()
        let activeTargetPanelID = supervisorActiveLoopTarget?.panelID
        supervisorExecutionQueue = buildSupervisorExecutionQueue(
            orderedPanelIds: orderedPanelIds,
            stateByPanelID: stateByPanelID,
            activeTargetPanelID: activeTargetPanelID,
            fallbackAction: fallbackAction
        )

        var handoffs: [WorkspaceSupervisorPanelHandoff] = []
        for panelId in orderedPanelIds {
            guard let panel = panels[panelId] else { continue }
            let panelTitle = panelTitle(panelId: panelId)?.trimmingCharacters(in: .whitespacesAndNewlines)
                ?? panel.displayTitle
            let directory = normalizedPanelDirectory(for: panelId)
            let isFocused = panelId == focusedPanelId
            let panelState = stateByPanelID[panelId]
            let isActiveTarget = panelId == activeTargetPanelID
            let status = panelState?.status
                ?? (isActiveTarget ? "running" : (isFocused ? globalStatus : "pending"))
            let role = supervisorPanelRole(
                panelType: panel.panelType,
                isActiveTarget: isActiveTarget,
                isFocused: isFocused,
                status: status
            )
            let objective = panelState?.lastSummary.isEmpty == false
                ? panelState!.lastSummary
                : (isFocused
                ? (fallbackObjective?.isEmpty == false ? fallbackObjective! : "Advance the focused panel safely.")
                : "Support the workspace goal from this panel without expanding scope.")
            let nextAction = panelState?.nextAction.isEmpty == false
                ? panelState!.nextAction
                : supervisorPanelFallbackAction(
                    panelType: panel.panelType,
                    role: role,
                    fallbackAction: fallbackAction
                )
            let evidenceLines = supervisorPanelEvidenceLines(panelID: panelId)
            let prompt = supervisorPanelPrompt(
                panelTitle: panelTitle,
                panelType: panel.panelType,
                role: role,
                directory: directory,
                objective: objective,
                status: status,
                nextAction: nextAction,
                evidenceLines: evidenceLines
            )

            handoffs.append(WorkspaceSupervisorPanelHandoff(
                id: panelId,
                panelID: panelId,
                panelTitle: "[\(role)] \(panelTitle)",
                panelType: panel.panelType.rawValue,
                workingDirectory: directory,
                objective: objective,
                nextAction: nextAction,
                status: status,
                operatorPrompt: prompt,
                source: supervisorExecutionBrief?.source ?? supervisorStartupPlan?.source ?? "heuristic",
                generatedAt: Date().timeIntervalSince1970
            ))
        }
        supervisorPanelHandoffs = handoffs
        if let activePanelID = supervisorActiveLoopTarget?.panelID,
           handoffs.contains(where: { $0.panelID == activePanelID }) == false {
            supervisorActiveLoopTarget = nil
        }
    }

    func selectSupervisorLoopTarget(preferredPanelID: UUID? = nil) -> WorkspaceSupervisorPanelHandoff? {
        refreshSupervisorPanelHandoffs()
        let preferredID = preferredPanelID ?? focusedPanelId
        let eligibleStatuses = Set(["ready", "pending", "running", "attention", "supporting"])
        let panelStates = supervisorPanelStateMap()
        let queueByPanelID = supervisorQueueMap()

        func isEligible(_ handoff: WorkspaceSupervisorPanelHandoff) -> Bool {
            eligibleStatuses.contains(handoff.status)
        }

        let dependencyResolutionTarget = supervisorDependencyResolutionTarget(
            preferredDependencyPanelID: preferredID,
            handoffs: supervisorPanelHandoffs,
            stateByPanelID: panelStates,
            queueByPanelID: queueByPanelID
        )

        let selected = dependencyResolutionTarget
            ?? supervisorPanelHandoffs.first(where: { $0.panelID == preferredID && isEligible($0) })
            ?? supervisorPanelHandoffs
                .filter(isEligible)
                .sorted { lhs, rhs in
                    let lhsQueue = queueByPanelID[lhs.panelID]
                    let rhsQueue = queueByPanelID[rhs.panelID]
                    let lhsPriority = lhsQueue?.priority ?? Int.max
                    let rhsPriority = rhsQueue?.priority ?? Int.max
                    if lhsPriority != rhsPriority {
                        return lhsPriority < rhsPriority
                    }
                    let lhsState = panelStates[lhs.panelID]
                    let rhsState = panelStates[rhs.panelID]
                    let lhsIterations = lhsState?.iterationCount ?? 0
                    let rhsIterations = rhsState?.iterationCount ?? 0
                    if lhsIterations != rhsIterations {
                        return lhsIterations < rhsIterations
                    }
                    let lhsUpdated = lhsState?.lastUpdatedAt ?? 0
                    let rhsUpdated = rhsState?.lastUpdatedAt ?? 0
                    if lhsUpdated != rhsUpdated {
                        return lhsUpdated < rhsUpdated
                    }
                    return lhs.panelTitle.localizedCaseInsensitiveCompare(rhs.panelTitle) == .orderedAscending
                }
                .first
            ?? supervisorPanelHandoffs.first
        if let selected {
            supervisorActiveLoopTarget = WorkspaceSupervisorLoopTarget(
                panelID: selected.panelID,
                panelTitle: selected.panelTitle,
                workingDirectory: selected.workingDirectory,
                selectedAt: Date().timeIntervalSince1970
            )
        } else {
            supervisorActiveLoopTarget = nil
        }
        return selected
    }

    private func markSupervisorSupportingPanels(activePanelID: UUID?, defaultAction: String) {
        let activeID = activePanelID
        for panelId in sidebarOrderedPanelIds() where panelId != activeID && panels[panelId] != nil {
            let existing = supervisorPanelRoundStates.first(where: { $0.panelID == panelId })
            let preservedStatus = existing.map { state in
                switch state.status {
                case "completed", "blocked", "attention":
                    return state.status
                default:
                    return "supporting"
                }
            } ?? "supporting"
            let summary = existing?.lastSummary.isEmpty == false
                ? existing!.lastSummary
                : "This panel is currently supporting the active workspace step."
            let outcome = existing?.lastOutcome.isEmpty == false
                ? existing!.lastOutcome
                : "Waiting for the active window to finish its current round."
            let nextAction = existing?.nextAction.isEmpty == false
                ? existing!.nextAction
                : defaultAction
            upsertSupervisorPanelState(
                panelID: panelId,
                status: preservedStatus,
                summary: summary,
                outcome: outcome,
                nextAction: nextAction,
                source: "supporting"
            )
        }
    }

    var supervisorSnapshot: WorkspaceSupervisorSnapshot {
        let focusedDirectory = focusedPanelId.flatMap { panelDirectories[$0] }
        var observedDirectories: [String] = []
        for candidate in [currentDirectory, focusedDirectory] + Array(panelDirectories.values) {
            guard let trimmed = candidate?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !trimmed.isEmpty,
                  !observedDirectories.contains(trimmed) else {
                continue
            }
            observedDirectories.append(trimmed)
        }
        let orderedStatuses = statusEntries.values
            .sorted { lhs, rhs in lhs.priority == rhs.priority ? lhs.key < rhs.key : lhs.priority > rhs.priority }
            .map { ($0.key, $0.value) }
        let recentLogs = logEntries.suffix(8).map(\.message)
        let recentRunHeadlines = supervisorRunJournal
            .prefix(6)
            .map { entry in
                let summary = entry.summary.trimmingCharacters(in: .whitespacesAndNewlines)
                return summary.isEmpty ? entry.title : "\(entry.title)：\(summary)"
            }
        return WorkspaceSupervisorSnapshot(
            title: title,
            customTitle: customTitle,
            currentDirectory: currentDirectory,
            observedDirectories: observedDirectories,
            goal: supervisorTaskCharter.goal.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? supervisorGoal : supervisorTaskCharter.goal,
            doneDefinition: supervisorTaskCharter.doneDefinition,
            constraints: supervisorTaskCharter.constraints,
            scopeNotes: supervisorTaskCharter.scopeNotes,
            progressValue: progress?.value,
            progressLabel: progress?.label,
            gitBranch: gitBranch?.branch,
            gitDirty: gitBranch?.isDirty ?? false,
            remoteTarget: remoteDisplayTarget,
            remoteState: "\(remoteConnectionState)",
            remoteDetail: remoteConnectionDetail,
            statusEntries: orderedStatuses,
            recentLogs: recentLogs,
            recentRunHeadlines: recentRunHeadlines,
            focusedPanelDirectory: focusedDirectory
        )
    }

    func refreshSupervisorHeuristicReview() {
        supervisorLastReview = WorkspaceSupervisorHeuristics.evaluate(snapshot: supervisorSnapshot)
        supervisorHealth = supervisorLastReview?.health ?? .idle
        supervisorUpdatedAt = Date()
        supervisorExecutionBrief = WorkspaceSupervisorHeuristics.prepareExecutionBrief(
            snapshot: supervisorSnapshot,
            review: supervisorLastReview,
            startupPlan: supervisorStartupPlan
        )
        refreshSupervisorPanelHandoffs()
        recordSupervisorCheckpoint(source: "heuristic")
        publishSupervisorStatusEntry()
    }

    func requestSupervisorLLMReview(endpoint: String, apiKey: String, model: String) async {
        let trimmedKey = apiKey.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedKey.isEmpty else {
            refreshSupervisorHeuristicReview()
            return
        }

        let snapshot = supervisorSnapshot
        do {
            let review = try await WorkspaceSupervisorLLMClient.review(
                snapshot: snapshot,
                endpoint: endpoint,
                apiKey: trimmedKey,
                model: model
            )
            supervisorLastReview = review
            supervisorHealth = review.health
            supervisorUpdatedAt = Date()
            supervisorExecutionBrief = WorkspaceSupervisorHeuristics.prepareExecutionBrief(
                snapshot: snapshot,
                review: review,
                startupPlan: supervisorStartupPlan
            )
            refreshSupervisorPanelHandoffs()
            recordSupervisorCheckpoint(source: "llm-review")
            appendLogEntry("Supervisor LLM review updated", level: .info, source: "supervisor")
        } catch {
            refreshSupervisorHeuristicReview()
            appendLogEntry("Supervisor review failed: \(error.localizedDescription)", level: .warning, source: "supervisor")
        }
        publishSupervisorStatusEntry()
    }

    func requestSupervisorStartupPlan(endpoint: String, apiKey: String, model: String) async {
        let snapshot = supervisorSnapshot
        let interactions = supervisorInteractionNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedKey = apiKey.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedKey.isEmpty else {
            supervisorStartupPlan = WorkspaceSupervisorHeuristics.prepareStartupPlan(
                snapshot: snapshot,
                interactions: interactions
            )
            supervisorExecutionBrief = WorkspaceSupervisorHeuristics.prepareExecutionBrief(
                snapshot: snapshot,
                review: supervisorLastReview,
                startupPlan: supervisorStartupPlan
            )
            refreshSupervisorPanelHandoffs()
            return
        }

        do {
            supervisorStartupPlan = try await WorkspaceSupervisorLLMClient.startupPlan(
                snapshot: snapshot,
                interactions: interactions,
                endpoint: endpoint,
                apiKey: trimmedKey,
                model: model
            )
            appendSupervisorRun(
                title: "生成开工建议",
                summary: supervisorStartupPlan?.progressSummary ?? "已基于最近交流生成开工建议。",
                outcome: supervisorStartupPlan?.source == "llm" ? "LLM 已产出开工建议。" : "已生成开工建议。",
                nextAction: supervisorStartupPlan?.recommendedAction ?? "确认目标与第一步动作。",
                source: supervisorStartupPlan?.source ?? "startup-plan"
            )
            supervisorExecutionBrief = WorkspaceSupervisorHeuristics.prepareExecutionBrief(
                snapshot: snapshot,
                review: supervisorLastReview,
                startupPlan: supervisorStartupPlan
            )
            refreshSupervisorPanelHandoffs()
            appendLogEntry("已生成开工建议", level: .info, source: "supervisor")
        } catch {
            supervisorStartupPlan = WorkspaceSupervisorHeuristics.prepareStartupPlan(
                snapshot: snapshot,
                interactions: interactions
            )
            appendSupervisorRun(
                title: "生成开工建议",
                summary: supervisorStartupPlan?.progressSummary ?? "已回退到启发式开工建议。",
                outcome: "LLM 生成失败，已回退到启发式建议。",
                nextAction: supervisorStartupPlan?.recommendedAction ?? "确认目标与第一步动作。",
                source: "heuristic-fallback"
            )
            supervisorExecutionBrief = WorkspaceSupervisorHeuristics.prepareExecutionBrief(
                snapshot: snapshot,
                review: supervisorLastReview,
                startupPlan: supervisorStartupPlan
            )
            refreshSupervisorPanelHandoffs()
            appendLogEntry("开工建议生成失败：\(error.localizedDescription)", level: .warning, source: "supervisor")
        }
    }

    func requestSupervisorExecutionBrief(endpoint: String, apiKey: String, model: String) async {
        let snapshot = supervisorSnapshot
        let trimmedKey = apiKey.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedKey.isEmpty else {
            supervisorExecutionBrief = WorkspaceSupervisorHeuristics.prepareExecutionBrief(
                snapshot: snapshot,
                review: supervisorLastReview,
                startupPlan: supervisorStartupPlan
            )
            appendSupervisorRun(
                title: "生成执行简报",
                summary: supervisorExecutionBrief?.title ?? "已生成执行简报。",
                outcome: "已使用启发式规则整理出当前执行任务包。",
                nextAction: supervisorExecutionBrief?.executionSteps.first ?? "检查当前执行边界。",
                source: "heuristic-execution-brief"
            )
            refreshSupervisorPanelHandoffs()
            publishSupervisorStatusEntry()
            return
        }

        do {
            supervisorExecutionBrief = try await WorkspaceSupervisorLLMClient.executionBrief(
                snapshot: snapshot,
                review: supervisorLastReview,
                startupPlan: supervisorStartupPlan,
                endpoint: endpoint,
                apiKey: trimmedKey,
                model: model
            )
            appendSupervisorRun(
                title: "生成执行简报",
                summary: supervisorExecutionBrief?.title ?? "已生成执行简报。",
                outcome: supervisorExecutionBrief?.source == "llm" ? "LLM 已产出执行任务包。" : "已生成执行任务包。",
                nextAction: supervisorExecutionBrief?.executionSteps.first ?? "检查当前执行边界。",
                source: supervisorExecutionBrief?.source ?? "execution-brief"
            )
            refreshSupervisorPanelHandoffs()
            appendLogEntry("Supervisor execution brief updated", level: .info, source: "supervisor")
        } catch {
            supervisorExecutionBrief = WorkspaceSupervisorHeuristics.prepareExecutionBrief(
                snapshot: snapshot,
                review: supervisorLastReview,
                startupPlan: supervisorStartupPlan
            )
            appendSupervisorRun(
                title: "生成执行简报",
                summary: supervisorExecutionBrief?.title ?? "已回退到启发式执行简报。",
                outcome: "LLM 生成失败，已回退到启发式执行任务包。",
                nextAction: supervisorExecutionBrief?.executionSteps.first ?? "检查当前执行边界。",
                source: "heuristic-execution-fallback"
            )
            refreshSupervisorPanelHandoffs()
            appendLogEntry("Supervisor execution brief failed: \(error.localizedDescription)", level: .warning, source: "supervisor")
        }
        publishSupervisorStatusEntry()
    }

    func quickStartSupervisor(endpoint: String, apiKey: String, model: String) async {
        if supervisorTaskCharter.goal.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
           supervisorInteractionNotes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            refreshSupervisorHeuristicReview()
            return
        }

        await requestSupervisorStartupPlan(
            endpoint: endpoint,
            apiKey: apiKey,
            model: model
        )

        if supervisorTaskCharter.goal.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
           let suggestedGoal = supervisorStartupPlan?.goal.trimmingCharacters(in: .whitespacesAndNewlines),
           !suggestedGoal.isEmpty {
            supervisorTaskCharter.goal = suggestedGoal
            supervisorGoal = suggestedGoal
        }

        supervisorEnabled = true
        supervisorLastReview = WorkspaceSupervisorHeuristics.evaluate(snapshot: supervisorSnapshot)
        supervisorHealth = supervisorLastReview?.health ?? .idle
        supervisorUpdatedAt = Date()

        await requestSupervisorExecutionBrief(
            endpoint: endpoint,
            apiKey: apiKey,
            model: model
        )

        refreshSupervisorPanelHandoffs()
        appendSupervisorRun(
            title: "一键开工",
            summary: supervisorStartupPlan?.progressSummary ?? "监督器已根据最近交流整理开工上下文。",
            outcome: apiKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                ? "已通过启发式规则生成开工建议与执行简报。"
                : "已生成开工建议与执行简报，并进入监督状态。",
            nextAction: supervisorExecutionBrief?.executionSteps.first
                ?? supervisorStartupPlan?.recommendedAction
                ?? "检查当前目标并执行第一步。",
            source: "quick-start"
        )
        publishSupervisorStatusEntry()
    }

    func runSupervisorAutonomyLoop(endpoint: String, apiKey: String, model: String) async {
        stopSupervisorAutonomyLoop(reason: "restart")
        let settings = supervisorLoopSettings
        let trimmedKey = apiKey.trimmingCharacters(in: .whitespacesAndNewlines)

        supervisorLoopState = .running
        supervisorLoopStatusSummary = "自动循环已启动，最多执行 \(settings.maxIterations) 轮。"
        let initialTarget = selectSupervisorLoopTarget()
        appendSupervisorRun(
            title: "启动自动循环",
            summary: initialTarget.map { "自动循环已启动，当前目标窗口：\($0.panelTitle)" } ?? (supervisorLoopStatusSummary ?? "自动循环已启动。"),
            outcome: "等待第一轮评估。",
            nextAction: initialTarget?.nextAction ?? "按轮次检查当前工作区状态。",
            source: "loop-start"
        )

        supervisorAutonomyLoopTask = Task { @MainActor [weak self] in
            guard let self else { return }
            var lastFingerprint: String?
            var repeatedStableCount = 0

            for iteration in 1...settings.maxIterations {
                guard !Task.isCancelled else { return }
                let activeTarget = self.selectSupervisorLoopTarget()
                if let activeTarget {
                    self.upsertSupervisorPanelState(
                        panelID: activeTarget.panelID,
                        status: "running",
                        summary: "Round \(iteration) is now executing in this window.",
                        outcome: "The supervisor selected this window as the active execution target.",
                        nextAction: activeTarget.nextAction,
                        source: "loop-selection"
                    )
                }
                self.markSupervisorSupportingPanels(
                    activePanelID: activeTarget?.panelID,
                    defaultAction: "Stand by, preserve context, and prepare to support the active execution target."
                )
                self.refreshSupervisorPanelHandoffs()

                if settings.useLLMReview, !trimmedKey.isEmpty {
                    await self.requestSupervisorLLMReview(endpoint: endpoint, apiKey: trimmedKey, model: model)
                } else {
                    self.refreshSupervisorHeuristicReview()
                }

                guard let review = self.supervisorLastReview else { continue }
                let fingerprint = "\(review.health.rawValue)|\(review.nextAction)|\(review.summary)"
                if fingerprint == lastFingerprint {
                    repeatedStableCount += 1
                } else {
                    repeatedStableCount = 0
                    lastFingerprint = fingerprint
                }

                let targetText = activeTarget.map { "\($0.panelTitle) @ \($0.workingDirectory)" } ?? "当前工作区"
                let panelStatus = WorkspaceSupervisorHeuristics.handoffStatus(for: review)
                if let activeTarget {
                    self.upsertSupervisorPanelState(
                        panelID: activeTarget.panelID,
                        status: panelStatus,
                        summary: review.summary,
                        outcome: review.reason,
                        nextAction: review.nextAction,
                        source: settings.useLLMReview && !trimmedKey.isEmpty ? "loop-llm" : "loop-heuristic",
                        iteration: iteration
                    )
                }
                self.markSupervisorSupportingPanels(
                    activePanelID: activeTarget?.panelID,
                    defaultAction: "Review whether this window can unblock or accelerate the active execution target."
                )
                self.refreshSupervisorPanelHandoffs()
                self.supervisorLoopStatusSummary = "第 \(iteration)/\(settings.maxIterations) 轮已完成，当前状态：\(review.health.displayText)，目标窗口：\(targetText)。"
                self.appendSupervisorRun(
                    title: "自动循环第 \(iteration) 轮",
                    summary: activeTarget.map { "[\($0.panelTitle)] \(review.summary)" } ?? review.summary,
                    outcome: activeTarget.map { "目标窗口：\($0.panelTitle)。\(review.reason)" } ?? review.reason,
                    nextAction: activeTarget?.nextAction ?? review.nextAction,
                    source: settings.useLLMReview && !trimmedKey.isEmpty ? "loop-llm" : "loop-heuristic"
                )

                if settings.stopOnCompleted, review.health == .completed {
                    self.supervisorLoopState = .completed
                    self.supervisorLoopStatusSummary = "自动循环已停止：监督器判断任务已完成。"
                    self.supervisorActiveLoopTarget = nil
                    self.supervisorAutonomyLoopTask = nil
                    return
                }

                if settings.stopOnBlocked, review.health == .blocked {
                    let handoffs = self.supervisorPanelHandoffs
                    let stateByPanelID = self.supervisorPanelStateMap()
                    let queueByPanelID = self.supervisorQueueMap()
                    if self.supervisorCanContinuePastBlockedReview(
                        activePanelID: activeTarget?.panelID,
                        handoffs: handoffs,
                        stateByPanelID: stateByPanelID,
                        queueByPanelID: queueByPanelID
                    ) {
                        self.supervisorLoopStatusSummary = "第 \(iteration)/\(settings.maxIterations) 轮识别到阻塞，下一轮将切换到支援窗口尝试解阻。"
                    } else {
                        self.supervisorLoopState = .blocked
                        self.supervisorLoopStatusSummary = "自动循环已停止：监督器判断当前任务已阻塞。"
                        self.supervisorActiveLoopTarget = nil
                        self.supervisorAutonomyLoopTask = nil
                        return
                    }
                }

                if repeatedStableCount >= 1 {
                    self.supervisorLoopState = .stopped
                    self.supervisorLoopStatusSummary = "自动循环已停止：连续两轮没有新的判断变化。"
                    self.supervisorAutonomyLoopTask = nil
                    return
                }

                if iteration < settings.maxIterations {
                    let waitNs = UInt64(max(1, settings.intervalSeconds) * 1_000_000_000)
                    try? await Task.sleep(nanoseconds: waitNs)
                }
            }

            self.supervisorLoopState = .stopped
            self.supervisorLoopStatusSummary = "自动循环已完成设定轮次。"
            self.supervisorActiveLoopTarget = nil
            self.supervisorAutonomyLoopTask = nil
        }
    }

    func stopSupervisorAutonomyLoop(reason: String) {
        supervisorAutonomyLoopTask?.cancel()
        supervisorAutonomyLoopTask = nil
        supervisorActiveLoopTarget = nil
        if supervisorLoopState == .running {
            supervisorLoopState = .stopped
            supervisorLoopStatusSummary = reason == "manual" ? "自动循环已手动停止。" : "自动循环已停止。"
            appendSupervisorRun(
                title: "停止自动循环",
                summary: supervisorLoopStatusSummary ?? "自动循环已停止。",
                outcome: "当前不会继续自动评估。",
                nextAction: "如需继续，请再次启动自动循环。",
                source: "loop-stop"
            )
        }
    }

    func recordSupervisorCheckpoint(source: String) {
        let review = supervisorLastReview ?? WorkspaceSupervisorHeuristics.evaluate(snapshot: supervisorSnapshot)
        appendSupervisorRun(
            title: "监督循环检查",
            summary: review.summary,
            outcome: review.reason,
            nextAction: review.nextAction,
            source: source
        )
    }

    private func appendSupervisorRun(
        title: String,
        summary: String,
        outcome: String,
        nextAction: String,
        source: String
    ) {
        let entry = WorkspaceSupervisorRunEntry(
            title: title,
            summary: summary,
            outcome: outcome,
            nextAction: nextAction,
            source: source
        )
        supervisorRunJournal.insert(entry, at: 0)
        if supervisorRunJournal.count > 40 {
            supervisorRunJournal.removeLast(supervisorRunJournal.count - 40)
        }
    }

    func publishSupervisorStatusEntry() {
        guard supervisorEnabled else {
            statusEntries.removeValue(forKey: "supervisor.health")
            metadataBlocks.removeValue(forKey: "supervisor.review")
            return
        }

        guard let review = supervisorLastReview else {
            statusEntries.removeValue(forKey: "supervisor.health")
            metadataBlocks.removeValue(forKey: "supervisor.review")
            return
        }
        let color: String
        switch review.health {
        case .idle: color = "gray"
        case .running: color = "blue"
        case .attention: color = "orange"
        case .blocked: color = "red"
        case .completed: color = "green"
        }

        statusEntries["supervisor.health"] = SidebarStatusEntry(
            key: "监督器",
            value: review.health.displayText,
            icon: "brain",
            color: color,
            priority: 95,
            timestamp: Date()
        )
        metadataBlocks["supervisor.review"] = SidebarMetadataBlock(
            key: "监督器",
            markdown: """
            **目标**
            \((supervisorTaskCharter.goal.isEmpty ? supervisorGoal : supervisorTaskCharter.goal).isEmpty ? "未设置" : (supervisorTaskCharter.goal.isEmpty ? supervisorGoal : supervisorTaskCharter.goal))

            **完成标准**
            \(supervisorTaskCharter.doneDefinition.isEmpty ? "未设置" : supervisorTaskCharter.doneDefinition)

            **约束与范围**
            \((supervisorTaskCharter.constraints + "\n" + supervisorTaskCharter.scopeNotes).trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "未设置" : (supervisorTaskCharter.constraints + "\n" + supervisorTaskCharter.scopeNotes).trimmingCharacters(in: .whitespacesAndNewlines))

            **进度摘要**
            \(review.summary)

            **判断依据**
            \(review.reason)

            **下一步动作**
            \(review.nextAction)

            **建议提示词**
            ```
            \(review.suggestedPrompt)
            ```

            **执行简报**
            \(supervisorExecutionBrief?.title ?? "未生成")

            **执行模型提示词**
            ```
            \(supervisorExecutionBrief?.operatorPrompt ?? "暂无")
            ```

            **窗口交接数**
            \(supervisorPanelHandoffs.count)

            **当前循环窗口**
            \(supervisorActiveLoopTarget?.panelTitle ?? "未选定")

            **最近一次循环**
            \(supervisorRunJournal.first?.summary ?? "暂无")
            """,
            priority: 95,
            timestamp: Date()
        )
    }
}
