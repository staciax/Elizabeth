//
//  CollectionView.swift
//  Elizabeth
//
//  Created by STACiA on 1/1/2569 BE.
//

import SwiftUI

struct RequestData: Hashable {
    var method: HTTPMethod
    var url: String
    var headers: [String: String]?
    var bodyContent: String?
}

struct RequestItem: Identifiable, Hashable, Equatable {
    let id: UUID
    var name: String
    var description: String?
    var data: RequestData?
    var children: [RequestItem]?
}

let sampleData: [RequestItem] = [
    RequestItem(
        id: UUID(),
        name: "YUNA REST API",
        description: "test",
        children: [
            RequestItem(
                id: UUID(),
                name: "Users",
                description: "Users",
                children: [
                    RequestItem(
                        id: UUID(),
                        name: "Get users",
                        data: RequestData(method: .get, url: "https://httpbin.org/get")

                    ),
                    RequestItem(
                        id: UUID(),
                        name: "Get user by id",
                        data: RequestData(method: .get, url: "https://httpbin.org/get")

                    ),
                    RequestItem(
                        id: UUID(),
                        name: "Create user",
                        data: RequestData(method: .post, url: "https://httpbin.org/post")

                    ),
                    RequestItem(
                        id: UUID(),
                        name: "Update user",
                        data: RequestData(method: .patch, url: "localhost/v1/users")

                    ),
                    RequestItem(
                        id: UUID(),
                        name: "Delete user",
                        data: RequestData(method: .delete, url: "localhost/v1/users")
                    )
                ]
            ),
            RequestItem(
                id: UUID(),
                name: "Authentication",
                description: "Users",
                children: [
                    RequestItem(
                        id: UUID(),
                        name: "Sign-in",
                        data: RequestData(method: .post, url: "localhost/v1/auth/sign-in")

                    ),
                    RequestItem(
                        id: UUID(),
                        name: "Sign-up",
                        data: RequestData(method: .post, url: "localhost/v1/auth/sign-up")
                    )
                ]
            )
        ]
    ),
    RequestItem(
        id: UUID(),
        name: "Empty folder"
    ),
    RequestItem(
        id: UUID(),
        name: "test",
        data: RequestData(method: .get, url: "https://httpbin.org/get")
    )
]

struct CollectionView: View {
    @Bindable var appState: AppState
    @Binding var selectionRequest: RequestItem?

    @State var items: [RequestItem] = sampleData

    @State var listSelection: RequestItem?

    @State var hoveredItem: RequestItem?

    var body: some View {
        VStack {
            List(items, children: \.children, selection: $listSelection) { item in
                HStack {
                    let isFolder = (item.children != nil || item.data == nil)
                    if isFolder {
                        Image(systemName: "folder").foregroundColor(.gray)
                    } else if let data = item.data {
                        Text(data.method.rawValue.uppercased())
                            .bold()
                            .foregroundColor(getMethodColor(data.method))
                    }
                    Text(item.name)
                        .font(item.children == nil ? .body : .headline)
                    Spacer()

                    Group {
                        if isFolder {
                            Button(action: {}) {
                                Label("", systemImage: "plus").labelStyle(.iconOnly)
                            }
                            .buttonStyle(.plain)
                            .foregroundStyle(.gray)

                            Menu {
                                Button("Add request") {
                                    print("Action 1 performed")
                                }
                                Button("Add Folder") {
                                    print("Action 2 performed")
                                }
                                Divider()
                                Button("Rename") {
                                    print("Delete action performed")
                                }
                                Button(action: {}) {
                                    Text("Delete").foregroundColor(Color.red)
                                }
                            } label: {
                                Label("PDF", systemImage: "ellipsis")
                                    .labelStyle(.iconOnly)
                            }
                            .fixedSize()
                            .menuStyle(.borderlessButton)
                            .menuIndicator(.hidden)
                            .tint(.gray)
                        } else {
                            Menu {
                                Button("Rename") {
                                    print("renamed")
                                }
                                Button(action: {
                                    print("")
                                }) {
                                    Text("delete").foregroundColor(Color.red)
                                }
                            } label: {
                                Label("", systemImage: "ellipsis")
                                    .labelStyle(.iconOnly)
                            }
                            .fixedSize()
                            .menuStyle(.borderlessButton)
                            .menuIndicator(.hidden)
                            .tint(.gray)
                        }
                    }
                    .padding(.trailing, 4)
                    .opacity((hoveredItem != nil && hoveredItem == item) ? 1 : 0)
                }
                .tag(item)
                .padding(.vertical, 4)
                .onChange(of: listSelection, initial: false) { _, newValue in
                    if let newValue {
                        selectionRequest = newValue
                    }
                }
                .onHover { isHovered in
                    if isHovered {
                        hoveredItem = item
                    } else {
                        hoveredItem = nil
                    }
                }
//                .border(.red)
            }
        }
    }
}

#Preview {
    @Previewable @State var selectionRequest: RequestItem?
    @Previewable @State var appState = AppState()
    CollectionView(appState: appState, selectionRequest: $selectionRequest)
}
