/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

enum Mode {
    case login
    case register
}

class ViewController: UIViewController {

    var mode: Mode = .login

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var changeModeButton: UIButton!

    @IBAction func logIn(_ sender: Any) {
        switch mode {
        case .register:
            let user = PFUser()
            user.username = username.text
            user.password = password.text
            let acl = PFACL()
            acl.getPublicReadAccess = true
            user.acl = acl
            user.signUpInBackground { (success, error) in
                if let err = error {
                    print(err)
                } else {
                    print("Register success")
                    self.openProfile()
                }
            }
        case .login:
            PFUser.logInWithUsername(inBackground: username.text ?? "",
                                     password: password.text ?? "",
                                     block: { (success, error) in
                                        if let err = error {
                                            print(err)
                                        } else {
                                            print("Login success")
                                            self.openProfile()
                                        }
                                    })
        }
    }

    @IBAction func changeMode(_ sender: Any) {
        mode = (mode == .login) ? .register : .login
        setupButtons()
    }


    private func openProfile() {
        performSegue(withIdentifier: "open", sender: nil)
    }

    private func setupButtons() {
        switch mode {
        case .register:
            loginButton.setTitle("Create account", for: [])
            changeModeButton.setTitle("Click here to log in", for: [])
        case .login:
            loginButton.setTitle("Log in", for: [])
            changeModeButton.setTitle("Don't have an account? Click to register", for: [])
        }
    }

    @IBAction func logout(segue:UIStoryboardSegue) {
    }
}
