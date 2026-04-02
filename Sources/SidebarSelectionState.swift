import SwiftUI

extension SidebarSelection {
    var usesDetailSidebar: Bool {
        switch self {
        case .files, .sourceControl, .wechat, .supervisor:
            return true
        case .tabs, .remote, .notifications:
            return false
        }
    }
}

@MainActor
final class SidebarSelectionState: ObservableObject {
    @Published var selection: SidebarSelection {
        didSet {
            if selection.usesDetailSidebar {
                lastDetailSelection = selection
            }
        }
    }
    private(set) var lastDetailSelection: SidebarSelection

    init(selection: SidebarSelection = .tabs) {
        self.selection = selection
        self.lastDetailSelection = selection.usesDetailSidebar ? selection : .files
    }

    func toggleDetailSidebar(defaultSelection: SidebarSelection = .files) {
        if selection.usesDetailSidebar {
            selection = .tabs
            return
        }

        selection = lastDetailSelection.usesDetailSidebar ? lastDetailSelection : defaultSelection
    }
}
