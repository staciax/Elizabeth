//
//  RequestDetailView.swift
//  Elizabeth
//
//  Created by STACiA on 2/1/2569 BE.
//

import SwiftUI

enum PanePanel: String, CaseIterable, Identifiable {
    case docs, params, auth, headers, body
    var id: Self { self }
}

// struct LineNumberCodeView: View {
//    let content: String
//
//    var body: some View {
//        // Use a Read-Only TextEditor for native selection/copy/paste
//        TextEditor(text: .constant(content))
//            .font(.system(size: 13, design: .monospaced))
//            .scrollContentBackground(.hidden) // Required for custom background
//            .background(Color(white: 0.11))
//            .foregroundColor(Color(white: 0.9))
//            .padding(8)
//    }
// }

struct LineNumberCodeView: View {
    let content: String
    let fontSize: CGFloat = 13

    private var lines: [String] {
        content.components(separatedBy: .newlines)
    }

    private let backgroundColor = Color(white: 0.11)
    private let codeTextColor = Color(white: 0.9)
    private let dividerColor = Color(white: 0.25)

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(Array(lines.enumerated()), id: \.offset) { index, line in
                    HStack(alignment: .top, spacing: 0) {
                        // line number
                        Text("\(index + 1)")
                            .font(.system(size: fontSize, design: .monospaced))
                            .foregroundColor(codeTextColor)
                            .frame(width: 44, alignment: .trailing)
                            .padding(.trailing, 8)
                            .padding(.leading, 8)
                            .padding(.vertical, 3)

                        // divider
                        Rectangle()
                            .fill(dividerColor)
                            .frame(width: 1)

                        // code line
                        Text(line.isEmpty ? " " : line)
                            .font(.system(size: fontSize, design: .monospaced))
                            .foregroundColor(codeTextColor)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 3)
                            .textSelection(.enabled)
                    }
                    .background(backgroundColor)
                }
            }
        }
        .background(backgroundColor)
    }
}

enum RequestDetailPanel: String, CaseIterable, Identifiable {
    case request, response
    var id: Self { self }
}

enum AuthType: String, CaseIterable, Identifiable {
    case none = "None", basic = "Basic", oauth = "OAuth"
    var id: Self { self }
}

enum BodyType: String, CaseIterable, Identifiable {
    case formData = "FormData"
    case raw = "Raw"
    var id: Self { self }
}

struct Param: Identifiable {
    var key: String
    var value: String
    var id: String { key }
}

struct Header: Identifiable {
    var key: String
    var value: String
    var id: String { key }
}

struct RequestDetailView: View {
    @Binding var request: RequestItem

    // state
    @State private var selectedPane: PanePanel = .docs
    @State private var selectedPanel: RequestDetailPanel = .request
    @State private var selectedAuthType: AuthType = .none
    @State private var selectedBodyType: BodyType = .formData
    @State private var bodyRaw: String = ""

    // auth basic
    @State private var username: String = ""
    @State private var password: String = ""

    // auth oauth
    @State private var oauthToken: String = ""
    @State private var oauthPrefix: String = "Bearer"

    // http response
    @State var response: HTTPRequestResult?

    // test
    @State private var params = [
        Param(key: "test key", value: "test value"),
        Param(key: "test key 2", value: "test value"),
        Param(key: "test key 3", value: "test value"),
        Param(key: "test key 4", value: "test value"),
        Param(key: "test key 5", value: "test value"),
    ]
    @State private var headers = [
        Header(key: "test key", value: "test value"),
        Header(key: "test key 2", value: "test value"),
        Header(key: "test key 3", value: "test value"),
        Header(key: "test key 4", value: "test value"),
        Header(key: "test key 5", value: "test value"),
    ]

//    @State private var params: [String: String] = [:]

    @State private var longText = "This text can be edited by the user."
    @State private var lineCount: Int = 1

    var body: some View {
        VStack(alignment: .leading) {
//            ScrollView(.horizontal, showsIndicators: false) {
//                LazyHStack(alignment: .center) {
//                    ForEach(1 ... 5, id: \.self) { _ in
//                        Group {
//                            Button {} label: {
//                                Text("GET").foregroundColor(getMethodColor(.get)).bold()
//                                Text("New Request")
//                            }.buttonStyle(.bordered)
//                        }
//                    }
//                }
//            }.scaledToFit()
//            Divider()
            if request.data != nil {
                Text(request.name)
                HStack {
                    Picker("", selection: makeMethodBinding()) {
                        ForEach(HTTPMethod.allCases) { method in
                            Text(method.rawValue.uppercased())
                        }
                    }
                    .labelsHidden()
                    .fixedSize()
                    TextField("Enter URL", text: makeUrlBinding())
                        .textFieldStyle(.roundedBorder)
                }

                Picker("Pane", selection: $selectedPane) {
                    ForEach(PanePanel.allCases) { pane in
                        Text(pane.rawValue.capitalized)
                    }
                }
                .labelsHidden()
                .pickerStyle(.segmented)
                .onChange(of: selectedPane) { oldValue, newValue in
                    print("Panel changed from \(oldValue) to \(newValue)!")
                }

                // pane
                switch selectedPane {
                case .docs:
                    VStack(alignment: .leading) {
                        if let description = request.description, !description.isEmpty {
                            Text(description).padding(.vertical, 4)
                        }
                    }
                case .params:
                    VStack(alignment: .leading) {
                        Text("Query Params").padding(.vertical, 4)
                        HStack {
                            Text("Key")
                            Spacer()
                            Text("Value")
                            Spacer()
                        }
                        List($params) { $param in
                            HStack(spacing: 2) {
                                TextField("", text: $param.key)
                                Spacer()
                                TextField("", text: $param.value)
                            }
                        }
                    }
//                    Table(params) {
//                        TableColumn("Key", value: \.key)
//                        TableColumn("Value", value: \.value)
//                    }
//                    Table(params) {
                ////                        TableColumn("Key", value: \.key)
                ////                        TableColumn("Value", value: \.value)
//                    }
//                      // TODO: table
                case .auth:
                    VStack(alignment: .leading) {
                        HStack {
                            Picker("", selection: $selectedAuthType) {
                                ForEach(AuthType.allCases, id: \.self) {
                                    Text($0.rawValue).tag($0)
                                }
                            }
                            .labelsHidden()
                            .fixedSize()
                            .pickerStyle(.segmented)
                        }
                        switch selectedAuthType {
                        case .none:
                            EmptyView()

                        case .basic:
                            HStack {
                                Text("Username").frame(maxWidth: 85, alignment: .leading)
                                TextField(
                                    "Username",
                                    text: $username
                                )
                            }
                            HStack {
                                Text("Password").frame(maxWidth: 85, alignment: .leading)
                                TextField(
                                    "Username",
                                    text: $password
                                )
                            }

                        case .oauth:
                            HStack {
                                Text("Token").frame(maxWidth: 85, alignment: .leading)
                                TextField(
                                    "Token",
                                    text: $oauthToken
                                )
                            }
                            HStack {
                                Text("Header Prefix").frame(maxWidth: 85, alignment: .leading)
                                TextField(
                                    "e.g. Bearer",
                                    text: $oauthPrefix
                                )
                            }
                        }
                    }
                case .headers:
                    VStack(alignment: .leading) {
                        Text("Headers").padding(.vertical, 4)
                        HStack {
                            Text("Key")
                            Spacer()
                            Text("Value")
                            Spacer()
                        }
                        List($headers) { header in
                            HStack(spacing: 2) {
                                TextField("", text: header.key)
                                Spacer()
                                TextField("", text: header.value)
                            }
                        }
                    }
                // TODO: table
                case .body:
                    VStack(alignment: .leading) {
                        HStack {
                            Picker("", selection: $selectedBodyType) {
                                ForEach(BodyType.allCases, id: \.self) {
                                    Text($0.rawValue).tag($0)
                                }
                            }
                            .labelsHidden()
                            .fixedSize()
                            .pickerStyle(.segmented)
                        }
                        switch selectedBodyType {
                        case .formData:
                            Text("Text for form data")
                        case .raw:
                            TextEditor(text: $bodyRaw)
                                .font(.system(size: 13, design: .monospaced))
                                .scrollContentBackground(.hidden)
                                .background(Color(white: 0.1))
                                .foregroundColor(Color(white: 0.9))
                                .padding(.vertical, 8)
                        }
//
                    }
                }

//                TODO: reponse here ?

                if response != nil {
                    VStack {
                        LineNumberCodeView(content: response?.data ?? "")
                            .padding(.vertical, 4)
                        Spacer()
                    }

//                    ScrollView {
//
//
                    ////                        Text(response?.data ?? "")
                    ////                            .font(.system(.body, design: .monospaced))
                    ////                            .textSelection(.enabled)
                    ////
                    ////                            .frame(maxWidth: .infinity, alignment: .leading)
//                    }
                }
//                TextEditor(text: $longText)
//                    .padding()
//                    .font(.body)
//                    .foregroundColor(.primary)
//                    .allowsHitTesting(false)
//                    .focusable(false)

                Spacer()

//                HStack {
//                    Picker("", selection: $selectedPanel) {
//                        ForEach(RequestDetailPanel.allCases, id: \.self) {
//                            Text($0.rawValue.capitalized).tag($0)
//                        }
//                    }
//                    .labelsHidden()
//                    .fixedSize()
//                    .pickerStyle(.segmented)
//                }
//                .frame(maxWidth: .infinity)
            } else {
                Text("Overview").font(.title).bold()
                HStack(alignment: .top) {
                    Text(request.description ?? "")
                    Spacer()
                }
                Spacer()
            }
        }
        .toolbar {
            ToolbarItem {
                Button(action: {
                    Task {
                        if let requestData = request.data {
                            response = await sendHttpRequest(requestData)
                        }
                    }
                }) {
                    Label("Send", systemImage: "play.fill")
                }
                .disabled(request.children != nil || request.data == nil)
            }
        }
        .padding()
    }

    func makeMethodBinding() -> Binding<HTTPMethod> {
        return Binding(
            get: { request.data?.method ?? .get },
            set: { newValue in
                if request.data != nil {
                    request.data!.method = newValue
                }
            }
        )
    }

    func makeUrlBinding() -> Binding<String> {
        return Binding(
            get: { request.data?.url ?? "" },
            set: { newValue in
                if request.data != nil {
                    request.data!.url = newValue
                }
            }
        )
    }
}

#Preview {
    @Previewable @State var request = RequestItem(
        id: UUID(),
        name: "Test name",
        description: "Test Description",
        data: RequestData(method: .delete, url: "https://httpbin.org/get")
    )
    RequestDetailView(request: $request)
}
