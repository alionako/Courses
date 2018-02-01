//
//  MasterViewController.swift
//  BlogReader
//
//  Created by Aliona on 02/09/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    let APIkey = "AIzaSyAB08ZXJnvsR6rV3yrIjI2Z6_zWPjyE7mY"
    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil


    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    @IBAction func updatePosts(_ sender: Any) {
        if let url = URL(string: "https://www.googleapis.com/blogger/v3/blogs/2399953/posts?key=" + APIkey) {
            let task = URLSession.shared.dataTask(with: url) { data, response, err in
                if err != nil {
                    print(err!)
                } else {
                    if data != nil {
                        do {
                            let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                            if let items = jsonResult?["items"] as? [NSDictionary] {
                                self.deleteItems()
                                self.saveItems(items)
                            }
                        } catch {
                            print("Error")
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    private func deleteItems() {
        
        let context = self.fetchedResultsController.managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entry")
        
        do {
            let results = try context.fetch(request)
            for result in results {
                context.delete(result as! NSManagedObject)
            }
            try context.save()
        } catch {
            print("Error deleting objects")
        }
        
    }
    
    private func saveItems(_ items: [NSDictionary]) {
        for item in items {
            addItem(name: item["title"], contents: item["content"], id: item["id"], author: item["author"])
        }
    }
    
    func addItem(name: Any?, contents: Any?, id: Any?, author: Any?) {
        
        let context = self.fetchedResultsController.managedObjectContext
        
        if let entryName = name as? String,
        let entryContents = contents as? String {
            
            let newEntry = Entry(context: context)
            newEntry.name = entryName
            newEntry.content = entryContents
            
            if let string = ((author as? NSDictionary)?["image"] as? NSDictionary)?["url"] as? String {
                newEntry.imageURL = "http:" + string
            }
            
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
            let object = fetchedResultsController.object(at: indexPath)
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.entry = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let event = fetchedResultsController.object(at: indexPath)
        configureCell(cell, withEntry: event)
        return cell
    }

    func configureCell(_ cell: UITableViewCell, withEntry entry: Entry) {
        cell.textLabel!.text = entry.name
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        if let _ = entry.imageURL, let imageURL = URL(string: entry.imageURL!) {
            if let image = try? UIImage(data: Data(contentsOf: imageURL)) {
                cell.imageView?.image = image
            }
        }
    }

    // MARK: - Fetched results controller

    var fetchedResultsController: NSFetchedResultsController<Entry> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
             let nserror = error as NSError
             print("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }    
    var _fetchedResultsController: NSFetchedResultsController<Entry>? = nil

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
            case .insert:
                tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            case .delete:
                tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            default:
                return
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                tableView.insertRows(at: [newIndexPath!], with: .fade)
            case .delete:
                tableView.deleteRows(at: [indexPath!], with: .fade)
            case .update:
                configureCell(tableView.cellForRow(at: indexPath!)!, withEntry: anObject as! Entry)
            case .move:
                configureCell(tableView.cellForRow(at: indexPath!)!, withEntry: anObject as! Entry)
                tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

}
