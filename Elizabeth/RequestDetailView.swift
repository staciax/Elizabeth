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
