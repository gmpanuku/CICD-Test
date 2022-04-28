//
//  ViewController.swift
//  Qubicash
//
//  Created by Panuku Goutham on 05/04/22.
//

import UIKit

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            self.moveToViewController()
        }
    }
    
    func moveToViewController() {
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") {
            let transition: CATransition = CATransition()
            transition.duration = 0
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
            transition.type = CATransitionType.fade
            self.view.window?.layer.add(transition, forKey: "kCATransition")
            self.navigationController?.pushViewController(viewController, animated: false)
        }
    }
    
    
}

