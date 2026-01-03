//
//  Utils.swift
//  Elizabeth
//
//  Created by STACiA on 3/1/2569 BE.
//

import SwiftUI

func getMethodColor(for httpMethod: HTTPMethod) -> Color {
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
