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
    var selectedHttpRequest: HTTPRequest?

    var collections: [CollectionInfo] = []

    init() {
        // collections
        for index in 1 ... 2 {
            collections.append(CollectionInfo(
                name: String(index),
                requests: [
                ],
                httpRequets: [
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
    @State var selectionRequest: RequestItem?

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
                CollectionView(appState: appState, selectionRequest: $selectionRequest)
            case .environments:
                EnvironmentView2(appState: appState)
            }
//            EmptyView()
//            ContentUnavailableView("test", image: "plus")
        } detail: {
            switch selectedSideBar {
            case .collections:
                if let selectedRequest = selectionRequest {
                    if selectedRequest.data != nil {
                        RequestDetailView(request: Binding(
                            get: { selectedRequest },
                            set: { selectionRequest = $0 }
                        ))
                    } else {
                        VStack(alignment: .leading) {
                            Text("Overview").font(.title).bold()
                            HStack(alignment: .top) {
                                Text(selectedRequest.description ?? "")
                                Spacer()
                            }
                            Spacer()
                        }.padding()
                    }

                } else {
                    ContentUnavailableView(
                        "No Request Selected",
                        systemImage: "doc.text.magnifyingglass",
                        description: Text("Select a request to view details")
                    )
                }
//                if let request = Binding($selectionRequest) {
//                    RequestDetailView(request: request)
//                } else {
//                    VStack(alignment: .center) {
//                        HStack(alignment: .center) {
//                            VStack {
//                                Button("Create a new request") {}
//                            }
//                        }
//                    }
            ////                    ContentUnavailableView("No request selected", systemImage: "xmark")
//                    // TODO: create new request
//                }
            case .environments:
                Text("Environments \(appState.selectedEnvironment)")
            }
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
                }
                .disabled(
                    selectedSideBar != .collections || selectionRequest?.data == nil
                )
            }
        }
//        .navigationSplitViewStyle(.prominentDetail)
    }
}

#Preview {
    SidebarView()
}
