//
//  MatchesViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Aliona on 19/01/2018.
//  Copyright © 2018 Parse. All rights reserved.
//

import Foundation
import Parse

class MatchesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var userMatches: [PFUser] = []
    var matchesImages: [UIImage] = []
    var messages: [PFObject] = []

    var userLikedIds: [String]?
    var likedByOthersIds: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadLiked()
        loadLikedBy()
        loadMessages()
    }

    private func loadLiked() {
        let query = PFQuery(className: Constants.likesObjectKey)
        query.whereKey(Constants.likesLikerKey, equalTo: PFUser.current()?.objectId ?? "")
        query.whereKey(Constants.likesLikeKey, equalTo: true)
        query.findObjectsInBackground(block: { [weak self] (objects, err) in
            if let err = err {
                print(err)
            } else if let objects = objects {
                let ids = objects.flatMap { object in
                    object[Constants.likesLikeeKey] as? String
                }
                self?.userLikedIds = ids
                self?.recalculateMatches()
            }
        })
    }

    private func loadLikedBy() {
        let query = PFQuery(className: Constants.likesObjectKey)
        query.whereKey(Constants.likesLikeeKey, equalTo: PFUser.current()?.objectId ?? "")
        query.whereKey(Constants.likesLikeKey, equalTo: true)
        query.findObjectsInBackground(block: { [weak self] (objects, err) in
            if let err = err {
                print(err)
            } else if let objects = objects {
                let ids = objects.flatMap { object in
                    object[Constants.likesLikerKey] as? String
                }
                self?.likedByOthersIds = ids
                self?.recalculateMatches()
            }
        })
    }

    private func loadMessages() {
        let query = PFQuery(className: Constants.messageObjectKey)
        query.whereKey(Constants.toKey, equalTo: PFUser.current()?.objectId ?? "")
        query.findObjectsInBackground(block: { [weak self] (objects, err) in
            if let err = err {
                print(err)
            } else if let messages = objects {
                self?.messages = messages
                self?.tableView.reloadData()
            }
        })
    }

    private func recalculateMatches() {
        guard let liked = userLikedIds, let likedBy = likedByOthersIds else {
            return
        }
        let matchingIds: [String] = liked.filter { likedBy.contains($0) }
        let query = PFUser.query()
        query?.whereKey("objectId", containedIn: matchingIds)
        query?.findObjectsInBackground(block: { [weak self] (objects, err) in
            guard let users = objects else {
                return
            }
            for user in users {
                if let user = user as? PFUser,
                    let file = user[Constants.imgKey] as? PFFile {

                    file.getDataInBackground(block: { (data, err) in
                        guard let imgData = data, let img = UIImage(data: imgData) else {
                            return
                        }
                        self?.userMatches.append(user)
                        self?.matchesImages.append(img)
                        self?.tableView.reloadData()
                    })
                }
            }
        })
    }

    @IBAction func doneButtonClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? MatchesCell else
        {
            return UITableViewCell()
        }
        cell.user = userMatches[indexPath.row]
        let currentUserId = cell.user?.objectId
        let msg = messages.first { $0[Constants.fromKey] as? String == currentUserId }?[Constants.messageKey] as? String
        if msg != nil {
            cell.message.text = msg
        }
        cell.img.image = matchesImages[indexPath.row]
        cell.title.text = userMatches[indexPath.row].username
        cell.textField.placeholder = "Write a message here"
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userMatches.count
    }
}
