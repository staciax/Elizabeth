//
//  ElizabethApp.swift
//  Elizabeth
//
//  Created by STACiA on 28/12/2568 BE.
//

import SwiftUI

@main
struct ElizabethApp: App {
    @State private var appState = AppState()
    @State private var appState2 = AppState2()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
                .environment(appState2)
        }
    }
}
