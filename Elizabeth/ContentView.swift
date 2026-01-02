//
//  ContentView.swift
//  Elizabeth
//
//  Created by STACiA on 28/12/2568 BE.
//

import Combine
import SwiftUI

// class AppContext: ObservableObject {
//    @Published var environment: String = "Globals"
// }

// TODO: List nested for collection request
// TODO: Split file for someview

// MARK: Collection

struct CollectionInfo: Identifiable {
    let id = UUID()
    @State var name: String

    var requests: [RequestInfo]
    var httpRequets: [HTTPRequest]
//    var items: [HTTPRequestItem]
}

struct RequestDetails: View {
    let requestId: UUID
    var body: some View {
        Text("Detail for Request \(requestId)")
            .navigationTitle("request id: \(requestId)")
    }
}

// MARK: Request

struct RequestInfo: Identifiable {
    let id = UUID()

    @State var method: HTTPMethod
    @State var url: String
    @State var name: String = "New Request"
}

struct HTTPRequest: Identifiable {
    let id = UUID()
    var method: HTTPMethod
    var url: String
    var name: String
    let headers: [String: String]
    let bodyContent: String?
}

struct HTTPRequestItem {
    let id = UUID()
    var name = "New Request"
    var description: String?

    var data: HTTPRequest?
    var children: [HTTPRequestItem]?
}

func getMethodColor(_ httpMethod: HTTPMethod) -> Color {
    switch httpMethod {
    case .get:
        return Color.green
    case .post:
        return Color.yellow
    case .put:
        return Color.blue
    case .patch:
        return Color.purple
    case .delete:
        return Color.orange
    case .head:
        return Color.green
    case .options:
        return Color.red
    }
}

struct MenuItem: Identifiable {
    let id = UUID() // Use a unique identifier
    let name: String
    var subMenuItems: [MenuItem]? // Optional array of children
}

struct ContentView: View {
    @State private var selection: Int? = 1
    @State private var requestSelection: UUID?
    @State private var searchText = ""

    // test environments
    // TODO: use app context in stead of state
    @State private var environments: [String] = ["Globals", "Local", "Production"]
    @State private var selectedEnvironment: String = "Globals"

    // test new env

    // test collection
    @State private var selectedCollection: UUID?
    @State private var showingCollectionAlert = false
    @State private var collectionNameInput = ""
    @State private var visibility: NavigationSplitViewVisibility = .automatic

    // for test
    let items = ["Apple", "Banana", "Cherry", "Date", "Elderberry", "Fig", "Grape"]
    var filteredItems: [String] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }

    @State private var requests: [RequestInfo] = [
        RequestInfo(method: .get, url: "https://test.com", name: "Get User"),
        RequestInfo(method: .post, url: "https://test.com", name: "Create Users"),
        RequestInfo(method: .put, url: "https://test.com", name: "Update User"),
        RequestInfo(method: .patch, url: "https://test.com", name: "Update User"),
        RequestInfo(method: .delete, url: "https://test.com", name: "Delete User"),
        RequestInfo(method: .head, url: "https://test.com", name: "Ping"),
        RequestInfo(method: .options, url: "https://test.com", name: "Options Users")
//        RequestInfo(method: .get, url: "https://test.com", name: "Get User"),
//        RequestInfo(method: .post, url: "https://test.com", name: "Create Users"),
//        RequestInfo(method: .put, url: "https://test.com", name: "Update User"),
//        RequestInfo(method: .patch, url: "https://test.com", name: "Update User"),
//        RequestInfo(method: .delete, url: "https://test.com", name: "Delete User"),
//        RequestInfo(method: .head, url: "https://test.com", name: "Ping"),
//        RequestInfo(method: .options, url: "https://test.com", name: "Options Users"),
    ]

//    lazy var collection: CollectionInfo = .init(requests: $requests)
//    lazy var collections: [CollectionInfo] = [collection]

    let menuItems: [MenuItem] = [
        MenuItem(name: "Computers", subMenuItems: [
            MenuItem(name: "Desktops"),
            MenuItem(name: "Laptops")
        ]),
        MenuItem(name: "Accessories", subMenuItems: [
            MenuItem(name: "Keyboards"),
            MenuItem(name: "Mice")
        ])
    ]

//    lazy var collection: [CollectionInfo]

    var searchResults: [String] {
        if searchText.isEmpty {
            return items
        } else {
            // Use loc alizedStandardContains for case-insensitive and accent-insensitive searches
            return items.filter { $0.localizedStandardContains(searchText) }
        }
    }

    var body: some View {
//        var collection =

        NavigationSplitView(columnVisibility: $visibility) {
            List(selection: $selection) {
                NavigationLink(destination: CollectionList()) {
                    Label("Collections", systemImage: "rectangle.3.group")
                }.tag(100)
                NavigationLink(destination: EnvironmentList(environments: $environments, environment: $selectedEnvironment)) {
                    Label("Environments", systemImage: "square")
                }.tag(200)
            }
            .listStyle(.sidebar)
            .navigationTitle("Menu")
//            List(filteredItems, id: \.self, selection: $selection) { item in
            ////                NavigationLink(item, value: item)
//                NavigationLink(destination: DetailView(item: 1)) {
            ////                    Label(item, systemImage: "1.circle")
//                    VStack(alignment: .leading, spacing: 4) {
//                        Text(item.capitalized)
//                        Text(item.capitalized)
//                    }
//                }.tag(item)
//            }
//            .navigationTitle("Fruits")
//            .searchable(text: $searchText, placement: .automatic, prompt: "Search fruits")

        } content: {
            HStack {
                Button(action: {
                    showingCollectionAlert.toggle()
                }) {
                    Label("Add", systemImage: "plus")
                        .labelStyle(.iconOnly).disabled(true)
                }
//
                .alert("New Collection", isPresented: $showingCollectionAlert) {
                    TextField("Collection Name", text: $collectionNameInput)
                    Button("OK") {
                        print("ok", collectionNameInput)
                        collectionNameInput = ""
                    }.disabled(collectionNameInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    Button("Cancel", role: .cancel) {
                        print("cancel")
                    }
                }
                message: {
                    Text("Create new colection.")
                }
                Text("New Collection")
            }.padding(.top, 10)
//            .buttonStyle(PlainButtonStyle())
//            NavigationStack {
//            List {}
//            ForEach(collections, id: \.id) { _ in
//            //                VStack(alignment: .leading) {
//            //                    HStack {
//            //                        Button(request.method.rawValue.uppercased()) {}
//            //                            .buttonStyle(.borderedProminent)
//            //                            .tint(getMethodColor(request.method))
//            //                        Text(request.name)
//            //                    }
//            //                }.tag(request.id)
//            }
//            Menu(/*@START_MENU_TOKEN@*/"Menu"/*@END_MENU_TOKEN@*/) {
//                /*@START_MENU_TOKEN@*/Text("Menu Item 1")/*@END_MENU_TOKEN@*/
//                /*@START_MENU_TOKEN@*/Text("Menu Item 2")/*@END_MENU_TOKEN@*/
//                /*@START_MENU_TOKEN@*/Text("Menu Item 3")/*@END_MENU_TOKEN@*/
//            }
//            List {
//                ForEach(menuItems) { _ in
            ////                    Button(action: {
            ////                        showingCollectionAlert.toggle()
            ////                    }) {
            ////                        Label("Collection 1", systemImage: "folder")
            ////                    }
            ////                    .buttonStyle(PlainButtonStyle())
            ////                    .padding(.vertical, 4)
//
            ////                    Section(header: {
            ////                        Text(item.name)
            ////                    }) {
            ////                        ForEach(["test1", "test2"], id: \.self) { sub in
            ////                            Text(sub)
//                    ////                            Text(sub)
//                    ////                            PersonRowView(person: person)
            ////                        }
            ////                    }
//                }
//            }
//            List(menuItems, children: \.subMenuItems) { item in
//                // Customize the view for each item
//                Text(item.name)
//            }
//            List {
//                ForEach(menuItems) { item in
//                    OutlineGroup(item, children: \.subMenuItems) { childItem in
//                        // Customize the view for each child
//                        Text(childItem.name)
//                    }
//                }
//            }
            List(selection: $requestSelection) {
                ForEach(Array(requests.enumerated()), id: \.offset) { _, request in
                    VStack(alignment: .leading) {
                        HStack {
                            Button(request.method.rawValue.uppercased()) {}
                                .buttonStyle(.borderedProminent)
                                .tint(getMethodColor(request.method))
                            Text(request.name)
                        }
                    }.tag(request.id)
                }
//                Text("Collection 2")
//                ForEach(Array(requests.enumerated()), id: \.offset) { _, request in
//                    VStack(alignment: .leading) {
//                        HStack {
//                            Button(request.method.rawValue.uppercased()) {}
//                                .buttonStyle(.borderedProminent)
//                                .tint(getMethodColor(request.method))
//                            Text(request.name)
//                        }
//                    }.tag(request.id)
//                }
            } // .border(Color.blue)
//            NavigationStack { // Required for the searchable modifier to work
//                List {
//                    ForEach(searchResults, id: \.self) { item in
//                        Text(item)
//                    }
//                }
//                .navigationTitle("Fruits")
//                .searchable(text: $searchText, prompt: "Search fruits") // Add the search box
//            }
        } detail: {
            // Detail View (Second Column)
//
            if let requestSelection {
                RequestDetails(requestId: requestSelection)
            } else {
                EmptyView()
            }
        }
        .toolbar {
            ToolbarItem {
                Picker(selectedEnvironment, selection: $selectedEnvironment) {
                    ForEach(environments, id: \.self) { env in
                        Text(env)
                    }
                }
                .labelsHidden()
                .scaledToFit()
            }
//            ToolbarItem {
//                Button(action: sendHttpRequest) {
//                    Label("Save", systemImage: "play.fill")
//                }.disabled(true)
//            }
        }.navigationSplitViewStyle(.prominentDetail)
//        .searchable(text: $searchText, placement: .automatic)
    }
}

// MARK: Collection

struct CollectionList: View {
    var body: some View {
        Text("Test")
    }
}

// MARK: something

struct DetailView: View {
    var item: Int

    var body: some View {
        Text("Detail for Item \(item)")
            .navigationTitle("Item \(item)")
    }
}

// MARK: Environment

// struct EnvironmentInfo {
//    @State var name: String = "New Environment"
// }

struct EnvironmentView {
    var body: some View {
        Text("")
    }
}

struct EnvironmentList: View {
    @Binding var environments: [String]
    @Binding var environment: String

    @State var selectedEnvironment: String?
    @State private var isHovered = false
    @State private var hoveredEnvironment: String?

    @State var envNameInput: String = ""
    @State var showingAlert: Bool = false

    var body: some View {
        NavigationStack {
//        Text(environment).navigationTitle("env: \(environment)")
            HStack {
//
                Button(action: {
                    showingAlert.toggle()
                }) {
                    Label("add-environment", systemImage: "plus")
                        .labelStyle(.iconOnly)
                }
                .alert("New Environment", isPresented: $showingAlert) {
                    TextField("Environment Name", text: $envNameInput)
                    Button("OK") {
                        environments.append(envNameInput)
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
//            .buttonStyle(PlainButtonStyle())
            VStack {
                List(selection: $selectedEnvironment) {
                    ForEach(environments, id: \.self) { env in
                        HStack {
                            Text(env)
                            Spacer()
                            if env == environment {
                                Image(systemName: "checkmark.circle.fill")
                            } else if hoveredEnvironment == env {
                                Image(systemName: "checkmark.circle")
                            }
                        }
                        .contentShape(.rect)
                        .tag(env)
                        .onHover { hover in
                            if hover {
                                self.hoveredEnvironment = env
                            } else {
                                self.hoveredEnvironment = nil
                            }
                        }
//                        .border(Color.red)
//                        .onTapGesture(count: 2) {}
                    }
//
//
                }
            }
//        Text("Detail Test")
//            .navigationTitle("Item Test")
        }.navigationTitle("env: \(environment)")
    }
}

#Preview {
    ContentView()
}
