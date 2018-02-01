//
//  ViewController.swift
//  TimesTable
//
//  Created by Aliona on 23/07/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var table: UITableView!
    
    @IBAction func slider(_ sender: UISlider) {
        table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "Cell")
        let value = Int(slider.value)
        cell.textLabel?.text = "\(value) x \(indexPath.row + 1) = \((indexPath.row + 1) * value)"
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

