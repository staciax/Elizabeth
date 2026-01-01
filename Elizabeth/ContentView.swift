//
//  ContentView.swift
//  Elizabeth
//
//  Created by STACiA on 28/12/2568 BE.
//

import SwiftUI

// TODO: List nested for collection request

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

struct ContentView: View {
    @State private var selection: Int? = 1
    @State private var requestSelection: UUID?
    @State private var searchText = ""

    // environments
    @State private var environments: [String] = ["Globals", "Local", "Production"]
    @State private var environmentSelection: String = "Globals"

    // for test
    let items = ["Apple", "Banana", "Cherry", "Date", "Elderberry", "Fig", "Grape"]
    var filteredItems: [String] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var requests: [RequestInfo] = [
        RequestInfo(method: .get, url: "https://test.com", name: "Get User"),
        RequestInfo(method: .post, url: "https://test.com", name: "Create Users"),
        RequestInfo(method: .put, url: "https://test.com", name: "Update User"),
        RequestInfo(method: .patch, url: "https://test.com", name: "Update User"),
        RequestInfo(method: .delete, url: "https://test.com", name: "Delete User"),
        RequestInfo(method: .head, url: "https://test.com", name: "Ping"),
        RequestInfo(method: .options, url: "https://test.com", name: "Options Users"),
        RequestInfo(method: .get, url: "https://test.com", name: "Get User"),
        RequestInfo(method: .post, url: "https://test.com", name: "Create Users"),
        RequestInfo(method: .put, url: "https://test.com", name: "Update User"),
        RequestInfo(method: .patch, url: "https://test.com", name: "Update User"),
        RequestInfo(method: .delete, url: "https://test.com", name: "Delete User"),
        RequestInfo(method: .head, url: "https://test.com", name: "Ping"),
        RequestInfo(method: .options, url: "https://test.com", name: "Options Users"),
    ]

    var searchResults: [String] {
        if searchText.isEmpty {
            return items
        } else {
            // Use localizedStandardContains for case-insensitive and accent-insensitive searches
            return items.filter { $0.localizedStandardContains(searchText) }
        }
    }

    @State private var visibility: NavigationSplitViewVisibility = .automatic

    var body: some View {
        NavigationSplitView(columnVisibility: $visibility) {
            List(selection: $selection) {
                NavigationLink(destination: DetailView(item: 1)) {
                    Label("Collections", systemImage: "rectangle.3.group")
                }.tag(100)
//                NavigationLink(destination: DetailView(item: 2)) {
//                    Label("Environments", systemImage: "square")
//                }.tag(200)
                NavigationLink(destination: EnvironmentList(environments: $environments, environment: $environmentSelection)) {
                    Label("Environments", systemImage: "square")
                }.tag(200)
//                NavigationLink(destination: DetailView(item: 2)) {
                ////                    Label("Item 2", systemImage: "2.circle")
//                    VStack(alignment: .leading) {
//                        HStack {
//                            Button("GET") {}.buttonStyle(.borderedProminent).tint(.green)
//                            Text("New Request")
//                        }
                ////                        Text("https://").foregroundStyle(.secondary)
//                    }
//                }.tag(3)
//                NavigationLink(destination: DetailView(item: 2)) {
//                    VStack(alignment: .leading) {
//                        HStack {
//                            Button("POST") {}.buttonStyle(.borderedProminent).tint(.yellow)
//                            Text("New Request")
//                        }
                ////                        Text("https://").foregroundStyle(.secondary)
//                    }
//                }.tag(4)
//                NavigationLink(destination: DetailView(item: 2)) {
//                    VStack(alignment: .leading) {
//                        HStack {
//                            Button("PUT") {}.buttonStyle(.borderedProminent).tint(.blue)
//                            Text("New Request")
//                        }
                ////                        Text("https://").foregroundStyle(.secondary)
//                    }
//                }.tag(5)
//                NavigationLink(destination: DetailView(item: 2)) {
//                    VStack(alignment: .leading) {
//                        HStack {
//                            Button("PATCH") {}.buttonStyle(.borderedProminent).tint(.purple)
//                            Text("New Request")
//                        }
                ////                        Text("https://").foregroundStyle(.secondary)
//                    }
//                }.tag(5)
//                NavigationLink(destination: DetailView(item: 2)) {
//                    VStack(alignment: .leading) {
//                        HStack {
//                            Button("DELETE") {}.buttonStyle(.borderedProminent).tint(.orange)
//                            Text("New Request")
//                        }
                ////                        Text("https://").foregroundStyle(.secondary)
//                    }
//                }.tag(5)
//                NavigationLink(destination: DetailView(item: 2)) {
//                    VStack(alignment: .leading) {
//                        HStack {
//                            Button("HEAD") {}.buttonStyle(.borderedProminent).tint(.green)
//                            Text("New Request")
//                        }
                ////                        Text("https://").foregroundStyle(.secondary)
//                    }
//                }.tag(5)
//                NavigationLink(destination: DetailView(item: 2)) {
//                    VStack(alignment: .leading) {
//                        HStack {
//                            Button("OPTIONS") {}.buttonStyle(.borderedProminent).tint(.pink)
//                            Text("New Request")
//                        }
                ////                        Text("https://").foregroundStyle(.secondary)
//                    }
//                }.tag(7)
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
                Button(action: {}) {
                    Text("New Collection")
                    Label("Add", systemImage: "plus")
                        .labelStyle(.iconOnly).disabled(true)
                }.padding(10)
            }
            .buttonStyle(PlainButtonStyle()) // Crucial for full custom control
//            NavigationStack {
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
//                ForEach(data: requests) { request in
                ////                    VStack(alignment: .leading) {
                ////                        HStack {
                ////                            Button(request.method) {}.buttonStyle(.borderedProminent).tint(.green)
                ////                            Text("New Request")
                ////                        }
                ////                        //                        Text("https://").foregroundStyle(.secondary)
                ////                    }.tag(3)
                ////                    /*@START_MENU_TOKEN@*/Text(data.method)/*@END_MENU_TOKEN@*/
//                }
//                VStack(alignment: .leading) {}
//                VStack(alignment: .leading) {
//                    HStack {
//                        Button("GET") {}.buttonStyle(.borderedProminent).tint(.green)
//                        Text("New Request")
//                    }
                ////                        Text("https://").foregroundStyle(.secondary)
//                }.tag(3)
//                VStack(alignment: .leading) {
//                    HStack {
//                        Button("POST") {}.buttonStyle(.borderedProminent).tint(.yellow)
//                        Text("New Request")
//                    }
                ////                        Text("https://").foregroundStyle(.secondary)
//                }.tag(4)
//                VStack(alignment: .leading) {
//                    HStack {
//                        Button("PUT") {}.buttonStyle(.borderedProminent).tint(.blue)
//                        Text("New Request")
//                    }
//                }.tag(4)
//                VStack(alignment: .leading) {
//                    HStack {
//                        Button("PATCH") {}.buttonStyle(.borderedProminent).tint(.purple)
//                        Text("New Request")
//                    }
//                }.tag(5)
//                VStack(alignment: .leading) {
//                    HStack {
//                        Button("DELETE") {}.buttonStyle(.borderedProminent).tint(.orange)
//                        Text("New Request")
//                    }
//                }.tag(6)
//                VStack(alignment: .leading) {
//                    HStack {
//                        Button("HEAD") {}.buttonStyle(.borderedProminent).tint(.green)
//                        Text("New Request")
//                    }
//                }.tag(6)
//                VStack(alignment: .leading) {
//                    HStack {
//                        Button("OPTIONS") {}.buttonStyle(.borderedProminent).tint(.pink)
//                        Text("New Request")
//                    }
//                }.tag(7)
            }
//            }
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
                Picker(environmentSelection, selection: $environmentSelection) {
                    ForEach(environments, id: \.self) { env in
                        Text(env)
                    }
                }
                .labelsHidden()
                .scaledToFit()
            }
            ToolbarItem {
                Button(action: sendHttpRequest) {
                    Label("Save", systemImage: "play.fill")
                }.disabled(true)
            }
        }.navigationSplitViewStyle(.prominentDetail)
//        .searchable(text: $searchText, placement: .automatic)
    }
}

struct DetailView: View {
    var item: Int

    var body: some View {
        Text("Detail for Item \(item)")
            .navigationTitle("Item \(item)")
    }
}

struct EnvironmentInfo {
    @State var name: String = "New Environment"
}

struct EnvironmentView {
    var body: some View {
        Text("")
    }
}

struct EnvironmentList: View {
    @Binding var environments: [String]
    @Binding var environment: String

    var body: some View {
        NavigationStack {
//        Text(environment).navigationTitle("env: \(environment)")
            HStack {
                Text("New Environment")
                Button(action: {}) {
                    Label("add-environment", systemImage: "plus")
                        .labelStyle(.iconOnly).disabled(true)
                }.padding(10)
            }
            .buttonStyle(PlainButtonStyle())
            VStack {
                List(selection: $environment) {
                    ForEach(environments, id: \.self) { env in
                        HStack {
                            Text(env).tag(env)
                            if env == environment {
                                Spacer()
                                Image(systemName: "checkmark.circle.fill")
                            }
//
                        }
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
