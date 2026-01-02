//
//  Home.swift
//  Elizabeth
//
//  Created by STACiA on 29/12/2568 BE.
//

// import Alamofire
import Foundation
import SwiftUI

enum HTTPMethod: String, CaseIterable, Identifiable {
    case get, post, put, patch, delete, head, options
    var id: Self { self }
}

enum Flavor: String, CaseIterable, Identifiable {
    case chocolate, vanilla, strawberry
    var id: Self { self }
}

enum Topping: String, CaseIterable, Identifiable {
    case nuts, cookies, blueberries
    var id: Self { self }
}

extension Flavor {
    var suggestedTopping: Topping {
        switch self {
        case .chocolate: return .nuts
        case .vanilla: return .cookies
        case .strawberry: return .blueberries
        }
    }
}

// enum PanePanel: String, CaseIterable, Identifiable {
//    case params, auth, headers, body
//    var id: Self { self }
// }

struct Person: Identifiable {
    let givenName: String
    let familyName: String
    let emailAddress: String
    let id = UUID()

    var fullName: String { givenName + " " + familyName }
}

struct Param: Identifiable {
    let id = UUID()
    let key: String
    let value: String
}

struct Home: View {
    @State private var name: String = ""
    @State private var url: String = ""
    @State private var selectedHTTPMethod: HTTPMethod = .get

    @State private var selectedPane: PanePanel = .params

    @State private var headers: [String: String] = [:]

    @State private var isSaved = true

//    @State private var params: [String: String] = [:]

    // test
    @State private var selectedFlavor: Flavor = .chocolate
    @State private var suggestedTopping: Topping = .nuts
    @State private var selectedTopping: Topping = .nuts

    @State private var people = [
        Person(givenName: "Juan", familyName: "Chavez", emailAddress: "juanchavez@icloud.com"),
        Person(givenName: "Mei", familyName: "Chen", emailAddress: "meichen@icloud.com"),
        Person(givenName: "Tom", familyName: "Clark", emailAddress: "tomclark@icloud.com"),
        Person(givenName: "Gita", familyName: "Kumar", emailAddress: "gitakumar@icloud.com"),
    ]

    @State private var params = [
        Param(key: "test key", value: "test value"),
        Param(key: "test key 2", value: "test value"),
        Param(key: "test key 3", value: "test value"),
        Param(key: "test key 3", value: "test value"),
        Param(key: "test key 3", value: "test value"),
        Param(key: "test key 3", value: "test value"),
        Param(key: "test key 3", value: "test value"),
        Param(key: "test key 3", value: "test value"),
        Param(key: "test key 3", value: "test value"),
    ]
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Collection")
//                Label("Favorite Books", systemImage: "books.vertical")
//                    .labelStyle(.titleAndIcon)
//                    .font(.largeTitle)
                TextField("Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button {
                    print("test")
//                    Task {
                    ////                        await sendHttpRequest()
//                    }
                } label: {
                    Label("Save", systemImage: "square.and.arrow.down")
                }.disabled(isSaved)
//                Button("Save", action: sendHttpRequest).padding(.horizontal, 4)
            }

            HStack {
                Picker("", selection: $selectedHTTPMethod) {
                    ForEach(HTTPMethod.allCases) { method in
                        Text(method.rawValue.uppercased())
                    }
                }
                .labelsHidden()
                .scaledToFit()
                .onChange(of: selectedHTTPMethod) { oldValue, newValue in
                    print("HTTP changed from \(oldValue) to \(newValue)!")
                }

                TextField("Enter URL", text: $url)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding()
//                Button("Send", action: sendHttpRequest).padding(.horizontal, 4)
            }.frame(maxWidth: .infinity)

            VStack {
                Picker("Pane", selection: $selectedPane) {
                    ForEach(PanePanel.allCases) { pane in
                        Text(pane.rawValue.capitalized)
                    }
                }
                .labelsHidden()
                .onChange(of: selectedPane) { oldValue, newValue in
                    print("Panel changed from \(oldValue) to \(newValue)!")
                }
            }.frame(maxWidth: .infinity).padding(.vertical, 2)
                .pickerStyle(.segmented)

            // pane panel
            VStack(alignment: .leading) {
                VStack {
                    Text("Query Params")
                }.padding(.vertical, 2)

                Spacer()

                VStack {
                    Table(params) {
                        TableColumn("Key", value: \.key)
                        TableColumn("Value", value: \.value)
                    }
                }

                Spacer()
            }

            // response panel
            VStack {
                HStack {
                    Text("Response")
                }
                HStack {
                    Text("2")
                }
            }

        }.padding()
    }
}

#Preview {
    Home()
}
