//
//  ViewController.swift
//  SoundShaker
//
//  Created by Aliona on 27/08/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var player = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.subtype == UIEventSubtype.motionShake {
            playRandomSound()
        }
    }
    
    func playRandomSound() {
        
        let rand = String(arc4random_uniform(5) + 1)
        let audioPath = Bundle.main.path(forResource: rand, ofType: "mp3")
        
        do {
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
            player.play()    
        } catch {
            print("Player error")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

