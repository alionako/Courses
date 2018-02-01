//
//  ViewController.swift
//  AudioPlayer
//
//  Created by Aliona on 27/08/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var player = AVAudioPlayer()
    var timer = Timer()
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var playButton: UIBarButtonItem!
    @IBOutlet weak var pauseButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let audioPath = Bundle.main.path(forResource: "1", ofType: "mp3")
        do {
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
            slider.maximumValue = Float(player.duration)
        } catch {
            print("Player error")
        }
    }

    @IBAction func decreaseVolume(_ sender: Any) {
        player.volume -= 1.0
    }
    
    @IBAction func increaseVolume(_ sender: Any) {
        player.volume += 1.0
    }
    
    @IBAction func slide(_ sender: UISlider) {
        player.currentTime = TimeInterval(sender.value)
    }
    
    @IBAction func play(_ sender: Any) {
        player.play()
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(upd), userInfo: nil, repeats: true)
    }
    
    func upd() {
        slider.value = Float(player.currentTime)
    }
    
    @IBAction func pause(_ sender: Any) {
        player.pause()
    }
}

