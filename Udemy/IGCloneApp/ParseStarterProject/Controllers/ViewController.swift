import UIKit
import Parse

enum Modes {
    case signin
    case signup
}

class ViewController: UIViewController {

    var currentMode = Modes.signup
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))

    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!

    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    @IBAction func signUpOrSignIn(_ sender: UIButton) {

        guard let login = loginField.text, !login.isEmpty,
            let password = passwordField.text, !password.isEmpty else {
                createAlert(title: "Missing info", message: "Fill out the both fileds", buttonName: "Got it!")
            return
        }

        addActivityIndicator(activityIndicator)
        switch currentMode {
        case .signup:
            let user = PFUser()
            user.username = login
            user.password = password
            user.signUpInBackground(block: { (success, err) in
                self.dismissActivityIndicator(self.activityIndicator)
                if let err = err {
                    print(err)
                    self.createAlert(title: err.localizedDescription, buttonName: "I see")
                } else if success {
                    print("Success!")
                    self.login()
                } else {
                    self.createAlert(title: "Something strange happened", buttonName: "I see")
                    print("Something strange happened")
                }
            })
        case .signin:
            PFUser.logInWithUsername(inBackground: login, password: password, block: { (user, err) in
                self.dismissActivityIndicator(self.activityIndicator)
                if let err = err {
                    print(err)
                    self.createAlert(title: err.localizedDescription, buttonName: "I see")
                } else if let _ = user {
                    self.login()
                } else {
                    self.createAlert(title: "Something strange happened", buttonName: "I see")
                    print("Something strange happened")
                }
            })
        }

    }

    private func login() {
        loginField.text = ""
        passwordField.text = ""
        performSegue(withIdentifier: "showFeed", sender: self)
    }

    @IBAction func changeMode(_ sender: UIButton) {
        switch currentMode {
        case .signup:
            leftButton.setTitle("Sign up", for: [])
            rightButton.setTitle("Sign in", for: [])
            currentMode = .signin
        case .signin:
            leftButton.setTitle("Sign in", for: [])
            rightButton.setTitle("Sign up", for: [])
            currentMode = .signup
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if PFUser.current() != nil {
            performSegue(withIdentifier: "showFeed", sender: self)
        }
    }

    @IBAction func logout(segue:UIStoryboardSegue) {
    }
}
