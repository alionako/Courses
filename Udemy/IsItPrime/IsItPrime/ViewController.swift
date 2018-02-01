//
//  ViewController.swift
//  IsItPrime
//
//  Created by Aliona on 21/07/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var result: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func check(_ sender: UIButton) {
        
        var text = ""
        
        if let txt = textField.text,
            let number = Int(txt) {
            
            if isPrime(number) {
                text = "\(number) is prime!"
            } else {
                text = "\(number) is not prime"
            }
        } else {
            text = "Please enter a number!"
        }
        result.text = text
    }

    func isPrime(_ number: Int) -> Bool {
        
        if number == 1 {
            return false
        }
        
        for i in 2..<number {
            if number % i == 0 {
                return false
            }
        }
        
        return true
    }
    
}

