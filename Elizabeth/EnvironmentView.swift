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
                                let isGlobal = env == "No Environment"
                                if isGlobal {
                                    Text("Globals")
                                    Spacer()
                                } else {
                                    Text(env)
                                    Spacer()
                                    if env == appState.selectedEnvironment {
                                        Image(systemName: "checkmark.circle.fill")
                                    } else if hoveredEnvironment == env {
                                        Image(systemName: "checkmark.circle")
                                    }
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

#Preview {
    @Previewable @State var appState = AppState()
    EnvironmentView2(appState: appState)
}
