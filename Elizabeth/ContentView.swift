//
//  ContentView.swift
//  Elizabeth
//
//  Created by STACiA on 28/12/2568 BE.
//

import SwiftUI

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

struct ContentView: View {
    var body: some View {
        SidebarView()
    }
}

#Preview {
    ContentView()
}
