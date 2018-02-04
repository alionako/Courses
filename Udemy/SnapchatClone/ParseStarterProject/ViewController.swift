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

class ViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    
    @IBAction func login(_ sender: Any) {
        let name = userName.text ?? ""
        let pass = "test"

        let user = PFUser()
        user.username = name
        user.password = pass
        user.signUpInBackground { [weak self] (success, err) in
            if success {
                self?.performSegue(withIdentifier: "showUsers", sender: self)
            } else if err != nil {
                PFUser.logInWithUsername(inBackground: name, password: pass, block: { [weak self] (user, err) in

                    if user != nil {
                        self?.performSegue(withIdentifier: "showUsers", sender: self)
                    } else if let err = err {
                        print(err)
                    }
                })
            }
        }
    }

    @IBAction func logout(segue:UIStoryboardSegue) {
    }
}

// MARK: - Show alerts

extension UIViewController {

    func showAlert(with text: String, completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: completion))
        alert.view.tintColor = .darkGray
        present(alert, animated: true, completion: nil)
    }
}
