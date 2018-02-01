//
//  ViewController.swift
//  FacebookTestApp
//
//  Created by Aliona on 31/01/2018.
//  Copyright © 2018 Aliona. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
        } else if result.isCancelled {
            print("User cancelled login")
        } else {
            if result.grantedPermissions.contains("email") {
                if let graphRequest = FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields": "email, name"]) {
                    graphRequest.start(completionHandler: { (connection, result, error) in
                        if error != nil {
                            print(error)
                        } else {
                            if let details = result {
                                print(details)
                            }
                        }
                    })
                }
            }

        }
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logged out")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if FBSDKAccessToken.current() != nil {
            print("Logged in")
        } else {
            let loginButton = FBSDKLoginButton()
            loginButton.center = view.center
            loginButton.readPermissions = ["public_profile", "email"]
            loginButton.delegate = self
            view.addSubview(loginButton)
        }
    }
}

