//
//  Enums.swift
//  Elizabeth
//
//  Created by STACiA on 2/1/2569 BE.
//

enum HTTPMethod: String, CaseIterable, Identifiable {
    case get, post, put, patch, delete, head, options
    var id: Self { self }
}
