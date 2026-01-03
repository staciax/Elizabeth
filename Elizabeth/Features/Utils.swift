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

func statusColor(for statusCode: Int) -> Color {
    switch statusCode {
    case 100..<200:
        return .gray
    case 200..<300:
        return .green
    case 300..<400:
        return .blue
    case 400..<500:
        return .orange
    case 500..<600:
        return .red
    default:
        return .gray
    }
}

func formatDuration(_ seconds: Double) -> String {
    let seconds = max(seconds, 0)

    guard seconds > 0 else { return "0 ms" }

    switch seconds {
    case ..<1:
        let ms = seconds * 1000
        return String(format: "%.1f ms", ms)
    case 1..<60:
        return String(format: "%.2f s", seconds)
    case 60..<3600:
        let minutes = seconds / 60
        return String(format: "%.2f m", minutes)
    default:
        let hours = seconds / 3600
        return String(format: "%.2f h", hours)
    }
}
