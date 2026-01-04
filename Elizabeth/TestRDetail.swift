//
//  TestRDetail.swift
//  Elizabeth
//
//  Created by STACiA on 5/1/2569 BE.
//

import SwiftUI

enum RequestSection: String, CaseIterable, Identifiable {
    case docs = "Docs"
    case params = "Params"
    case auth = "Auth"
    case headers = "Headers"
    case body = "Body"
    var id: Self { self }
}

enum DetailTab: String, CaseIterable, Identifiable {
    case request = "Request"
    case response = "Response"
    var id: Self { self }
}

func isCollection(for item: CollectionItem) -> Bool {
    if case .collection = item {
        return true
    }
    return false
}

struct TestRDetail: View {
    @Binding var item: CollectionItem

    // state สำหรับสลับหน้า request กับ response
    @State private var currentTab: DetailTab = .request

    // state สำหรับ section ใน request ต่างๆ
    @State private var selectedSection: RequestSection = .docs

    // state สำหรับ ปิดใช้งานปุ่ม ช่วง loading
    @State private var isLoading: Bool = false

    // stete สำหรับ reponse ที่ได้จากการ request
    @State private var response: HTTPReponse?

    // state สำหรับ เลือกวิธีการ auth
    @State private var authMethod: AuthenticationMethod = .none

    var body: some View {
        VStack(alignment: .leading) {
            switch item {
            case .collection(_, let name, let description, let children):
                VStack(alignment: .leading, spacing: 4) {
                    Text(name).font(.title2).bold()
                    HStack(alignment: .top) {
                        Text(description).font(.body)
                        Spacer()
                    }

                    Divider()

                    List(children.indices, id: \.self) { cindex in
                        let child = children[cindex]
                        if case .request(_, let cname, _, let cdata) = child {
                            HStack {
                                Text("-").bold()
                                Text(cdata.method.rawValue.uppercased())
                                    .bold()
                                    .foregroundColor(getMethodColor(for: cdata.method))

                                Text(cname).font(.body)
//                                Divider()
//                                Text(cdescription).font(.body)
                            }
                        }
                    }
                }

                Spacer()

            case .request(let id, let name, let description, let data):
                if case .request = currentTab {
                    let methodBinding = Binding(
                        get: { data.method },
                        set: { newMethod in
                            var data = data
                            data.method = newMethod
                            item = .request(
                                id: id,
                                name: name,
                                description: description,
                                data: data
                            )
                        }
                    )

                    let urlBinding = Binding(
                        get: { data.url },
                        set: { newUrl in
                            var data = data
                            data.url = newUrl
                            item = .request(
                                id: id,
                                name: name,
                                description: description,
                                data: data
                            )
                        }
                    )

                    Text(name)

                    HStack {
                        Picker("", selection: methodBinding) {
                            ForEach(HTTPMethod.allCases) { method in
                                Text(method.rawValue.uppercased())
                            }
                        }
                        .labelsHidden()
                        .fixedSize()

                        TextField("Enter URL", text: urlBinding)
                            .textFieldStyle(.roundedBorder)
                    }

                    Picker("", selection: $selectedSection) {
                        ForEach(RequestSection.allCases) { pane in
                            Text(pane.rawValue.capitalized)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.segmented)
//                .onChange(of: selectedSection) { oldValue, newValue in
//                    print("Section changed from \(oldValue) to \(newValue)!")
//                }

                    switch selectedSection {
                    case .docs:
                        Text("Docs")
                    case .params:
                        let bindingParams = Binding<[String: String]>(
                            get: { data.params ?? [:] },
                            set: { newParams in
//                                   print(newParams)
                                var data = data
                                data.params = newParams.isEmpty ? nil : newParams
                                item = .request(id: id, name: name, description: description, data: data)
                            }
                        )

                        let params = bindingParams.wrappedValue
                        let paramkeys = params.keys.sorted()

                        HStack {
                            Text("Key").bold()
                            Spacer()
                            Text("Value").bold()
                            Spacer()
                        }.padding(.vertical, 4)

                        List(paramkeys, id: \.self) { key in
                            HStack {
                                TextField("Key", text: .constant(key))
                                Spacer()
                                TextField("Value", text: .constant(params[key]!))
                                Spacer()
                            }.tag(key)
                        }

                        Button(action: {
                            var updated = params
                            updated["param-\(params.count)"] = "test"
                            bindingParams.wrappedValue = updated
                        }) {
                            Label("Add Param", systemImage: "plus")
                        }
                    case .auth:
                        HStack {
                            Picker("", selection: $authMethod) {
                                Text("None").tag(AuthenticationMethod.none)
                                Text("Basic").tag(AuthenticationMethod.basic(username: "", password: ""))
                                Text("OAuth").tag(AuthenticationMethod.oauth(prefix: "", token: ""))
                                Text("API Key").tag(AuthenticationMethod.apiKey(key: "", headerName: ""))
                            }
                            .labelsHidden()
                            .fixedSize()
                            .pickerStyle(.segmented)
                        }
//                        switch authMethod {
//                        case .none:
//                            Text("This request does not use any authorization.")
//                                .font(.body)
//                        case .basic:
//                            let authBasicUsername = Binding<String>(
//                                get: {
//                                    if case .basic(let username, _) = data.auth {
//                                        return username
//                                    }
//                                    return ""
//                                },
//                                set: { _ in
//                                    var data = data
//                                    if case .basic(let username, let password) = data.auth {
//                                        print("wtf")
                    ////                                        data.auth = .basic(username: newUsername, password: password)
                    ////                                        item = .request(
                    ////                                            id: id,
                    ////                                            name: name,
                    ////                                            description: description,
                    ////                                            data: data
                    ////                                        )
//                                    }
//                                }
//                            )
//
//                            HStack {
//                                Text("Username").frame(maxWidth: 85, alignment: .leading)
//                                TextField(
//                                    "Username",
//                                    text: authBasicUsername
//                                )
//                            }
//                            HStack {
//                                Text("Password").frame(maxWidth: 85, alignment: .leading)
//                                TextField(
//                                    "Username",
//                                    text: .constant("")
//                                )
//                            }
//                        case .oauth:
//                            Text("oauth")
//                        case .apiKey:
//                            Text("apiKey")
//                        }
                    case .headers:
                        VStack(alignment: .leading) {
                            let bindingHeaders = Binding<[String: String]>(
                                get: { data.headers ?? [:] },
                                set: { newHeaders in
                                    print(newHeaders)
                                    var data = data
                                    data.headers = newHeaders.isEmpty ? nil : newHeaders
                                    item = .request(id: id, name: name, description: description, data: data)
                                }
                            )

                            let headers = bindingHeaders.wrappedValue
                            let headerKeys = headers.keys.sorted()

                            HStack {
                                Text("Key").bold()
                                Spacer()
                                Text("Value").bold()
                                Spacer()
                            }.padding(.vertical, 4)

                            List(headerKeys, id: \.self) { key in
                                HStack {
                                    TextField("Key", text: .constant(key))
                                    Spacer()
                                    TextField("Value", text: .constant(headers[key]!))
                                    Spacer()
                                }.tag(key)
                            }

                            Button(action: {
                                var updated = headers
                                updated["new-header-\(headers.count)"] = ""
                                bindingHeaders.wrappedValue = updated
                            }) {
                                Label("Add Header", systemImage: "plus")
                            }
                        }
                    case .body:
                        Text("Body")
                    }

                } else {
                    if let response {
                        let statusCode = response.statusCode ?? 200
                        let statusMessage = statusMessage(for: statusCode).uppercased()
                        let duration = response.duration
                        let fmtDuration = formatDuration(duration)
                        // TODO: add content-length

                        Button(action: {}) {
                            Text("\(statusCode) \(statusMessage)").foregroundStyle(statusColor(for: statusCode))
                            Text(" | ")
                            Text("\(fmtDuration)")
                        }

                        TextEditor(text: .constant(response.data ?? ""))
                            .background(Color(white: 0.1))
                            .foregroundColor(Color(white: 0.9))
                            .scrollContentBackground(.hidden)
                            .font(.system(size: 13, design: .monospaced))
                    }
                }

                Spacer()

                HStack {
                    Spacer()
                    Picker("", selection: $currentTab) {
                        ForEach(DetailTab.allCases, id: \.self) {
                            Text($0.rawValue).tag($0)
                        }
                    }
                    .labelsHidden()
                    .fixedSize()
                    .pickerStyle(.segmented)

                    Spacer()
                }
            }
        }
        .padding()
        .toolbar {
            ToolbarItem {
                Button(action: {
//                    assert(!isCollection(for: item))
//                    precondition(!isCollection(for: item), "Colection item must be request.")

                    guard case .request(let id, let name, _, let requestData) = item else {
                        return
                    }

                    print("LOG: request \(id):\(name)")

                    Task {
                        // ไม่ต้องแล้ว เพราะ disable ปุ่มไปแล้ว
                        // if isLoading { return }

                        defer { isLoading = false }
                        defer { currentTab = .response }

                        // set loading เป็น true เพื่อปิดใช้งานปุ่ม

                        isLoading = true

                        // ทำการ http request ไปยัง url

                        response = await sendHttpRequest2(requestData)
                    }

                }) {
                    Label("Send", systemImage: "play.fill")
                }
                // ถ้าเป็น collection จะไม่สามารถ http request ได้ หรือ ช่วงที่กำลัง loading
                // จะทำการ ปิดปุ่ม ไม่ให้ใช้งาน
                .disabled(isCollection(for: item) || isLoading)
            }
        }
    }
}

#Preview {
    @Previewable @State var item: CollectionItem = .request(
        id: UUID(),
        name: "Get User",
        description: "Fetch user by ID",
        data: (
            UUID(), .get, "https://httpbin.org/get",
            buildHeaders(("Accept", "application/json")),
            nil, nil,
            .oauth(prefix: "Bearer", token: "test")
        )
    )
    @Previewable @State var item2: CollectionItem = .collection(
        id: UUID(),
        name: "REST API",
        description: "Test Description",
        children: [.request(
            id: UUID(),
            name: "Get Users",
            description: "Get all users",
            data: (
                UUID(), .get, "https://httpbin.org/get",
                buildHeaders(("Accept", "application/json")),
                nil, nil,
                .oauth(prefix: "Bearer", token: "test")
            )
        ),
        .request(
            id: UUID(),
            name: "Get User",
            description: "Get user by Id",
            data: (
                UUID(), .post, "https://httpbin.org/get",
                buildHeaders(("Accept", "application/json")),
                nil, nil,
                .oauth(prefix: "Bearer", token: "test")
            )
        )]
    )
    TestRDetail(item: $item)
}
