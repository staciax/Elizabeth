//
//  SideBarView.swift
//  Elizabeth
//
//  Created by STACiA on 31/12/2568 BE.
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

func sendHttpRequest(_ request: RequestData) async -> HTTPRequestResult {
    let headers: HTTPHeaders = [
        "Accept": "application/json"
    ]

    let startTime = CFAbsoluteTimeGetCurrent()

    let task = AF.request(
        request.url,
        method: .init(rawValue: request.method.rawValue.uppercased()),
        headers: headers
    )
    .serializingString() // .serializingData()

    let endTime = CFAbsoluteTimeGetCurrent()
    let duration = endTime - startTime

    let response = await task.response

    print("Status:", response.response?.statusCode as Any)
    print("Body:", response.value ?? "no body")
    print(type(of: response))
    print(type(of: response.value))

    let httpResponse = response.response

    let data = response.value
    let statusCode = httpResponse?.statusCode
    let finalURL = httpResponse?.url

    // response headers
    var responseHeaders: [String: String] = [:]
    if let all = httpResponse?.allHeaderFields {
        for (k, v) in all {
            responseHeaders[String(describing: k)] = String(describing: v)
        }
    }

    // request headers
    let requestHeaders = response.request?.allHTTPHeaderFields ?? [:]

    // cookie
    let cookies: [String] = responseHeaders
        .filter { $0.key.lowercased() == "set-cookie" }
        .map { $0.value }

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
//            switch selectedSideBar {
//            case .collections:
//                CollectionView(appState: appState, selectionRequest: $selectionRequest)
//            case .environments:
//                EnvironmentView2(appState: appState)
//            }
            ZStack {
                CollectionView(appState: appState, selectionRequest: $selectionRequest)
                    .opacity(selectedSideBar == .collections ? 1 : 0)

                EnvironmentView2(appState: appState)
                    .opacity(selectedSideBar == .environments ? 1 : 0)
            }
        } detail: {
            // TODO: use ZStack for persistant view
            switch selectedSideBar {
            case .collections:
                if let selectedRequest = selectionRequest {
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        LazyHStack(alignment: .center) {
//                            ForEach(1 ... 5, id: \.self) { _ in
//                                Group {
//                                    Button {} label: {
//                                        Text("GET").foregroundColor(getMethodColor(.get)).bold()
//                                        Text("New Request")
//                                    }.buttonStyle(.bordered)
//                                }
//                            }
//                        }
//                    }.scaledToFit()
//                    Divider()
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
            case .environments:
                EnvironmentDetailView2()
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
                Button(action: {
                    Task {
                        if let requestData = selectionRequest?.data {
                            let response = await sendHttpRequest(requestData)
//                            requestData.re
                        }
                    }
                }) {
                    Label("Send", systemImage: "play.fill")
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
