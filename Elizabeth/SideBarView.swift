//
//  SideBarView.swift
//  Elizabeth
//
//  Created by STACiA on 31/12/2568 BE.
//

import SwiftUI

@Observable class AppState {
    // environments
    var selectedEnvironment: String = "Globals"
    var environments: [String] = ["Globals"]

//    var selectionEnvironment: EnvironmentInfo?
    var selectedCollection: CollectionInfo?

    var collections: [CollectionInfo] = []

    init() {
        // collections
        for index in 1 ... 2 {
            collections.append(CollectionInfo(
                name: String(index),
                requests: [
                    RequestInfo(method: .get, url: "https://test.com", name: "Get User"),
                    RequestInfo(method: .post, url: "https://test.com", name: "Create Users"),
                    RequestInfo(method: .put, url: "https://test.com", name: "Update User"),
                    RequestInfo(method: .patch, url: "https://test.com", name: "Update User"),
                    RequestInfo(method: .delete, url: "https://test.com", name: "Delete User"),
                    RequestInfo(method: .head, url: "https://test.com", name: "Ping"),
                    RequestInfo(method: .options, url: "https://test.com", name: "Options Users")
                ]
            ))
        }

        // test
        environments.append(contentsOf: ["Local", "Production"])
    }
}

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
    @State var appState = AppState()

    @State var selectedSideBar: SideBarItem = .collections

    @State var visibility: NavigationSplitViewVisibility = .automatic

    var body: some View {
        NavigationSplitView(columnVisibility: $visibility) {
            List(selection: $selectedSideBar) {
//                NavigationLink(destination: CollectionList()) {
//                    Label("Collections", systemImage: "rectangle.3.group")
//                }.tag(SideBarItem.collections)
//                NavigationLink(destination: EnvironmentView2()) {
//                    Label("Environments", systemImage: "square")
//                }.tag(SideBarItem.environments)
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
            switch selectedSideBar {
            case .collections:
                CollectionView(appState: appState)
            case .environments:
                EnvironmentView2(appState: appState)
            }
//            EmptyView()
//            ContentUnavailableView("test", image: "plus")
        } detail: {
            switch selectedSideBar {
            case .collections:
                Text("Collections")
            case .environments:
                Text("Environments \(appState.selectedEnvironment)")
            }
//            EmptyView()
//            ContentUnavailableView("test", image: "plus")
        }.toolbar {
            ToolbarItem {
                Picker(appState.selectedEnvironment, selection: $appState.selectedEnvironment) {
                    ForEach(appState.environments, id: \.self) { env in
                        Text(env)
                    }
                }
                .labelsHidden()
                .scaledToFit()
            }
//            ToolbarItem {
//                Picker(selectedEnvironment, selection: $selectedEnvironment) {
//                    ForEach(environments, id: \.self) { env in
//                        Text(env)
//                    }
//                }
//                .labelsHidden()
//                .scaledToFit()
//            }

            // TODO: if selected request show this button
//            if selectedSideBar == .collections {
            ToolbarItem {
                Button(action: sendHttpRequest) {
                    Label("Save", systemImage: "play.fill")
                }.disabled(selectedSideBar == .collections)
            }
//            }
//            ToolbarItem {
//                Button(action: {
//                    $visibility.wrappedValue = .detailOnly
//                }) {
//                    Label("Full", systemImage: "rectangle.expand.diagonal")
//                }
//            }
        }
//        .navigationSplitViewStyle(.prominentDetail)
    }
}

#Preview {
    SidebarView()
}
