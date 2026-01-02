//
//  EnvironmentView.swift
//  Elizabeth
//
//  Created by STACiA on 31/12/2568 BE.
//

import SwiftUI

struct EnvironmentView2: View {
    @Bindable var appState: AppState

    // state
    @State private var isHovered = false
    @State private var hoveredEnvironment: String?

    // input
    @State var envNameInput: String = ""
    @State var showingAlert: Bool = false

    var body: some View {
        NavigationStack {
            HStack {
                Button(action: {
                    showingAlert.toggle()
                }) {
                    Label("add-environment", systemImage: "plus")
                        .labelStyle(.iconOnly)
                }
                .alert("New Environment", isPresented: $showingAlert) {
                    TextField("Environment Name", text: $envNameInput)
                    Button("OK") {
                        appState.environments.append(envNameInput)
                        // reset input
                        envNameInput = ""
                    }.disabled(envNameInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    Button("Cancel", role: .cancel) {
                        // reset input
                        envNameInput = ""
                    }
                }
                message: {
                    Text("Create new colection.")
                }
                Text("New Environment")
            }
            .padding(.top, 10)

            VStack {
                List {
                    ForEach(appState.environments, id: \.self) { env in
                        NavigationLink(value: env) {
                            HStack {
                                Text(env)
                                Spacer()
                                if env == appState.selectedEnvironment {
                                    Image(systemName: "checkmark.circle.fill")
                                } else if hoveredEnvironment == env {
                                    Image(systemName: "checkmark.circle")
                                }
                            }
                            .contentShape(.rect)
                            .onHover { hover in
                                if hover {
                                    self.hoveredEnvironment = env
                                } else {
                                    self.hoveredEnvironment = nil
                                }
                            }.tag(env)
                        }
                    }
                }
            }
        }
    }
}

// ​ TODO: use dictionary instead of struct
private struct EnvironmentVariable: Identifiable {
    let id: UUID = .init()
    var name: String
    var value: String
//    var isEnabled: Bool
}

struct EnvironmentDetailView2: View {
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
    let appState = AppState()
    EnvironmentView2(appState: appState)
    EnvironmentDetailView2()
}
