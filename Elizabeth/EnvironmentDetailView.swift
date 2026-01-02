//
//  EnvironmentDetailView.swift
//  Elizabeth
//
//  Created by STACiA on 2/1/2569 BE.
//

import SwiftUI

// ​ TODO: use dictionary instead of struct
private struct EnvironmentVariable: Identifiable {
    let id: UUID = .init()
    var name: String
    var value: String
//    var isEnabled: Bool
}

struct EnvironmentDetailView: View {
    @State var appState = AppState()

    // state
    @State private var variables: [EnvironmentVariable] = Array(1...10).map {
        EnvironmentVariable(name: "Variable \($0)", value: String(Int.random(in: 100...10000)))
    }

    @State private var selections = Set<EnvironmentVariable.ID>()

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(appState.selectedEnvironment)
                .padding(4)
//            TextField(text: $appState.selectedEnvironment, label: {})
//                .textFieldStyle(.plain)
//                .padding(4)
            Table(of: Binding<EnvironmentVariable>.self, selection: $selections, columns: {
//                TableColumn("") { variable in
//                    Toggle("", isOn: variable.isEnabled)
//                        .labelsHidden()
//                }.width(24)
                TableColumn("Variable") { variable in
                    TextField(text: variable.name, label: {})
                        .frame(maxWidth: .infinity)
                        .textFieldStyle(.plain)
                        .padding(.vertical, 4)
                }
                TableColumn("Value") { variable in
                    TextField(text: variable.value, label: {})
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .textFieldStyle(.plain)
                        .padding(.vertical, 4)
                }
            }, rows: {
                ForEach($variables) { variable in
                    TableRow(variable)
                }
            })
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    EnvironmentDetailView()
}
