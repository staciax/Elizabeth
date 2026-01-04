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

// @discardableResult
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

// @discardableResult
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
            let nameBinding = Binding(
                get: { name },
                set: { item = .collection(id: id, name: $0, description: description, children: children) }
            )

            let childrenBinding = Binding(
                get: { children },
                set: { newChildren in
                    item = .collection(id: id, name: name, description: description, children: newChildren)
                }
            )

            DisclosureGroup(isExpanded: $isExpanded) {
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
                            isExpanded = true
                            let newRequest = createRequest()
                            selectedId = newRequest.id
                            childrenBinding.wrappedValue.append(newRequest.item)
                        }) {
                            Label("", systemImage: "plus").labelStyle(.iconOnly)
                        }
                        .buttonStyle(.plain)
                        .foregroundStyle(.gray)

                        Menu {
                            Button("Add Request") {
                                isExpanded = true
                                let newRequest = createRequest()
                                selectedId = newRequest.id
                                childrenBinding.wrappedValue.append(newRequest.item)
                            }
                            Button("Add Collection") {
                                isExpanded = true
                                let newCollection = createCollection()
                                selectedId = newCollection.id
                                childrenBinding.wrappedValue.append(newCollection.item)
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
            let nameBinding = Binding(
                get: { name },
                set: { item = .request(id: id, name: $0, description: description, data: data) }
            )

            HStack {
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
    @Environment(AppState2.self) var appState

    @Binding var selectedId: UUID?

    var body: some View {
        @Bindable var bindableAppState = appState

        VStack(alignment: .leading) {
            HStack {
                Button(action: {
                    let newCollection = createCollection()
                    selectedId = newCollection.id
                    bindableAppState.collections.append(newCollection.item)
                }) {
                    Label("", systemImage: "plus")
                        .labelStyle(.iconOnly)
                }
                Text("New Collection")
            }
            .padding(.top, 10)
            .padding(.leading, 10)

            List(selection: $selectedId) {
                ForEach($bindableAppState.collections.indices, id: \.self) { index in
                    CollectionItemView2(
                        item: $bindableAppState.collections[index],
                        selectedId: $selectedId,
                        onDelete: {
                            bindableAppState.collections.remove(at: index)
                        }
                    )
                }
            }
            .listStyle(.sidebar)
        }
    }
}

#Preview {
    @Previewable @State var selectedId: UUID?
    @Previewable @State var appState = AppState2()
    TestRView(selectedId: $selectedId).environment(appState)
}
