//
//  MainViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Aliona on 16/01/2018.
//  Copyright © 2018 Parse. All rights reserved.
//

import Foundation
import Parse

class MainViewController: UIViewController {

    @IBOutlet weak var pic: UIImageView!

    var center: CGPoint = CGPoint(x: UIScreen.main.bounds.width / 2,
                                  y: UIScreen.main.bounds.height / 2)
    var currentDisplayingUserId: String?
    var liked: [String] = []
    var possibleVariants: [String: UIImage] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(dragged(_ :)))
        pic.isUserInteractionEnabled  = true
        pic.addGestureRecognizer(recognizer)
        getLiked()
        getPossibleVariants()
        saveUserLocation()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        center = pic.center
        updateImage()
    }

    @objc func dragged(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: view)
        let label = gestureRecognizer.view
        label?.center = CGPoint(x: view.bounds.width/2 + translation.x, y: view.bounds.height/2 + translation.y)
        let xFromCenter = (label?.center.x)! - view.bounds.width/2
        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 100)
        let scale = min (abs(100 / xFromCenter), 1)
        var rotateAndStretch = rotation.scaledBy(x: scale, y: scale)
        label?.transform = rotateAndStretch
        if gestureRecognizer.state == .ended {
            if label?.center.x ?? 0 < CGFloat(100) {
                print("Fail")
                swipeUser(like: false)
            } else {
                print("Success!!!")
                swipeUser(like: true)
            }
            rotation = CGAffineTransform(rotationAngle: 0)
            rotateAndStretch = rotation.scaledBy(x: 1, y: 1)
            label?.transform = rotateAndStretch
            label?.center = center
        }
    }

    @IBAction func tapOnNavigation(_ sender: Any) {
        performSegue(withIdentifier: "openMessages", sender: nil)
    }

    private func swipeUser(like: Bool) {
        guard let userId = currentDisplayingUserId else {
            return
        }
        liked.append(userId)
        let likeObject = PFObject(className: Constants.likesObjectKey)
        likeObject[Constants.likesLikerKey] = PFUser.current()?.objectId ?? ""
        likeObject[Constants.likesLikeeKey] = currentDisplayingUserId
        likeObject[Constants.likesLikeKey] = like
        likeObject.saveInBackground { (success, err) in
            if let error = err {
                print(error.localizedDescription)
            } else {
                print("LIKE ADDED")
            }
        }
        updateImage()
    }

    private func getLiked() {
        let query = PFQuery(className: Constants.likesObjectKey)
        query.whereKey(Constants.likesLikerKey, equalTo: PFUser.current()?.objectId ?? "")
        query.findObjectsInBackground(block: { [weak self] (objects, err) in
            if let err = err {
                print(err)
            } else if let objects = objects {
                _ = objects.map { object in
                    if let id = object[Constants.likesLikeeKey] as? String {
                        self?.liked.append(id)
                    }
                }
            }
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logout" {
            PFUser.logOut()
        }
    }

    private func updateImage() {
        let currentUser = possibleVariants.first { !liked.contains($0.key) }
        currentDisplayingUserId = currentUser?.key ?? nil
        pic.image = currentUser?.value ?? #imageLiteral(resourceName: "img")
    }

    private func saveUserLocation() {
        PFGeoPoint.geoPointForCurrentLocation { (geopoint, error) in
            if let location = geopoint, let user = PFUser.current() {
                user[Constants.locationKey] = location
                user.saveInBackground()
                print(geopoint.debugDescription)
            }
        }
    }

    func getPossibleVariants() {

        let query = PFUser.query()
        query?.whereKey(Constants.genderKey, equalTo: !(PFUser.current()?[Constants.preferenceKey] as? Bool ?? false))
        query?.whereKey(Constants.preferenceKey, equalTo: !(PFUser.current()?[Constants.genderKey] as? Bool ?? false))
        if let location = PFUser.current()?[Constants.locationKey] as? PFGeoPoint {
            query?.whereKey(Constants.locationKey, nearGeoPoint: location, withinKilometers: 100)
        }
        query?.findObjectsInBackground(block: { [weak self] (objects, err) in
            guard let users = objects else {
                return
            }
            for user in users {
                if let pfuser = user as? PFUser, let id = pfuser.objectId, let file = pfuser[Constants.imgKey] as? PFFile {
                    file.getDataInBackground(block: { (data, err) in
                        guard let imgData = data, let img = UIImage(data: imgData) else {
                            return
                        }
                        self?.possibleVariants[id] = img
                    })
                }
            }
        })
    }
}
