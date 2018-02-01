import UIKit
import Parse

class FeedTableViewController: UITableViewController {

    var users: [PFUser] = []
    var posts: [PFObject] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        users = []
        posts = []
        tableView.reloadData()

        let query = PFUser.query()
        query?.findObjectsInBackground(block: { (objects, err) in
            if let users = objects {
                self.users = users.flatMap { $0 as? PFUser }
            }
            let likerQuery = PFQuery(className: "Likers")
            likerQuery.whereKey("Liker", equalTo: PFUser.current()?.objectId ?? "")
            likerQuery.findObjectsInBackground(block: { (objects, err) in
                if let liked = objects {
                    let allUsers = self.users
                    self.users = liked.map { liked in
                        return allUsers.first { user in
                            liked["Likee"] as? String == user.objectId
                        }
                    }.flatMap { $0 }
                }
                self.users.forEach { user in
                    let postsQuery = PFQuery(className: "Posts")
                    postsQuery.whereKey("userId", equalTo: user.objectId ?? "")
                    postsQuery.findObjectsInBackground(block: { (objects, err) in
                        if let posts = objects {
                            self.posts.append(contentsOf: posts)
                        }
                        self.tableView.reloadData()
                    })
                }
            })

        })
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "All posts"
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        let currentPost = posts[indexPath.row]
        let image = currentPost["imageFile"] as? PFFile
        image?.getDataInBackground { (data, err) in
            if let data = data, let img = UIImage(data: data) {
                cell.postImage.image = img
            }
        }
        let userName = users.first { $0.objectId == currentPost["userId"] as? String }?.username
        cell.nameLabel.text = userName
        cell.imageLabel.text = currentPost["message"] as? String
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }

    @IBAction func showFeed(segue: UIStoryboardSegue) {
    }
}

