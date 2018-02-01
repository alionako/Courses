//
//  MatchesCell.swift
//  ParseStarterProject-Swift
//
//  Created by Aliona on 21/01/2018.
//  Copyright © 2018 Parse. All rights reserved.
//

import UIKit
import Parse

class MatchesCell: UITableViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var textField: UITextField!

    var user: PFUser?
    
    @IBAction func sendButtonPress(_ sender: Any) {
        let message = PFObject(className: Constants.messageObjectKey)
        message[Constants.fromKey] = PFUser.current()?.objectId ?? ""
        message[Constants.toKey] = user?.objectId ?? ""
        message[Constants.messageKey] = textField?.text ?? ""
        message.saveInBackground { [weak self] (success, err) in
            if success {
                self?.textField.text = nil
            }
        }
    }
}
