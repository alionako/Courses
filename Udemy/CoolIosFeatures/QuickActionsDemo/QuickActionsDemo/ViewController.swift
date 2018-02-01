//
//  ViewController.swift
//  QuickActionsDemo
//
//  Created by Aliona on 30/01/2018.
//  Copyright © 2018 Aliona. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    var shortCutItemType: String?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setView()
    }

    func setView() {
        switch shortCutItemType {
        case "aliona.QuickActionsDemo.heart"?:
            imageView.image = #imageLiteral(resourceName: "heart")
            label.text = "Love with this app!"
        case "aliona.QuickActionsDemo.star"?:
            imageView.image = #imageLiteral(resourceName: "star")
            label.text = "See the beauty with this app!"
        case "aliona.QuickActionsDemo.cloud"?:
            imageView.image = #imageLiteral(resourceName: "cloud")
            label.text = "Dream with this app!"
        default:
            print(shortCutItemType)
        }
    }
}

