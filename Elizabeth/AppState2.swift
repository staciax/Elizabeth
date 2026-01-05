//
//  AppState2.swift
//  Elizabeth
//
//  Created by STACiA on 5/1/2569 BE.
//

import Observation
import SwiftUI

@Observable class AppState2 {
    // collection types: Array - Array Type Shorthand Syntax
    // collection types: Array - Creating an Empty Array
    var collections: [CollectionItem] = []

    init() {
        collections.append(contentsOf: [
            .collection(
                id: UUID(),
                name: "User APIs",
                description: "User management endpoints",
                children: [
                    .request(
                        id: UUID(),
                        name: "Get User",
                        description: "Fetch user by ID",
                        data: (
                            UUID(), .get, "https://httpbin.org/get",
                            buildHeaders(("Accept", "application/json")),
                            nil, nil,
                            .oauth(prefix: "Bearer", token: "test")
                        )
                    ),
                    .request(
                        id: UUID(),
                        name: "Create User",
                        description: "Create new user",
                        data: (
                            UUID(), .post, "https://httpbin.org/post",
                            buildHeaders(("Content-Type", "application/json")),
                            nil, nil,
                            .basic(username: "test", password: "test")
                        )
                    ),
                    .request(
                        id: UUID(),
                        name: "Delete User",
                        description: "Remove user account",
                        data: (
                            UUID(), .delete, "https://httpbin.org/delete",
                            nil, nil, nil,
                            .oauth(prefix: "Bearer", token: "test")
                        )
                    )
                ]
            ),
            .collection(
                id: UUID(),
                name: "Product APIs",
                description: "Product catalog",
                children: [
                    .request(
                        id: UUID(),
                        name: "List Products",
                        description: "Get all products",
                        data: (
                            UUID(), .get, "https://httpbin.org/get",
                            nil, nil,
                            buildParams(("limit", "10"), ("page", "1")),
                            .apiKey(key: "test", headerName: "X-API-Key")
                        )
                    ),
                    .collection(
                        id: UUID(),
                        name: "Product CRUD",
                        description: "Operations",
                        children: [
                            .request(
                                id: UUID(),
                                name: "Update Product",
                                description: "Full update",
                                data: (UUID(), .put, "https://httpbin.org/put", nil, nil, nil, .none)
                            )
                        ]
                    )
                ]
            )
        ]
        )
    }
}
