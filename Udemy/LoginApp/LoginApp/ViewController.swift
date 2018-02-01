//
//  ViewController.swift
//  LoginApp
//
//  Created by Aliona on 27/08/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    var context : NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            context = appDelegate.persistentContainer.viewContext
            if let username = getUser()?.value(forKey: "name") {
                setLabel(username as? String)
                loggeIn(true)
            } else {
                loggeIn(false)
            }
        }
    }
    
    private func getUser() -> NSManagedObject? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AppUser")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context?.fetch(request) as! [NSManagedObject]
            
            if results.count > 0 {
                return results.last
            }
            
        } catch {
            print("Error fetching")
        }
        
        return nil
    }
    
    @IBAction func logIn(_ sender: UIButton) {
        
        let name = login.text
        let pass = password.text
        
        if sender.titleLabel?.text == "Log in" {
            
            if (name?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty)! || (pass?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty)!  {
                label.text = "Please fill in both fields!"
                label.isHidden = false
            } else {
                let user = NSEntityDescription.insertNewObject(forEntityName: "AppUser", into: context!)
                user.setValue(name, forKey: "name")
                user.setValue(pass, forKey: "pass")
                
                do {
                    try context?.save()
                    print("Save success")
                    sender.setTitle("Change name", for: .normal)
                    setLabel(name)
                    loggeIn(true)
                } catch {
                    print("Error saving context")
                }
            }
            
        } else {
            
            if (name?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty)! {
                label.text = "Please fill in the new name!"
                label.isHidden = false
            } else {
                if let user = getUser() {
                
                    user.setValue(name, forKey: "name")
                    user.setValue(pass, forKey: "pass")
                    
                    do {
                        try context?.save()
                        print("Save success")
                        sender.setTitle("Change name", for: .normal)
                        setLabel(name)
                    } catch {
                        print("Error saving context")
                    }
                }
            }
            
        }
    }
    @IBAction func logOut(_ sender: Any) {
        
        if let user = getUser() {
            
            context?.delete(user)
            
            do {
                try context?.save()
                print("Save success")
                loginButton.setTitle("Log in", for: .normal)
                loggeIn(false)
            } catch {
                print("Error saving context")
            }
        }
    }

    private func loggeIn(_ bool: Bool) {
        password.isHidden = bool
        logoutButton.isHidden = !bool
        label.isHidden = !bool
        let title = bool ? "Change name" : "Log in"
        loginButton.setTitle(title, for: .normal)
        login.text = ""
        password.text = ""
    }
    
    private func setLabel(_ name: String?) {
        if let name = name {
            label.text = "Hello, " + name + "!"
        }
    }
}

