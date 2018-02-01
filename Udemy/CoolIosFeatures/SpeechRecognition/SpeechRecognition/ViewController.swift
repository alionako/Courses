//
//  ViewController.swift
//  SpeechRecognition
//
//  Created by Aliona on 01/02/2018.
//  Copyright © 2018 Aliona. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController, SFSpeechRecognizerDelegate {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!

    let speechRecognizer = SFSpeechRecognizer()!
    let audioEngine = AVAudioEngine()

    var recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask = SFSpeechRecognitionTask()
    var tapInstalled = false

    override func viewDidLoad() {
        super.viewDidLoad()

        speechRecognizer.delegate = self
        button.isEnabled = false

        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            OperationQueue.main.addOperation({ [weak self] in

                switch authStatus {
                case .authorized:
                    self?.button.isEnabled = true

                case .denied:
                    self?.button.isEnabled = false
                    self?.button.setTitle("User denied access to speech recognition", for: .disabled)

                case .restricted:
                    self?.button.isEnabled = false
                    self?.button.setTitle("Speech recognition is restricted on this device", for: .disabled)

                case .notDetermined:
                    self?.button.isEnabled = false
                    self?.button.setTitle("Speech recognition has not yet been authorised", for: .disabled)
                }
            })
        }
    }

    @IBAction func recognizeFromFile(_ sender: Any) {
        label.text = ""
        if let path = Bundle.main.path(forResource: "test", ofType: "wav") {
            let url = URL(fileURLWithPath: path)
            let recognizer = SFSpeechRecognizer()
            let request = SFSpeechURLRecognitionRequest(url: url)
            recognizer?.recognitionTask(with: request, resultHandler: { [weak self] (result, err) in
                if let result = result {
                    self?.label.text = result.bestTranscription.formattedString
                }
            })
        }
    }

    @IBAction func startRecognition(_ sender: Any) {

        if audioEngine.isRunning {
            resetAudioEngine()
        } else {

            button.setTitle("Stop Recording", for: [])
            label.text = ""

            do {
                let audioSession = AVAudioSession.sharedInstance()
                try audioSession.setCategory(AVAudioSessionCategoryRecord)
                try audioSession.setMode(AVAudioSessionModeMeasurement)
                try audioSession.setActive(true, with: .notifyOthersOnDeactivation)

                let inputNode = audioEngine.inputNode
                recognitionRequest.shouldReportPartialResults = true
                recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { [weak self] (result, error) in

                    if let result = result {

                        self?.label.text = result.bestTranscription.formattedString

                        if result.isFinal {
                            self?.resetAudioEngine()
                            inputNode.removeTap(onBus: 0)
                        }
                    }
                })

                let recordingFormat = inputNode.outputFormat(forBus: 0)
                if !tapInstalled {
                    inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat, block: { [weak self] (buffer, when) in

                        self?.recognitionRequest.append(buffer)
                    })
                    tapInstalled = true
                }

                audioEngine.prepare()
                try audioEngine.start()

            } catch {
                print("Oops! Something went wrong :(")
            }
        }
    }

    private func resetAudioEngine() {
        audioEngine.stop()
        recognitionRequest.endAudio()
        recognitionTask.cancel()

        button.setTitle("Start Recording", for: [])
    }
}

