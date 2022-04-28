//
//  NetworkManager.swift
//  Qubicash
//
//  Created by Panuku Goutham on 07/04/22.
//

import Foundation
import Combine

public enum HTTPHeaderField: String {
    case application_json
    case application_x_www_form_urlencoded
    case none
}

public enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol NetworkManagerProtocol {
    var searchKey: String? { get set }
    var searchText: String? { get set }
    var isSearchAPI: Bool { get set }
    var params: Any? { get set }
    var httpHeader: HTTPHeaderField? { get set }
    var requestMethod: RequestMethod? { get set }
    var headers: [String : String]? { get set }
    
    func request<T: Decodable>(apiEndPoint: APIEndPoint, type: T.Type) -> Future<T, Error>
}

class NetworkManager: NetworkManagerProtocol {
    var searchKey: String? = nil
    var searchText: String? = nil
    var isSearchAPI: Bool = false
    var params: Any? = nil
    var httpHeader: HTTPHeaderField? = .application_json
    var requestMethod: RequestMethod? = .post
    var headers: [String : String]? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    func request<T: Decodable>(apiEndPoint: APIEndPoint, type: T.Type) -> Future<T, Error> {
        return Future<T, Error> { [weak self] promise in
            guard let self = self else { return promise(.failure(NetworkError.unknown)) }
            let request = (self.requestMethod == RequestMethod.get)
            ? APIService(endPoint: apiEndPoint).getRequest(networkManager: self)
            : APIService(endPoint: apiEndPoint).postRequest(networkManager: self)
            if let error = request.error { return promise(.failure(error)) }
            guard var urlRequest = request.urlRequest else { return promise(.failure(NetworkError.invalidRequest)) }
            urlRequest.httpMethod = self.requestMethod?.rawValue
            if self.httpHeader != HTTPHeaderField.none {
                urlRequest.setValue(self.httpHeader?.rawValue, forHTTPHeaderField: "Content-Type")
            }
            print(urlRequest.url?.absoluteString ?? "")
            URLSession.shared.dataTaskPublisher(for: urlRequest)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw NetworkError.responseError
                    }
                    return data
                }
                .receive(on: RunLoop.main)
                .decode(type: T.self, decoder: JSONDecoder())
                .sink(
                    receiveCompletion: { (completion) in
                        if case let .failure(error) = completion {
                            switch error {
                            case let decodingError as DecodingError:
                                promise(.failure(decodingError))
                            case let apiError as NetworkError:
                                promise(.failure(apiError))
                            default:
                                promise(.failure(NetworkError.unknown))
                            }
                        }
                    },
                    receiveValue: { promise(.success($0)) }
                )
                .store(in: &self.cancellables)
        }
    }
}
