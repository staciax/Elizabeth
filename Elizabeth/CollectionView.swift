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
        name: "Empty Collection"
    ),
    RequestItem(
        id: UUID(),
        name: "Test",
        description: "Just for test",
        data: RequestData(method: .get, url: "https://httpbin.org/get")
    )
]

func addRequest(to item: inout RequestItem) -> RequestItem {
    let newRequest = RequestItem(
        id: UUID(),
        name: "New Request",
        data: RequestData(
            method: .get,
            url: ""
        )
    )

    if item.children == nil {
        item.children = []
    }

    item.children?.append(newRequest)
    return newRequest
}

func addCollection(to item: inout RequestItem) -> RequestItem {
    let newCollection = RequestItem(
        id: UUID(),
        name: "New Collection"
    )

    if item.children == nil {
        item.children = []
    }

    item.children?.append(newCollection)
    return newCollection
}

struct CollectionView: View {
    @Environment(AppState.self) private var appState

    @Binding var selection: RequestItem?

    @State var items: [RequestItem] = sampleData

    @State var hoveredItem: RequestItem?

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    let newCollection = RequestItem(
                        id: UUID(),
                        name: "New Collection"
                    )
                    items.append(newCollection)
                    selection = newCollection
                }) {
                    Label("", systemImage: "plus")
                        .labelStyle(.iconOnly)
                }
                Text("New Collection")
            }
            .padding(.top, 10)

            List($items, children: \.children, selection: $selection) { $item in
                HStack {
                    let isCollection = ($item.wrappedValue.children != nil || $item.wrappedValue.data == nil)

                    if isCollection {
                        Image(systemName: "folder").foregroundColor(.gray)
                    } else {
                        let method = $item.data.wrappedValue?.method ?? HTTPMethod.get
                        Text(method.rawValue.uppercased())
                            .bold()
                            .foregroundColor(getMethodColor(for: method))
                    }
                    Text($item.wrappedValue.name).font(!isCollection ? .body : .headline)
                    Spacer()

                    Group {
                        if isCollection {
                            Button(action: {
                                let newRequest = addRequest(to: &item)
                                selection = newRequest
                                hoveredItem = item
                            }) {
                                Label("", systemImage: "plus").labelStyle(.iconOnly)
                            }
                            .buttonStyle(.plain)
                            .foregroundStyle(.gray)

                            Menu {
                                Button("Add Request") {
                                    let newRequest = addRequest(to: &item)
                                    selection = newRequest
                                    hoveredItem = item
                                }

                                Button("Add Collection") {
                                    let newCollection = addCollection(to: &item)
                                    selection = newCollection
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
    CollectionView(selection: $selectionRequest).environment(appState)
}
