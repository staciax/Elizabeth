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

struct RequestItem: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var description: String?
    var data: RequestData?
    var children: [RequestItem]?
}

struct CollectionView: View {
    @Bindable var appState: AppState

    let data: [RequestItem] = [
        RequestItem(
            name: "YUNA REST API",
            description: "test",
            children: [
                RequestItem(
                    name: "Users",
                    description: "Users",
                    children: [
                        RequestItem(
                            name: "Get users",
                            data: RequestData(method: .get, url: "localhost/v1/users")

                        ),
                        RequestItem(
                            name: "Get user by id",
                            data: RequestData(method: .get, url: "localhost/v1/users")

                        ),
                        RequestItem(
                            name: "Create user",
                            data: RequestData(method: .post, url: "localhost/v1/users")

                        ),
                        RequestItem(
                            name: "Update user",
                            data: RequestData(method: .patch, url: "localhost/v1/users")

                        ),
                        RequestItem(
                            name: "Delete user",
                            data: RequestData(method: .delete, url: "localhost/v1/users")
                        )
                    ]
                ),
                RequestItem(
                    name: "Authentication",
                    description: "Users",
                    children: [
                        RequestItem(
                            name: "Sign-in",
                            data: RequestData(method: .post, url: "localhost/v1/auth/sign-in")

                        ),
                        RequestItem(
                            name: "Sign-up",
                            data: RequestData(method: .post, url: "localhost/v1/auth/sign-up")
                        )
                    ]
                )
            ]
        ),
        RequestItem(
            name: "test",
            data: RequestData(method: .get, url: "localhost")
        )
    ]

    @State var selectionRequest: RequestItem?

    var body: some View {
        VStack {
            List(selection: $selectionRequest) {
                OutlineGroup(data, children: \.children) { item in
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
}

#Preview {
    let appState = AppState()
    CollectionView(appState: appState)
}
