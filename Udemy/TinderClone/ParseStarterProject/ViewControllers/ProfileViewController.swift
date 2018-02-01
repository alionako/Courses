//
//  ProfileViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Aliona on 15/01/2018.
//  Copyright © 2018 Parse. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userPic: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var userGenderSwitch: UISwitch!
    @IBOutlet weak var userPreferenceSwitch: UISwitch!

    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        setUserInfo()
    }

    private func setUserInfo() {
        guard let user = PFUser.current() else {
            return
        }
        if let genderValue = user[Constants.genderKey] as? Bool {
            userGenderSwitch.isOn = genderValue
        }
        if let preferenceValue = user[Constants.preferenceKey] as? Bool {
            userPreferenceSwitch.isOn = preferenceValue
        }
        if let file = user[Constants.imgKey] as? PFFile {
            file.getDataInBackground(block: { [weak self] (data, err) in
                if let imageData = data, let image = UIImage(data: imageData) {
                    self?.userPic.image = image
                }
            })
        }
    }

    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {

        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary

        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            userPic.image = pickedImage
            userPic.contentMode = .scaleAspectFill
            userPic.layer.cornerRadius = userPic.frame.size.width / 2
        }

        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func save(_ sender: UIButton) {
        guard let user = PFUser.current() else {
            return
        }
        user[Constants.genderKey] = userGenderSwitch.isOn
        user[Constants.preferenceKey] = userPreferenceSwitch.isOn
        if let image = userPic.image, let imageData = UIImagePNGRepresentation(image) {
            user[Constants.imgKey] = PFFile(name: Constants.imgNameKey, data: imageData)
        }
        user.saveInBackground { [weak self] (success, err) in
            if let error = err {
                self?.showAlert(with: error.localizedDescription)
            } else {
                self?.showAlert(with: "Save success!")
            }
        }
    }

    private func showAlert(with text: String) {
        let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.view.tintColor = .darkGray
        present(alert, animated: true, completion: nil)
    }

    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
