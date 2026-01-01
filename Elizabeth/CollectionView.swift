//
//  CollectionView.swift
//  Elizabeth
//
//  Created by STACiA on 1/1/2569 BE.
//

import SwiftUI

struct RequestData: Hashable {
    var method: HTTPMethod
    var url: String
    var headers: [String: String]?
    var bodyContent: String?
}

struct RequestItem: Identifiable, Hashable, Equatable {
    let id: UUID
    var name: String
    var description: String?
    var data: RequestData?
    var children: [RequestItem]?
}

let sampleData: [RequestItem] = [
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
                        data: RequestData(method: .get, url: "localhost/v1/users")

                    ),
                    RequestItem(
                        id: UUID(),
                        name: "Get user by id",
                        data: RequestData(method: .get, url: "localhost/v1/users")

                    ),
                    RequestItem(
                        id: UUID(),
                        name: "Create user",
                        data: RequestData(method: .post, url: "localhost/v1/users")

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
        name: "test",
        data: RequestData(method: .get, url: "localhost")
    )
]

struct CollectionView: View {
    @Bindable var appState: AppState
    @Binding var selectionRequest: RequestItem?

    @State var items: [RequestItem] = sampleData

    var body: some View {
        VStack {
            List(items, children: \.children, selection: $selectionRequest) { item in
                HStack {
                    if item.children != nil {
                        Image(systemName: "folder").foregroundColor(.gray)
                    }
                    if let data = item.data {
                        Text(data.method.rawValue.uppercased())
                            .bold()
                            .foregroundColor(getMethodColor(data.method))
                    }
                    Text(item.name)
                        .font(item.children == nil ? .body : .headline)
                }
                .tag(item)
                .padding(.vertical, 4)
            }
        }
    }
}

#Preview {
    @Previewable @State var selectionRequest: RequestItem?
    @Previewable @State var appState = AppState()
    CollectionView(appState: appState, selectionRequest: $selectionRequest)
}
