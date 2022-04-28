//
//  ViewController.swift
//  Qubicash
//
//  Created by Panuku Goutham on 05/04/22.
//

import UIKit
import Combine

class ViewController: UIViewController {
    @IBOutlet weak var helloWorldLabel: UILabel!
    private(set) lazy var viewModel = {
        ViewModel(networkManager: NetworkManager())
    }()
    var helloworld = "" {
        didSet {
            helloWorldLabel.text = helloworld
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        viewModel.apiResult
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(let err):
                    print("Error: \(err.localizedDescription)")
                case .finished:
                    print("Finished")
                }
            } receiveValue: { [weak self] result in
                self?.helloworld = result.text
            }
            .store(in: &cancellables)
        
        viewModel.getUsers()
    }
    
}
