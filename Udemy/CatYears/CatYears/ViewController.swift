//
//  ViewController.swift
//  test
//
//  Created by Aliona on 11/07/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        image.layer.cornerRadius = 100
        image.layer.masksToBounds = true
        submitButton.layer.cornerRadius = 13
        submitButton.layer.masksToBounds = true
    }
    
    @IBAction func submit(_ sender: UIButton) {
        if let _ = textField.text,
        let age = Int(textField.text!) {
            label.text = String(age * 7)
        }
    }

}

