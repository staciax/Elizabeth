//
//  Utils2.swift
//  Elizabeth
//
//  Created by STACiA on 5/1/2569 BE.
//

import Alamofire
import Foundation

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
    errorDescription: String?
)

// functions: Functions With Multiple Parameters
// functions: Default Parameter Values
func sendHttpRequest2(
    _ request: RequestData2,
    maxAttempts: Int = 3
) async -> HTTPRequestResult {
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
        let task = AF.request(
            request.url,
            method: .init(rawValue: request.method.rawValue.uppercased()),
            headers: headers
        )
        .serializingString() // .serializingData()

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
        errorDescription: errorDescription
    )
}
