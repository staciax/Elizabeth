//
//  RequestDetailView.swift
//  Elizabeth
//
//  Created by STACiA on 2/1/2569 BE.
//

import Alamofire
import SwiftUI

typealias HTTPRequestResult = (
    data: String?,
    statusCode: Int?,
    url: URL?,
    duration: TimeInterval,
    requestHeaders: [String: String],
    responseHeaders: [String: String],
    cookies: [String],
    errorDescription: String?
)

// TODO: attempt request for 3 time?
func sendHttpRequest(
    _ request: RequestData,
    maxAttempts: Int = 3
) async -> HTTPRequestResult {
    precondition(maxAttempts >= 1, "maxAttempts must be at least 1")

    func extractCookies(from headers: [String: String]) -> [String] {
        return headers
            .filter { $0.key.lowercased() == "set-cookie" }
            .map { $0.value }
    }

    let headers: HTTPHeaders = [
        "Accept": "application/json",
    ]

    var finalResponse: DataResponse<String, AFError>?
    var duration: TimeInterval = 0

    for attempt in 1 ... maxAttempts {
        let task = AF.request(
            request.url,
            method: .init(rawValue: request.method.rawValue.uppercased()),
            headers: headers
        )
        .serializingString() // .serializingData()

        let startTime = CFAbsoluteTimeGetCurrent()
        let response = await task.response
        let endTime = CFAbsoluteTimeGetCurrent()

        duration = endTime - startTime
        finalResponse = response

        if let error = response.error {
            print("Attempt \(attempt) failed: \(error.localizedDescription)")
        } else {
            break
        }
    }

    let response = finalResponse! // force unwraping

    debugPrint(response)

    let data = response.value
    let statusCode = response.response?.statusCode
    let finalURL = response.response?.url

    // response headers
    var responseHeaders: [String: String] = [:]
    if let all = response.response?.allHeaderFields {
        for (key, value) in all {
            responseHeaders[String(describing: key)] = String(describing: value)
        }
    }

    // request headers
    let requestHeaders = response.request?.allHTTPHeaderFields ?? [:]

    // cookies
    let cookies: [String] = extractCookies(from: responseHeaders)

    // error
    let errorDescription = response.error?.localizedDescription

    return (
        statusCode: statusCode,
        url: finalURL,
        duration: duration,
        requestHeaders: requestHeaders,
        responseHeaders: responseHeaders,
        data: data,
        cookies: cookies,
        errorDescription: errorDescription
    )
}

enum PanePanel: String, CaseIterable, Identifiable {
    case docs, params, auth, headers, body
    var id: Self { self }
}

struct TextEditingView: View {
    let content: String

    var body: some View {
        TextEditor(text: .constant(content))
            .font(.system(size: 13, design: .monospaced))
            .scrollContentBackground(.hidden)
            .background(Color(white: 0.11))
            .foregroundColor(Color(white: 0.9))
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

//enum BodyType: String, CaseIterable, Identifiable {
//    case formData = "FormData"
//    case raw = "Raw"
//    var id: Self { self }
//}

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

//    @State private var params = [
//        Param(key: "test key", value: "test value"),
//        Param(key: "test key 2", value: "test value"),
//        Param(key: "test key 3", value: "test value"),
//        Param(key: "test key 4", value: "test value"),
//        Param(key: "test key 5", value: "test value"),
//    ]

// typealias RequestDataTuple = (
//    id: UUID,
//    method: HTTPMethod,
//    url: String,
//    headers: [String: String]?,
//    bodyContent: String?,
//    params: [String: String]?,
//    requestHeaders: [String: String]?,
//    basicAuth: (username: String, password: String)?,
//    oauth: (token: String, prefix: String)?
// )

struct RequestDetailView: View {
    @Binding var request: RequestItem

    // http response
    @State var response: HTTPRequestResult?

    // state
    @State private var selectedPane: PanePanel = .docs
    @State private var selectedPanel: RequestDetailPanel = .request
    @State private var selectedAuthType: AuthType = .none
    @State private var selectedBodyType: BodyType = .formData
    @State private var bodyRaw: String = ""

    // params
    @State private var params: [String:String] = ["key": "value"]
    @State private var newParamName: String = ""

    // auth basic
    @State private var username: String = ""
    @State private var password: String = ""

    // auth oauth
    @State private var oauthToken: String = ""
    @State private var oauthPrefix: String = "Bearer"

    // alert dialog
    @State private var showingAlert = false

    // test

    @State private var headers = [
        Header(key: "test key", value: "test value"),
        Header(key: "test key 2", value: "test value"),
        Header(key: "test key 3", value: "test value"),
        Header(key: "test key 4", value: "test value"),
        Header(key: "test key 5", value: "test value"),
    ]

//    @State private var params: [String: String] = [:]

    var body: some View {
        let isFolder = (request.children != nil || request.data == nil)

//        if !username.isEmpty && !password.isEmpty {
//            if let data = request.data {
//                data.basicAuth = (username: username, password: password)
//            }
//        }

        VStack(alignment: .leading) {
            if !isFolder {
                if selectedPanel == .request {
                    Text(request.name)
                    HStack {
                        Picker("", selection: Binding(
                            get: {
                                if let data = request.data {
                                    return data.method
                                }
                                return HTTPMethod.get
                            },
                            set: { newValue in
                                if var data = request.data {
                                    data.method = newValue
                                    request.data = data
                                }
                            }
                        )) {
                            ForEach(HTTPMethod.allCases) { method in
                                Text(method.rawValue.uppercased())
                            }
                        }
                        .labelsHidden()
                        .fixedSize()
                        TextField("Enter URL", text: Binding(
                            get: {
                                if let data = request.data {
                                    return buildUrl(data.url, parameters: params)
                                }
                                return ""
//
                            },
                            set: { newValue in
                                if var data = request.data {
                                    data.url = newValue
                                    request.data = data
                                }
                            }
                        ))
                        .textFieldStyle(.roundedBorder)
                    }

                    Picker("", selection: $selectedPane) {
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
                            List {
                                ForEach(params.keys.sorted(), id: \.self) { key in
                                    HStack(spacing: 2) {
                                        TextField("", text: .constant(key))
                                            .textFieldStyle(.roundedBorder)
                                        Spacer()
                                        TextField("", text: Binding(
                                            get: { params[key]! },
                                            set: { newValue in
                                                params[key] = newValue
                                            }
                                        ))
                                        .textFieldStyle(.roundedBorder)
                                    }
                                }
                                Button {
                                    showingAlert.toggle()
                                } label: {
                                    Label("Add param", systemImage: "plus")
                                }
                                .alert("New Parameter", isPresented: $showingAlert) {
                                    TextField("Parameter name", text: $newParamName)

                                    Button("Add") {
                                        guard !newParamName.isEmpty, params[newParamName] == nil else { return }
                                        params[newParamName] = ""
                                        newParamName = ""
                                    }

                                    Button("Cancel", role: .cancel) {
                                        newParamName = ""
                                    }
                                } message: {
                                    Text("Enter the name for the new parameter")
                                }
                            }
                        }
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
                            case .none:
                                Text("None")
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
                } else {
                    if response != nil {
                        Button(action: {
                            showingAlert.toggle()
                        }) {
                            let statusCode = response?.statusCode ?? 200
                            let statusMessage = statusMessage(for: statusCode).uppercased()
                            let duration = response?.duration ?? 0.0
                            let fmtDuration = formatDuration(duration)
                            // TODO: add content-length

                            Text("\(statusCode) \(statusMessage)").foregroundStyle(statusColor(for: statusCode))
                            Text(" | ")
                            Text("\(fmtDuration)")
                        }
//                        .sheet(isPresented: $showingHttpResponseInfoDialog) {
//                            ScrollView {
//                                VStack(alignment: .leading) {
//                                    if let resposneHeaders = response?.responseHeaders {
//
//                                    }
//                                }
//                                .padding()
//                            }
//                            .frame(minWidth: 700, minHeight: 500)
//                        }

                        TextEditingView(content: response?.data ?? "")
                            .padding(.vertical, 4)
                    }
                }

                Spacer()

                HStack {
                    Picker("", selection: $selectedPanel) {
                        ForEach(RequestDetailPanel.allCases, id: \.self) {
                            Text($0.rawValue.capitalized).tag($0)
                        }
                    }
                    .labelsHidden()
                    .fixedSize()
                    .pickerStyle(.segmented)
                }
                .frame(maxWidth: .infinity)
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
                            selectedPanel = .response
                        }
                    }

                }) {
                    Label("Send", systemImage: "play.fill")
                }
                .disabled(isFolder)
            }
        }
        .padding()
    }
}

#Preview {
    @Previewable @State var request = RequestItem(
        id: UUID(),
        name: "Test name",
        description: "Test Description",
        data: RequestData(method: .delete, url: "https://httpbin.org/delete")
    )
    RequestDetailView(request: $request)
}
