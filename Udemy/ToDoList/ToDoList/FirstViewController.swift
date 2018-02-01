//
//  FirstViewController.swift
//  ToDoList
//
//  Created by Aliona on 23/07/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var list : [String]?
    
    @IBOutlet weak var table: UITableView!
    
    // MARK - ViewController lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        list = UserDefaults.standard.array(forKey: "ToDoList") as? [String]
        table.reloadData()
    }

    // MARK - TableView methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = list?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let list = UserDefaults.standard.array(forKey: "ToDoList") as? [String] {
                var modifiedList = list
                modifiedList.remove(at: indexPath.row)
                UserDefaults.standard.set(modifiedList, forKey: "ToDoList")
            }
            self.viewDidAppear(false)
        }
    }
    
    // MARK - Edit button
    
    @IBAction func edit(_ sender: Any) {
    }

}

