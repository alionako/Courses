import UIKit

extension UIViewController {

    func addActivityIndicator(_ activityIndicator: UIActivityIndicatorView) {
        activityIndicator.center = view.center
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        UIApplication.shared.beginIgnoringInteractionEvents()
    }

    func dismissActivityIndicator(_ activityIndicator: UIActivityIndicatorView) {
        UIApplication.shared.endIgnoringInteractionEvents()
        activityIndicator.stopAnimating()
    }
}

extension UIViewController {

    func createAlert(title: String, message: String = "", buttonName: String = "OK") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonName, style: .default, handler: nil))
        alert.view.tintColor = .appTintColor
        self.present(alert, animated: true, completion: nil)
    }
}
