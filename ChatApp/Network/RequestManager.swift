//
//  RequestManager.swift
//  ChatApp
//
//  Created by Luis Francisco Dzuryk on 29/01/2020.
//  Copyright © 2020 Luis Francisco Dzuryk. All rights reserved.
//

import Foundation
import Alamofire

class RequestManager {
    private var BaseURL: String? {
        guard let url = Bundle.main.infoDictionary?["BaseURL"] as? String else {
            return nil
        }
        return url
    }
    
    func POSTRequest(path: String, data: Data?) -> URLRequest?{
        
        guard let url = BaseURL, let baseURL = URL(string: url) else {
            return nil
        }
        let fullURL = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: fullURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = data
        return request
    }
    
    func GETRequest(path: String) -> URLRequest?{
        guard let url = BaseURL, let baseURL = URL(string: url) else {
            return nil
        }
        let fullURL = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: fullURL)
        request.httpMethod = HTTPMethod.get.rawValue
        return request
    }
}

enum BaseURLError: LocalizedError {
    case wrongURL
    case notImplemented
    case POSTEmptyData
    case wrongRespnose
    case serverFails
    var errorDescription: String? {
        switch self {
        case .wrongURL:
            return "URL erronea"
        case .notImplemented:
            return "Not Implemented"
        case .POSTEmptyData:
            return "Post data is empty"
        case .wrongRespnose:
            return "Can't get server response"
        case .serverFails:
            return "The server is not responding. Try again later."
        }
    }
}
