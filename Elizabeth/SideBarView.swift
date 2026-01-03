//
//  SideBarView.swift
//  Elizabeth
//
//  Created by STACiA on 31/12/2568 BE.
//

import SwiftUI

enum SideBarItem: String, CaseIterable {
    case collections = "Collections"
    case environments = "Environments"
}

func getSideBarSystemImage(_ sidebar: SideBarItem) -> String {
    switch sidebar {
    case .collections:
        return "rectangle.3.group"
    case .environments:
        return "square"
    }
}

struct SidebarView: View {
    @Environment(AppState.self) private var appState

    @State var selectedSideBar: SideBarItem = .collections
    @State var selectionRequest: RequestItem?

    @State var visibility: NavigationSplitViewVisibility = .automatic

    var body: some View {
        @Bindable var bindableAppState = appState

        NavigationSplitView(columnVisibility: $visibility) {
            List(selection: $selectedSideBar) {
                NavigationLink(value: SideBarItem.collections) {
                    Label("Collections", systemImage: "rectangle.3.group")
                }
                NavigationLink(value: SideBarItem.environments) {
                    Label("Environments", systemImage: "square")
                }
            }
            .navigationTitle("Sidebar")
            .listStyle(.sidebar)
            .navigationTitle("Menu")
        } content: {
//            switch selectedSideBar {
//            case .collections:
//                CollectionView(appState: appState, selectionRequest: $selectionRequest)
//            case .environments:
//                EnvironmentView2(appState: appState)
//            }
            ZStack {
                CollectionView(selectionRequest: $selectionRequest)
                    .opacity(selectedSideBar == .collections ? 1 : 0)

                EnvironmentView2()
                    .opacity(selectedSideBar == .environments ? 1 : 0)
            }
        } detail: {
            // TODO: use ZStack for persistant view
            switch selectedSideBar {
            case .collections:
                if let selectedRequest = selectionRequest {
                    RequestDetailView(
                        request: Binding(
                            get: { selectedRequest },
                            set: { selectionRequest = $0 }
                        )
                    )
                } else {
                    ContentUnavailableView(
                        "No Request Selected",
                        systemImage: "doc.text.magnifyingglass",
                        description: Text("Select a request to view details")
                    )
                }
            case .environments:
                EnvironmentDetailView()
            }
        }.toolbar {
            ToolbarItem {
                Picker("", selection: $bindableAppState.selectedEnvironment) {
                    ForEach(appState.environments, id: \.self) { env in
                        Text(env)
                    }
                }
                .labelsHidden()
                .fixedSize()
            }
        }
//        .navigationSplitViewStyle(.prominentDetail)
    }
}

#Preview {
    @Previewable @State var appState = AppState()
    SidebarView().environment(appState)
}
