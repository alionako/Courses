//
//  KeyboardViewController.swift
//  MyNiceKeyboard
//
//  Created by Aliona on 28/01/2018.
//  Copyright © 2018 Aliona. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    @IBOutlet var nextKeyboardButton: UIButton!
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }

    @objc func buttonPress() {
        let kittenWords = ["Meow", "Purrr", "Meh", "Yowl", "Beep", "Hiss", "Burble", "Wail"]
        let index = Int(arc4random_uniform(UInt32(kittenWords.count)))
        let currentWord = kittenWords[index]
        let proxy = textDocumentProxy as UITextDocumentProxy
        proxy.insertText(currentWord)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let kittenButton = UIButton(type: .system)
        kittenButton.frame = CGRect(x: 150, y: 40, width: 120, height: 120)
        kittenButton.setBackgroundImage(UIImage(named: "kitten"), for: [])
        kittenButton.addTarget(self, action: #selector(KeyboardViewController.buttonPress), for: .touchUpInside)
        view.addSubview(kittenButton)

        // Perform custom UI setup here
        self.nextKeyboardButton = UIButton(type: .system)
        
        self.nextKeyboardButton.setTitle(NSLocalizedString("🌎", comment: "Title for 'Next Keyboard' button"), for: [])
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        
        view.addSubview(self.nextKeyboardButton)

        view.backgroundColor = .white

        self.nextKeyboardButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.nextKeyboardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }

}
