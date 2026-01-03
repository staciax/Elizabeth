//
//  ElizabethApp.swift
//  Elizabeth
//
//  Created by STACiA on 28/12/2568 BE.
//

import SwiftUI

@main
struct ElizabethApp: App {
    @State var appState = AppState()

    init() {
        // init data
        appState.environments2.append((name: "Globals", variables: [:]))
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }.environment(appState)
    }
}
