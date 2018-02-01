import UIKit
import Parse

class PostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "New post"
    }

    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var postButton: UIButton!

    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            postButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }

    @IBAction func postButtonClick(_ sender: UIButton) {
        addActivityIndicator(activityIndicator)
        let post = PFObject(className: "Posts")
        post["userId"] = PFUser.current()?.objectId
        post["message"] = textField.text
        guard let image = imageView.image, let imageData = UIImageJPEGRepresentation(image, 0.5) else {
            return
        }
        let imageFile = PFFile(name: "image.png", data: imageData)
        post["imageFile"] = imageFile

        post.saveInBackground { (success, err) in
            self.dismissActivityIndicator(self.activityIndicator)
            if let err = err {
                let errorMessage = String(format: "Something went wrong %s", err.localizedDescription)
                self.createAlert(title: errorMessage)
            } else {
                self.textField.text = ""
                self.imageView.image = UIImage(named: "Camera-obscura")
                self.postButton.isEnabled = false
                self.createAlert(title: "Uploaded successfully")
            }
        }
    }

}
