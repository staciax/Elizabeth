//
//  AppState.swift
//  Elizabeth
//
//  Created by STACiA on 2/1/2569 BE.
//

import SwiftUI

@Observable class AppState {
    // environments
    var selectedEnvironment: String = "No Environment"
    var environments: [String] = ["No Environment"]

//    var selectionEnvironment: EnvironmentInfo?
    var selectedCollection: CollectionInfo?
    var selectedHttpRequest: HTTPRequest?

    var collections: [CollectionInfo] = []

    init() {
        // collections
        for index in 1 ... 2 {
            collections.append(CollectionInfo(
                name: String(index),
                requests: [
                ],
                httpRequets: [
                ]
            ))
        }

        // test
        environments.append(contentsOf: ["Local", "Production"])
    }
}
