//
//  PlacesViewController.swift
//  Memorable Places
//
//  Created by Aliona on 21/08/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit

var places : [Dictionary<String, String>] = []

class PlacesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var table: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let savedPlaces = UserDefaults.standard.object(forKey: "places") as? [Dictionary<String, String>] {
            places = savedPlaces
        }
        
        table.reloadData()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = places[indexPath.row]["name"]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "openMap", sender: tableView.cellForRow(at: indexPath))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell {
            if let index = table.indexPath(for: cell)?.row,
                let destination = segue.destination as? MapViewController {
                if places.count > index {
                    destination.numberOfPlace = index
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && places.count > indexPath.row {
            places.remove(at: indexPath.row)
            UserDefaults.standard.set(places, forKey: "places")
            tableView.reloadData()
        }
    }

}

