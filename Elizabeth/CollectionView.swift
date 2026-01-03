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
        name: "Test",
        description: "Just for test",
        data: RequestData(method: .get, url: "https://httpbin.org/get")
    )
]

struct CollectionView: View {
    @Environment(AppState.self) private var appState

    @Binding var selectionRequest: RequestItem?

    @State var items: [RequestItem] = sampleData

    @State var listSelection: RequestItem?

    @State var hoveredItem: RequestItem?

    var body: some View {
        VStack {
            List($items, children: \.children, selection: $listSelection) { $item in
                HStack {
                    let isFolder = ($item.wrappedValue.children != nil || $item.wrappedValue.data == nil)

                    if isFolder {
                        Image(systemName: "folder").foregroundColor(.gray)
                    } else {
                        let method = $item.data.wrappedValue?.method ?? HTTPMethod.get
                        Text(method.rawValue.uppercased())
                            .bold()
                            .foregroundColor(getMethodColor(for: method))
                    }
                    Text($item.wrappedValue.name).font(!isFolder ? .body : .headline)
                    Spacer()

                    Group {
                        if isFolder {
                            Button(action: {
                                print("Add request")

                                let newRequest = RequestItem(
                                    id: UUID(),
                                    name: "New Request",
                                    data: RequestData(
                                        method: .get,
                                        url: ""
                                    )
                                )

                                if $item.children.wrappedValue == nil {
                                    print("$item.children.nil")
                                    $item.children.wrappedValue = []
                                }

                                $item.children.wrappedValue?.append(
                                    newRequest
                                )

                                listSelection = newRequest
                                hoveredItem = item
                            }) {
                                Label("", systemImage: "plus").labelStyle(.iconOnly)
                            }

                            .buttonStyle(.plain)
                            .foregroundStyle(.gray)

                            Menu {
                                Button("Add Request") {
                                    print("Add request")

                                    let newRequest = RequestItem(
                                        id: UUID(),
                                        name: "New Request",
                                        data: RequestData(
                                            method: .get,
                                            url: ""
                                        )
                                    )

                                    if $item.children.wrappedValue == nil {
                                        print("$item.children.nil")
                                        $item.children.wrappedValue = []
                                    }

                                    $item.children.wrappedValue?.append(
                                        newRequest
                                    )

                                    listSelection = newRequest
                                    hoveredItem = item
                                }

                                Button("Add Folder") {
                                    print("Add folder")

                                    let newFolder = RequestItem(
                                        id: UUID(),
                                        name: "New Folder"
                                    )

                                    if $item.children.wrappedValue == nil {
                                        print("$item.children.nil")
                                        $item.children.wrappedValue = []
                                    }

                                    $item.children.wrappedValue?.append(
                                        newFolder
                                    )

                                    listSelection = newFolder
                                    hoveredItem = item
                                }

                                Divider()
                                Button("Rename") {
                                    print("Rename")
                                }

                                Button(action: {
                                    print("Delete")
                                }) {
                                    Text("Delete").foregroundColor(Color.red)
                                }

                            } label: {
                                Label("", systemImage: "ellipsis")
                                    .labelStyle(.iconOnly)
                            }
                            .fixedSize()
                            .menuStyle(.borderlessButton)
                            .menuIndicator(.hidden)
                            .tint(.gray)
                        } else {
                            Menu {
                                Button("Rename") {
                                    print("Rename")
                                }

                                Button(action: {
                                    print("Delete")
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
    CollectionView(selectionRequest: $selectionRequest).environment(appState)
}
