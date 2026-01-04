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

    @Binding var selectedRequest: RequestItem?

    @State var hoveredItemId: UUID?

    var body: some View {
        @Bindable var bindableAppState = appState

        VStack(alignment: .leading) {
            HStack {
                Button(action: {
                    let newCollection = RequestItem(
                        id: UUID(),
                        name: "New Collection"
                    )
                    appState.collections.append(newCollection)
                    selectedRequest = newCollection
                }) {
                    Label("", systemImage: "plus")
                        .labelStyle(.iconOnly)
                }
                Text("New Collection")
            }
            .padding(.top, 10)
            .padding(.leading, 10)

            List($bindableAppState.collections, children: \.children, selection: $selectedRequest) { $item in
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
                                selectedRequest = newRequest
                                hoveredItemId = item.id
                            }) {
                                Label("", systemImage: "plus").labelStyle(.iconOnly)
                            }
                            .buttonStyle(.plain)
                            .foregroundStyle(.gray)

                            Menu {
                                Button("Add Request") {
                                    let newRequest = addRequest(to: &item)
                                    selectedRequest = newRequest
                                    hoveredItemId = item.id
                                }

                                Button("Add Collection") {
                                    let newCollection = addCollection(to: &item)
                                    selectedRequest = newCollection
                                    hoveredItemId = item.id
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
                    .opacity((hoveredItemId != nil && hoveredItemId == item.id) ? 1 : 0)
                }
                .tag(item)
                .padding(.vertical, 4)
                .onHover { isHovered in
                    if isHovered {
                        hoveredItemId = item.id
                    } else {
                        hoveredItemId = nil
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
    CollectionView(selectedRequest: $selectionRequest).environment(appState)
}
