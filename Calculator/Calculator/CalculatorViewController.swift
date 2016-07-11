//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by Aliona on 26/06/16.
//  Copyright © 2016 ptenster. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    @IBOutlet private weak var operationsPerformed: UILabel!
    @IBOutlet private weak var display: UILabel!
    
    private var userIsInTheMiddleOfTyping = false
    private var brain = CalculatorBrain()
    
    var savedProgram: CalculatorBrain.propertyList?
    @IBAction func save() {
        savedProgram = brain.program
    }
    
    @IBAction func restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
    
    @IBAction func clear() {
        brain.clear()
        display.text = "0"
        operationsPerformed.text = " "
        userIsInTheMiddleOfTyping = false
    }
    
    @IBAction private func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        displayValue = brain.result
        updateOperationsPerformed ()
    }
    
    private func updateOperationsPerformed () {
        if !userIsInTheMiddleOfTyping {
            if brain.isPartialResult {
                operationsPerformed.text = "\(brain.description) ..."
            } else {
                operationsPerformed.text = "\(brain.description) = "
            }
        }
    }
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    @IBAction private func pressButton(sender: UIButton) {
        let currentDigit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyOnDisplay = display.text!
            let newDisplayText = textCurrentlyOnDisplay + currentDigit
            if Double(newDisplayText) != nil {
                display.text = newDisplayText
            }
        } else {
            display.text = currentDigit
        }
        userIsInTheMiddleOfTyping = true
    }
}

