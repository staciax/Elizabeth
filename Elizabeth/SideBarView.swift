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

func getCollectionItemId(_ item: CollectionItem) -> UUID {
    switch item {
    case .collection(let id, _, _, _):
        return id
    case .request(let id, _, _, _):
        return id
    }
}
// enumerations: Recursive Enumerations
func findBinding(for targetId: UUID, in items: Binding<[CollectionItem]>) -> Binding<CollectionItem>? {
    SearchLoop: for index in items.wrappedValue.indices {
        let currentItem = items.wrappedValue[index]

        if getCollectionItemId(currentItem) == targetId {
            return items[index]
        }
        
        // control flow: Patterns, Early Return, Continue
        guard case .collection(let id, let name, let description, let children) = currentItem else {
            continue SearchLoop
        }

        let childrenBinding = Binding(
            get: { children },
            set: { newChildren in
                items.wrappedValue[index] = .collection(
                    id: id,
                    name: name,
                    description: description,
                    children: newChildren
                )
            }
        )

        if let found = findBinding(for: targetId, in: childrenBinding) {
            return found
        }
       
    }

    return nil
}

struct SidebarView: View {
    @Environment(AppState.self) private var appState
    @State var selectedSideBar: SideBarItem = .collections

    // state
    @State private var selectedId: UUID?

    // test
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
                TestRView(selectedId: $selectedId)
                    .opacity(selectedSideBar == .collections ? 1 : 0)

                EnvironmentView2()
                    .opacity(selectedSideBar == .environments ? 1 : 0)
            }
        } detail: {
            // TODO: use ZStack for persistant view
            switch selectedSideBar {
            case .collections:
                if let selectedId, let itemBinding = findBinding(for: selectedId, in: $bindableAppState.collections) {
                    TestRDetail(item: itemBinding)
//                        .id(selectedId)
                } else {
                    ContentUnavailableView(
                        "No Request Selected",
                        systemImage: "mail.and.text.magnifyingglass"
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
