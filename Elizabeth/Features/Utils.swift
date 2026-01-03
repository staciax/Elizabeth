//
//  Utils.swift
//  Elizabeth
//
//  Created by STACiA on 3/1/2569 BE.
//

import SwiftUI

// source: https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Status
let httpStatus: [Int: String] = [
    // 2xx Informational responses
    100: "Continue",
    101: "Switching Protocols",
    102: "Processing",
    103: "Early Hints",
    // 2xx Successful responses
    200: "OK",
    201: "Created",
    202: "Accepted",
    203: "Non-Authoritative Information",
    204: "No Content",
    205: "Reset Content",
    206: "Partial Content",
    207: "Multi-Status",
    208: "Already Reported",
    226: "IM Used",
    // 3xx Redirection messages
    300: "Multiple Choices",
    301: "Moved Permanently",
    302: "Found",
    303: "See Other",
    304: "Not Modified",
    305: "Use Proxy",
    306: "unused",
    307: "Temporary Redirect",
    308: "Permanent Redirect",
    // 4xx Client error responses
    400: "Bad Request",
    401: "Unauthorized",
    402: "Payment Required",
    403: "Forbidden",
    404: "Not Found",
    405: "Method Not Allowed",
    406: "Not Acceptable",
    407: "Proxy Authentication Required",
    408: "Request Timeout",
    409: "Conflict",
    410: "Gone",
    411: "Length Required",
    412: "Precondition Failed",
    413: "Content Too Large",
    414: "URI Too Long",
    415: "Unsupported Media Type",
    416: "Range Not Satisfiable",
    417: "Expectation Failed",
    418: "I'm a teapot",
    421: "Misdirected Request",
    422: "Unprocessable Content",
    423: "Locked",
    424: "Failed Dependency",
    425: "Too Early",
    426: "Upgrade Required",
    428: "Precondition Required",
    429: "Too Many Requests",
    431: "Request Header Fields Too Large",
    451: "Unavailable For Legal Reasons",
    // 5xx Server error responses
    500: "Internal Server Error",
    501: "Not Implemented",
    502: "Bad Gateway",
    503: "Service Unavailable",
    504: "Gateway Timeout",
    505: "HTTP Version Not Supported",
    506: "Variant Also Negotiates",
    507: "Insufficient Storage",
    508: "Loop Detected",
    510: "Not Extended",
    511: "Network Authentication Required",
]

func statusMessage(for statusCode: Int) -> String {
    if let name = httpStatus[statusCode] {
        return name
    }
    return ""
}

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
