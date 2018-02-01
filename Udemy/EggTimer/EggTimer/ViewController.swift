//
//  ViewController.swift
//  EggTimer
//
//  Created by Aliona on 22/07/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var timer = Timer()
    var time = 210
    
    @IBOutlet weak var value: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pause(_ sender: UIBarButtonItem) {
        timer.invalidate()
    }

    @IBAction func start(_ sender: UIBarButtonItem) {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
    }
    
    @IBAction func decreaseTime(_ sender: UIBarButtonItem) {
        if time > 10 {
            time -= 10
            value.text = String(time)
        }
    }
    
    @IBAction func increaseTime(_ sender: UIBarButtonItem) {
        time += 10
        value.text = String(time)
    }
    
    @IBAction func resetTimer(_ sender: UIBarButtonItem) {
        timer.invalidate()
        time = 210
        value.text = String(time)
    }
    
    func runTimer() {
        if time > 0 {
            time -= 1
            value.text = String(time)
        } else {
            timer.invalidate()
        }
    }
}

