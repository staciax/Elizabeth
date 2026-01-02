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
                    Group {
                        if let description = request.description, !description.isEmpty {
                            Text(description)
                        }
                    }.padding()
                case .params:
                    Text("params")
//                      // TODO: table
                case .auth:
                    Text("auth")
                case .headers:
                    Text("headers")
                // TODO: table
                case .body:
                    Text("body")
                }

//                TODO: reponse here ?

                ScrollView {
                    Text("test")
                        .font(.system(.body, design: .monospaced))
                        .textSelection(.enabled)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Spacer()
            } else {
                // folder
                Text("Else")
            }
        }.padding()
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
