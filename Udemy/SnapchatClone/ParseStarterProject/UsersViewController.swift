//
//  UsersViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Aliona on 03/02/2018.
//  Copyright © 2018 Parse. All rights reserved.
//

import UIKit
import Parse

class UsersViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var userNames: [String] = []
    var recipient: String = ""
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()

        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { [weak self] (timer) in
            self?.getNewMessages()
        })

        getUsers()
    }

    private func getNewMessages() {
        let query = PFQuery(className: "Photo")
        query.whereKey("recipient", equalTo: PFUser.current()?.username ?? "")
        do {
            if let image = try query.findObjects().first {
                guard let sender = image["sender"] as? String,
                    let file = image["image"] as? PFFile else {
                        return
                }
                file.getDataInBackground(block: { [weak self] (data, err) in
                    guard let data = data, let uiimage = UIImage(data: data) else {
                        return
                    }
                    self?.message(from: sender, image: uiimage, object: image)
                })
            }
        } catch {
        }
    }

    private func message(from: String, image: UIImage, object: PFObject) {
        let subview = view.subviews.first { $0.tag == 1 }
        guard subview == nil else {
            return
        }
        let message = "You have a message from \(from)"
        showAlert(with: message) { [weak self] _ in
            guard let view = self?.view else {
                return
            }

            let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)

            let background = UIView(frame: frame)
            background.backgroundColor = .black
            background.alpha = 0.75
            background.tag = 1

            let imageView = UIImageView(frame: frame)
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            background.addSubview(imageView)

            view.addSubview(background)
            object.deleteInBackground()

            _ = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { timer in
                let viewToRemove = view.subviews.first { $0.tag == 1 }
                viewToRemove?.removeFromSuperview()
            })
        }
    }

    private func getUsers() {
        let query = PFUser.query()
        query?.whereKey("username", notEqualTo: PFUser.current()?.username ?? "")
        do {
            if let users = try query?.findObjects() as? [PFUser] {
                userNames = users.map { $0.username ?? "" }
                tableView.reloadData()
            }
        } catch {
            print("Error")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userNames.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = userNames[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        recipient = userNames[indexPath.row]

        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false
        present(imagePickerController, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let imgData = UIImageJPEGRepresentation(image, 0.5) {

            let imageToSend = PFObject(className: "Photo")
            imageToSend["image"] = PFFile(name: "img.jpeg", data: imgData)
            imageToSend["sender"] = PFUser.current()?.username ?? ""
            imageToSend["recipient"] = recipient

            let acl = PFACL()
            acl.getPublicReadAccess = true
            acl.getPublicWriteAccess = true
            imageToSend.acl = acl

            imageToSend.saveInBackground(block: { (success, err) in
                if let err = err?.localizedDescription {
                    self.showAlert(with: err)
                } else {
                    self.showAlert(with: "File was sent!")
                }
            })
        }
        dismiss(animated: true, completion: nil)
    }

    @IBAction func logout(_ sender: Any) {
        PFUser.logOut()
        performSegue(withIdentifier: "logoutSegue", sender: self)
    }
}
