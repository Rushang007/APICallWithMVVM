//
//  NetworkError.swift

import Foundation

public struct NetworkError : Error {
    let reason: String?
    let httpStatusCode: Int?
    
    init(errorMessage message: String, forStatusCode statusCode: Int? = nil) {
        self.httpStatusCode = statusCode
        self.reason = message
    }
}
