//
//  ViewModel.swift
//  Qubicash
//
//  Created by Panuku Goutham on 07/04/22.
//

import Foundation
import Combine

class ViewModel {
    private var networkManager: NetworkManagerProtocol
    let apiResult = PassthroughSubject<HelloWorld, Error>()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getUsers() {
        self.getUsersFromNetworkManager()
    }
}

extension ViewModel {
    
    private func getUsersFromNetworkManager() {
        self.networkManager.requestMethod = .get
        networkManager.request(apiEndPoint: APIEndPoint.helloworld, type: HelloWorld.self)
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let err):
                        print("Error is \(err.localizedDescription)")
                        self.apiResult.send(completion: .failure(err))
                    case .finished:
                        print("Finished")
                        self.apiResult.send(completion: .finished)
                    }
                },
                receiveValue: { [weak self] result in
                    print(result)
                    self?.apiResult.send(result)
                }
            )
            .store(in: &cancellables)
    }
    
}

