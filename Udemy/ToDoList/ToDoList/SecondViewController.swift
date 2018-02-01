//
//  SecondViewController.swift
//  ToDoList
//
//  Created by Aliona on 23/07/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    // MARK - Add items

    @IBAction func addItem(_ sender: Any) {
        if let text = textField.text {
            UserDefaults.standard.value(forKey: <#T##String#>)
            if let list = UserDefaults.standard.array(forKey: "ToDoList") {
                var newList = list
                newList.append(text)
                UserDefaults.standard.set(newList, forKey: "ToDoList")
            } else {
                UserDefaults.standard.set([text], forKey: "ToDoList")
            }
        }
        textField.text = ""
        textField.resignFirstResponder()
        tabBarController?.selectedIndex = 0
    }

}

