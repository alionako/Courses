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

enum State {
    case login
    case signUp
}

enum Constants {
    static let requestClassnameKey = "Request"
    static let driverLocationClassnameKey = "DriverLocation"

    static let isPassengerKey = "isPassenger"
    static let fromKey = "from"
    static let driverKey = "driver"
    static let locationKey = "location"
    static let usernameKey = "username"

    static let callUberTitle = "Call an uber"
    static let acceptRequestTitle = "Accept request"
    static let cancelRequestTitle = "Cancel request"
    static let cancelOrderTitle = "Cancel order"
}

class ViewController: UIViewController {

    var state: State = .login

    @IBOutlet weak var userTypeSwitch: UISwitch!
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let isPassenger = PFUser.current()?[Constants.isPassengerKey] as? Bool {
            showMap(forPassenger: isPassenger)
        }
        configureButtonsForState()
    }

    @IBAction func changeState(_ sender: Any) {
        state = (state == .login) ? .signUp : .login
        configureButtonsForState()
    }

    private func configureButtonsForState() {
        let mainButtonTitle = (state == .login) ? "Sign in" : "Sign up"
        mainButton.setTitle(mainButtonTitle, for: [])
        let switchButtonTitle = (state == .login) ? "Sign up" : "Sign in"
        switchButton.setTitle(switchButtonTitle, for: [])
        stackView.isHidden = state == .login
    }

    @IBAction func logInOrSignUp(_ sender: Any) {
        switch state {
        case .login:
            PFUser.logInWithUsername(inBackground: loginField.text ?? "", password: passwordField.text ?? "", block: { [weak self] (success, err) in
                if let error = err {
                    self?.showAlert(with: "Error", text: error.localizedDescription)
                } else {
                    print("Sign in success!")
                    self?.showMap(forPassenger: PFUser.current()?[Constants.isPassengerKey] as? Bool)
                }
            })
        case .signUp:
            let user = PFUser()
            user.username = loginField.text
            user.password = passwordField.text
            user[Constants.isPassengerKey] = userTypeSwitch.isOn
            user.signUpInBackground { [weak self] (success, err) in
                if let error = err {
                    self?.showAlert(with: "Error", text: error.localizedDescription)
                } else {
                    print("Sign up success!")
                    self?.showMap(forPassenger: user[Constants.isPassengerKey] as? Bool)
                }
            }
        }
    }

    private func showMap(forPassenger: Bool?) {
        if let passenger = forPassenger, passenger {
            performSegue(withIdentifier: "showMap", sender: nil)
        } else {
            performSegue(withIdentifier: "showRequests", sender: nil)
        }
    }

    @IBAction func logout(segue: UIStoryboardSegue) {
        PFUser.logOut()
    }
}

extension UIViewController {

    func showAlert(with title: String?, text: String?) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
}
