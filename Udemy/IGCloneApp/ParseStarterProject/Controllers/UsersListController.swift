import Foundation
import UIKit
import Parse

class UsersListController: UITableViewController {

    var users: [PFUser]?
    var following: [String]?

    var refresher: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(UsersListController.refresh), for: .valueChanged)
        tableView.addSubview(refresher)
    }

    @objc private func refresh() {

        let query = PFUser.query()
        query?.findObjectsInBackground(block: { (objects, err) in
            if let err = err {
                print(err)
            } else if let objects = objects {
                self.users = objects
                    .map { user in
                        if let pfuser = user as? PFUser,
                            pfuser.objectId != PFUser.current()?.objectId {
                            return pfuser
                        }
                        return nil
                    }
                    .flatMap { $0 }
                self.getFollowing()
            }
        })
    }

    private func getFollowing() {
        let query = PFQuery(className: "Likers")
        query.whereKey("Liker", equalTo: PFUser.current()?.objectId ?? "")
        query.findObjectsInBackground(block: { (objects, err) in
            if let err = err {
                print(err)
            } else if let objects = objects {
                self.following = objects.map { $0["Likee"] as? String ?? "" }
                self.tableView.reloadData()
                self.refresher.endRefreshing()
            }
        })
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "All users"
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let user = users?[indexPath.row]
        cell.textLabel?.text = user?.username
        if let userId = user?.objectId, let following = following, following.contains(userId) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let userId = PFUser.current()?.objectId,
            let likedUserId = users?[indexPath.row].objectId else {
            return
        }

        let cell = tableView.cellForRow(at: indexPath)
        let isChecked = cell?.accessoryType == .checkmark
        cell?.accessoryType = isChecked ? .none : .checkmark

        if isChecked {
            let query = PFQuery(className: "Likers")
            query.whereKey("Liker", equalTo: userId)
            query.whereKey("Likee", equalTo: likedUserId)
            query.findObjectsInBackground(block: { (objects, err) in
                if let objects = objects {
                    objects.forEach { object in
                        object.deleteInBackground()
                    }
                }
                self.following = self.following?.filter { $0 != likedUserId }
            })
        } else {
            let liker = PFObject(className: "Likers")
            liker["Liker"] = userId
            liker["Likee"] = likedUserId
            liker.saveInBackground()
        }
    }
}
