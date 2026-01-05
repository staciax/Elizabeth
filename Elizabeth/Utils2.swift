//
//  Utils2.swift
//  Elizabeth
//
//  Created by STACiA on 5/1/2569 BE.
//

import Alamofire
import Foundation
import SwiftUI

// functions: Specifying Argument Labels
func getMethodColor(for httpMethod: HTTPMethod) -> Color {
    // enumerations: Matching Enumeration Values with a Switch Statement]
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
    // control flow: Interval Matching
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

// functions: Omitting Argument Labels
func formatDuration(_ seconds: Double) -> String {
    
    // the basics: Type Safety and Type Inference
    let seconds = max(seconds, 0)
    
    // control flow: Early Exit
    guard seconds > 0 else { return "0 ms" }

    switch seconds {
    // control flow: Interval Matching
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

// https://stackoverflow.com/questions/25965239/how-do-i-get-the-app-version-and-build-number-using-swift
// funtions: Functions Without Parameters
func getDefaultUserAgent() -> String {
    let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "Elizabeth"
    let versionString = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0.0.0"

    return "\(appName)/\(versionString)"
}

// the basics: Type Aliases
// the basics: Tuples
typealias HTTPReponse = (
    data: String?,
    statusCode: Int?,
    url: URL?,
    duration: TimeInterval,
    requestHeaders: [String: String],
    responseHeaders: [String: String],
    cookies: [String],
    errorDescription: String?,
    headerSizeBytes: Int64,
    bodySizeBytes: Int64
)

// functions: Functions With Multiple Parameters
// functions: Default Parameter Values
func sendHttpRequest2(
    _ request: RequestData2,
    maxAttempts: Int = 3
) async -> HTTPReponse {
    precondition(maxAttempts >= 1, "maxAttempts must be at least 1")

    func extractCookies(from headers: [String: String]) -> [String] {
        return headers
            .filter { $0.key.lowercased() == "set-cookie" }
            .map { $0.value }
    }

    var headers: HTTPHeaders = []
    
    // collection types: Dictionaries - Creating an Empty Dictionary
    // collection types: Dictionaries - Creating an Empty Dictionary
    for (key, value) in request.headers ?? [:] {
        headers[key] = value
    }

    var finalResponse: DataResponse<String, AFError>?
    var duration: TimeInterval = 0

    for attempt in 1 ... maxAttempts {
        
        let task: DataTask<String>
        
        if let bodyContent = request.bodyContent {
            
            // thank: https://stackoverflow.com/questions/27855319/post-request-with-a-simple-string-in-body-with-alamofire
            var urlRequest = try! URLRequest(
                url: request.url,
            method: .init(rawValue: request.method.rawValue.uppercased()),
            headers: headers
        )
            urlRequest.httpBody = Data(bodyContent.utf8)
            task = AF.request(urlRequest)
                    .serializingString()
        } else {
             task = AF.request(
                request.url,
                method: .init(rawValue: request.method.rawValue.uppercased()),
                headers: headers,
                
            )
        .serializingString() // .serializingData()
        }

        let startTime = CFAbsoluteTimeGetCurrent()
        let response = await task.response
        let endTime = CFAbsoluteTimeGetCurrent()

        duration = endTime - startTime
        finalResponse = response

        if let error = response.error {
            print("Attempt \(attempt) failed: \(error.localizedDescription)")
        } else {
            break
        }
    }

    // the basics: Force Unwrapping
    let response = finalResponse! 
    
    // metrics
    var headerBytes: Int64 = 0
    var bodyBytes: Int64 = 0

    if let metrics = response.metrics,
       let transaction = metrics.transactionMetrics.last {
        headerBytes = transaction.countOfResponseHeaderBytesReceived
        bodyBytes = transaction.countOfResponseBodyBytesReceived
    }

    debugPrint(response)

    let data = response.value
    let statusCode = response.response?.statusCode
    let finalURL = response.response?.url

    // response headers
    var responseHeaders: [String: String] = [:]
    if let all = response.response?.allHeaderFields {
        for (key, value) in all {
            responseHeaders[String(describing: key)] = String(describing: value)
        }
    }

    // request headers
    let requestHeaders = response.request?.allHTTPHeaderFields ?? [:]

    // cookies
    let cookies: [String] = extractCookies(from: responseHeaders)

    // error
    let errorDescription = response.error?.localizedDescription

    return (
        statusCode: statusCode,
        url: finalURL,
        duration: duration,
        requestHeaders: requestHeaders,
        responseHeaders: responseHeaders,
        data: data,
        cookies: cookies,
        errorDescription: errorDescription,
        headerSizeBytes: headerBytes,
        bodySizeBytes: bodyBytes
    )
}

// functions: Variadic Parameters
func buildHeaders(_ headers: (String, String)...) -> [String: String] {
    // collection types: Dictionaries - Dictionary Type Shorthand Syntax
    var result: [String: String] = [:]
    for (key, value) in headers { result[key] = value
    }
    return result
}

// functions: Variadic Parameters
func buildParams(_ params: (String, String)...) -> [String: String] {
    var result: [String: String] = [:]
    for (key, value) in params {
        result[key] = value
    }
    return result
}

// functions: Functions With an Implicit Return
// collection types: Dictionaries - Creating a Dictionary with a Dictionary Literal
func getDefaultHeaders() -> [String: String] {
    [
        "User-Agent": getDefaultUserAgent(),
        "Accept": "*/*"
    ]
    // buildHeaders(
    //     ("User-Agent", getDefaultUserAgent()),
    //     ("Accept", "*/*")
    // )
}

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
    // the basics: Optional - Optional Binding
    if let name = httpStatus[statusCode] {
        return name
    }
    return ""
}


func getEncodingDebug(_ text: String) -> String {
    var result = ""
    
    // strings and characters: Unicode Representations of Strings

    // utf-8

    // basic operators: Compound Assignment Operators (+=)
    result += "UTF-8: "
    for byte in text.utf8 {
        result += "\(byte) "
    }
    result += "\n\n"

    // utf-16
    result += "UTF-16: "
    for codeUnit in text.utf16 {
        result += "\(codeUnit) "
    }
    result += "\n\n"

    // unicode scalars
    result += "Scalars: "
    for scalar in text.unicodeScalars {
        result += "\(scalar.value) "
    }
    
    return result
}

func formatBytes(_ bytes: Int) -> String {

    // the basics: Integer and Floating-Point Conversion
    let value = Double(bytes)
    
    guard value > 0 else { return "0 B" }
    
    let kb_size: Double = 1024
    let mb_size: Double = kb_size * 1024
    let gb_size: Double = mb_size * 1024
    
    switch value {
    case ..<kb_size:
        return "\(bytes) B"
    case kb_size..<mb_size:
        return String(format: "%.2f KB", value / kb_size)
    case mb_size..<gb_size:
        return String(format: "%.2f MB", value / mb_size)
    default:
        return String(format: "%.2f GB", value / gb_size)
    }
}
// https://www.hackingwithswift.com/example-code/strings/how-to-specify-floating-point-precision-in-a-string

// basic operators: Comparison Operators
func isOK(_ code: Int) -> Bool {
    code == 200
}

// basic operators:  Range Operators
func isSuccess(code: Int) -> Bool {
    (200...299).contains(code)
}

// basic operators: Half-Open Range Operator
func isClientError(code: Int) -> Bool {
    (400..<500).contains(code)
}

// basic operators: One-Sided Ranges
func isServerError(code: Int) -> Bool {
    (500...).contains(code)
}

