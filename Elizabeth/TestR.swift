//
//  TestR.swift
//  Elizabeth
//
//  Created by STACiA on 4/1/2569 BE.
//

import SwiftUI

enum AuthenticationMethod {
    case none
    case basic(username: String, password: String)
    case oauth(prefix: String, token: String)
    case apiKey(key: String, headerName: String)
}

typealias RequestData2 = (
    id: UUID,
    method: HTTPMethod,
    url: String,
    headers: [String: String]?,
    bodyContent: String?,
    params: [String: String]?,
    auth: AuthenticationMethod?
)

indirect enum CollectionItem {
    case collection(id: UUID, name: String, description: String, children: [CollectionItem])
    case request(id: UUID, name: String, description: String, data: RequestData2)
}

func getAuthHeaders(from auth: AuthenticationMethod) -> [String: String]? {
    switch auth {
    case .none:
        return nil
    case .basic(let username, let password):
        let credentials = "\(username):\(password)"
        return ["Authorization": "Basic \(credentials)"]
    case .oauth(let prefix, let token):
        return ["Authorization": "\(prefix) \(token)"]
    case .apiKey(let key, let headerName):
        return [headerName: key]
    }
}

func createRequest(
    name: String = "New Request",
    description: String = "",
    method: HTTPMethod = .get,
    url: String = "",
    headers: [String: String]? = nil,
    params: [String: String]? = nil,
    auth: AuthenticationMethod = .none
) -> (item: CollectionItem, id: UUID) {
    let id = UUID()

    var finalHeaders = headers ?? [:]
    if let authHeaders = getAuthHeaders(from: auth) {
        for (key, value) in authHeaders {
            finalHeaders[key] = value
        }
    }

    let requestData: RequestData2 = (
        id: id,
        method: method,
        url: url,
        headers: finalHeaders.isEmpty ? nil : finalHeaders,
        bodyContent: nil,
        params: params,
        auth: auth
    )

    let item = CollectionItem.request(
        id: id,
        name: name,
        description: description,
        data: requestData
    )

    return (item, id)
}

func createCollection(
    name: String = "New Collection",
    description: String = ""
) -> (item: CollectionItem, id: UUID) {
    let id = UUID()

    let item = CollectionItem.collection(
        id: id,
        name: name,
        description: description,
        children: []
    )

    return (item, id)
}

func deleteChild(at index: Int, from item: inout CollectionItem) {
    if case .collection(let id, let name, let description, var children) = item {
        children.remove(at: index)
        item = .collection(id: id, name: name, description: description, children: children)
    }
}

struct CollectionItemView2: View {
    @Binding var item: CollectionItem
    @Binding var selectedId: UUID?

    // closures สำหรับ เมื่อกดปุ่ม delete
    let onDelete: () -> Void

    // state
    // เมื่อ expand collection
    @State private var isExpanded: Bool = false
    // เมื่อ hover collection
    @State private var isHovered: Bool = false

    // เมื่อ กำลังแก้ไขชื่อ และ กำลังโฟกัส แก้ไขชื่อ
    @State private var isRenaming: Bool = false
    @FocusState private var isFocused: Bool

    var body: some View {
        switch item {
        case .collection(let id, let name, let description, let children):
            DisclosureGroup(isExpanded: $isExpanded) {
                let childrenBinding = Binding(
                    get: { children },
                    set: { newChildren in
                        item = .collection(id: id, name: name, description: description, children: newChildren)
                    }
                )

                ForEach(childrenBinding.indices, id: \.self) { index in
                    CollectionItemView2(
                        item: childrenBinding[index],
                        selectedId: $selectedId,
                        onDelete: {
                            deleteChild(at: index, from: &item)
                        }
                    )
                }

            } label: {
                let nameBinding = Binding<String>(
                    get: { name },
                    set: { item = .collection(id: id, name: $0, description: description, children: children) }
                )

                HStack {
                    Image(systemName: "folder")
                        .foregroundColor(.gray)

                    if isRenaming {
                        TextField("Name", text: nameBinding)
                            .font(.headline)
                            .textFieldStyle(.plain)
                            .focused($isFocused)
                            .onSubmit { isRenaming = false }
                            .onChange(of: isFocused) {
                                if !isFocused {
                                    isRenaming = false
                                }
                            }
                    } else {
                        Text(name).font(.headline)
                    }

                    Spacer()

                    if isHovered {
                        Button(action: {
                            // new request
                        }) {
                            Label("", systemImage: "plus").labelStyle(.iconOnly)
                        }
                        .buttonStyle(.plain)
                        .foregroundStyle(.gray)

                        Menu {
                            Button("Add Request") {
                                isExpanded = true
                            }
                            Button("Add Collection") {
                                isExpanded = true
                            }
                            Divider()
                            Button("Rename") {
                                selectedId = nil
                                isRenaming = true
                                isFocused = true
                            }
                            Button(action: {
                                onDelete()
                            }) {
                                Text("delete").foregroundColor(Color.red)
                            }
                        } label: {
                            Image(systemName: "ellipsis").padding(4)
                        }
                        .menuStyle(.borderlessButton)
                        .menuIndicator(.hidden)
                        .buttonStyle(.plain)
                        .fixedSize()
                        .tint(.gray)
                    }
                }
                .padding(.vertical, 4)
                .contentShape(.rect)
                .onHover { isHovered = $0 }
                .tag(id)
            }

        case .request(let id, let name, let description, let data):
            HStack {
                let nameBinding = Binding<String>(
                    get: { name },
                    set: { item = .request(id: id, name: $0, description: description, data: data) }
                )

                Text(data.method.rawValue.uppercased())
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(getMethodColor(for: data.method))

                if isRenaming {
                    TextField("Name", text: nameBinding)
                        .textFieldStyle(.plain)
                        .focused($isFocused)
                        .onSubmit { isRenaming = false }
                        .onChange(of: isFocused) {
                            if !isFocused { isRenaming = false }
                        }
                } else {
                    Text(name).font(.body)
                }

                Spacer()

                if isHovered {
                    Menu {
                        Button("Rename") {
                            selectedId = nil
                            isRenaming = true
                            isFocused = true
                        }

                        Button(action: {
                            onDelete()
                        }) {
                            Text("delete").foregroundColor(Color.red)
                        }
                    } label: {
                        Image(systemName: "ellipsis").padding(4)
                    }
                    .menuStyle(.borderlessButton)
                    .menuIndicator(.hidden)
                    .buttonStyle(.plain)
                    .fixedSize()
                    .tint(.gray)
                }
            }
            .padding(.vertical, 4)
            .contentShape(.rect)
            .onHover { isHovered = $0 }
            .tag(id)
        }
    }
}

struct TestRView: View {
    @Binding var collections: [CollectionItem]
    @Binding var selectedId: UUID?

    var body: some View {
        VStack {
            List(selection: $selectedId) {
                ForEach($collections.indices, id: \.self) { index in
                    CollectionItemView2(
                        item: $collections[index],
                        selectedId: $selectedId,
                        onDelete: {
                            collections.remove(at: index)
                        }
                    )
                }
            }
            .listStyle(.sidebar)
        }
    }
}

let sampleCollections: [CollectionItem] = [
    .collection(
        id: UUID(),
        name: "User APIs",
        description: "User management endpoints",
        children: [
            .request(
                id: UUID(),
                name: "Get User",
                description: "Fetch user by ID",
                data: (
                    UUID(), .get, "https://httpbin.org/get",
                    buildHeaders(("Accept", "application/json")),
                    nil, nil,
                    .oauth(prefix: "Bearer", token: "test")
                )
            ),
            .request(
                id: UUID(),
                name: "Create User",
                description: "Create new user",
                data: (
                    UUID(), .post, "https://httpbin.org/post",
                    buildHeaders(("Content-Type", "application/json")),
                    nil, nil,
                    .basic(username: "test", password: "test")
                )
            ),
            .request(
                id: UUID(),
                name: "Delete User",
                description: "Remove user account",
                data: (
                    UUID(), .delete, "https://httpbin.org/delete",
                    nil, nil, nil,
                    .oauth(prefix: "Bearer", token: "test")
                )
            )
        ]
    ),
    .collection(
        id: UUID(),
        name: "Product APIs",
        description: "Product catalog",
        children: [
            .request(
                id: UUID(),
                name: "List Products",
                description: "Get all products",
                data: (
                    UUID(), .get, "https://httpbin.org/get",
                    nil, nil,
                    buildParams(("limit", "10"), ("page", "1")),
                    .apiKey(key: "test", headerName: "X-API-Key")
                )
            ),
            .collection(
                id: UUID(),
                name: "Product CRUD",
                description: "Operations",
                children: [
                    .request(
                        id: UUID(),
                        name: "Update Product",
                        description: "Full update",
                        data: (UUID(), .put, "https://httpbin.org/put", nil, nil, nil, .none)
                    )
                ]
            )
        ]
    )
]

#Preview {
    @Previewable @State var collection = sampleCollections
    @Previewable @State var selectedId: UUID?
    TestRView(collections: $collection, selectedId: $selectedId)
}
