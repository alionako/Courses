//
//  ViewController.swift
//  HowManyFingers
//
//  Created by Aliona on 15/07/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var number: UITextField!
    @IBOutlet weak var result: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func guessButtonTap(_ sender: UIButton) {
        if let enteredNumber = number.text {
            let randomNumber = String(arc4random_uniform(6))
            if enteredNumber == randomNumber {
                result.text = "Bingo! You're right"
            } else {
                result.text = "Sorry, you loose :( My number was " + randomNumber + "."
            }
        }
    }

}

