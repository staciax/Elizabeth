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

struct RequestDetailView: View {
    @Binding var request: RequestItem

    // state
    @State private var selectedPane: PanePanel = .docs

    var body: some View {
        VStack(alignment: .leading) {
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
                VStack {
                    Picker("Pane", selection: $selectedPane) {
                        ForEach(PanePanel.allCases) { pane in
                            Text(pane.rawValue.capitalized)
                        }
                    }
                    .labelsHidden()
                    .onChange(of: selectedPane) { oldValue, newValue in
                        print("Panel changed from \(oldValue) to \(newValue)!")
                    }.pickerStyle(.segmented)
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
        data: RequestData(method: .delete, url: "localhost/v1/test")
    )
    RequestDetailView(request: $request)
}
