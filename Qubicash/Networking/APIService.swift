//
//  APIService.swift
//  Qubicash
//
//  Created by Panuku Goutham on 07/04/22.
//

import Foundation
import UIKit

enum APIEndPoint: String {
    case helloworld                      =   "helloworld"
}

struct APIService {
    
    private let baseURLString = "https://my-json-server.typicode.com/gmpanuku/qubicash/"
    private var urlString: String?
    
    init(endPoint: APIEndPoint) {
        self.urlString = baseURLString+endPoint.rawValue
    }
    
    func getRequest(networkManager: NetworkManagerProtocol) -> Request {
        guard let urlString = self.urlString, var components = URLComponents(string: urlString) else {
            return Request(urlRequest: nil, error: NetworkError.invalidURL)
        }
        if let params = networkManager.params as? [String: Any] {
            if params.count>0 {
                components.queryItems = params.map({ (key: String, value: Any) in
                    URLQueryItem(name: key, value: "\(value)")
                })
            } else {
                return Request(urlRequest: nil, error: NetworkError.invalidParameters)
            }
        }
        if networkManager.isSearchAPI {
            guard let searchKey = networkManager.searchKey, searchKey != "", let text = networkManager.searchText, text != "" else {
                return Request(urlRequest: nil, error: NetworkError.nilSearchKeyOrSearchText)
            }
            components.queryItems?.append(URLQueryItem(name: searchKey, value: text))
        }
        guard let url = components.url else {
            return Request(urlRequest: nil, error: NetworkError.invalidURL)
        }
        let request = URLRequest(url: url)
        return Request(urlRequest: request, error: nil)
    }
    
    func postRequest(networkManager: NetworkManagerProtocol) -> Request {
        guard let urlString = self.urlString, let url = URL(string: urlString) else {
            return Request(urlRequest: nil, error: NetworkError.invalidURL)
        }
        var request = URLRequest(url: url)
        if let params = networkManager.params as? [String: Any], params.count>0 {
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        } else if let params = networkManager.params as? String, !params.isEmpty {
            request.httpBody = params.data(using: .utf8, allowLossyConversion: false)!
        } else {
            return Request(urlRequest: nil, error: NetworkError.invalidParameters)
        }
        return Request(urlRequest: request, error: nil)
    }
}

struct Request {
    let urlRequest: URLRequest?
    let error: Error?
}
