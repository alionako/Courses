//
//  ViewController.swift
//  TouchIDDemo
//
//  Created by Aliona on 31/01/2018.
//  Copyright © 2018 Aliona. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let localAuthenticationContext = LAContext()

        var error: NSError?
        guard localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            label.text = "You have no touch ID, sorry, bro!"
            img.image = #imageLiteral(resourceName: "fail")
            return
        }

        localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "We'll tell you your future") { [weak self] (success, err) in
            if success {
                self?.label.text = "Welcome to the private territory 😜"
                self?.img.image = #imageLiteral(resourceName: "lock")
            } else if err != nil {
                self?.label.text = "Oops! Something went wrong"
                self?.img.image = #imageLiteral(resourceName: "err")
            } else {
                self?.label.text = "Hey, that's not you!"
                self?.img.image = #imageLiteral(resourceName: "thief")
            }
        }

    }
}

