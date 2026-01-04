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

    var collections: [RequestItem] = []

    init() {
        // mock data
        environments.append(contentsOf: ["Local", "Production"])
        environments2.append((name: "Globals", variables: [:]))
        collections.append(contentsOf: [
            RequestItem(
                id: UUID(),
                name: "YUNA REST API",
                description: "test",
                children: [
                    RequestItem(
                        id: UUID(),
                        name: "Users",
                        description: "Users",
                        children: [
                            RequestItem(
                                id: UUID(),
                                name: "Get users",
                                data: RequestData(method: .get, url: "https://httpbin.org/get")

                            ),
                            RequestItem(
                                id: UUID(),
                                name: "Get user by id",
                                data: RequestData(method: .get, url: "https://httpbin.org/get")

                            ),
                            RequestItem(
                                id: UUID(),
                                name: "Create user",
                                data: RequestData(method: .post, url: "https://httpbin.org/post")

                            ),
                            RequestItem(
                                id: UUID(),
                                name: "Update user",
                                data: RequestData(method: .patch, url: "localhost/v1/users")

                            ),
                            RequestItem(
                                id: UUID(),
                                name: "Delete user",
                                data: RequestData(method: .delete, url: "localhost/v1/users")
                            )
                        ]
                    ),
                    RequestItem(
                        id: UUID(),
                        name: "Authentication",
                        description: "Users",
                        children: [
                            RequestItem(
                                id: UUID(),
                                name: "Sign-in",
                                data: RequestData(method: .post, url: "localhost/v1/auth/sign-in")

                            ),
                            RequestItem(
                                id: UUID(),
                                name: "Sign-up",
                                data: RequestData(method: .post, url: "localhost/v1/auth/sign-up")
                            )
                        ]
                    )
                ]
            ),
            RequestItem(
                id: UUID(),
                name: "Empty Collection"
            ),
            RequestItem(
                id: UUID(),
                name: "Test",
                description: "Just for test",
                data: RequestData(method: .get, url: "https://httpbin.org/get")
            )
        ])
    }
}
