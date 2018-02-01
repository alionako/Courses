//
//  ViewController.swift
//  TicTacToe
//
//  Created by Aliona on 20/08/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit

enum Symbols {
    case zero, cross, none
}

class ViewController: UIViewController {

    var pendingSymbol : Symbols = .cross
    var gameState : [Symbols] = [.none, .none, .none,
                                 .none, .none, .none,
                                 .none, .none, .none]
    let winningCombinations = [
        [0,1,2],
        [3,4,5],
        [6,7,8],
        [0,3,6],
        [1,4,7],
        [2,5,8],
        [0,4,8],
        [2,4,6]
    ]
    
    
    @IBOutlet weak var label: UILabel!
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        gameState[sender.tag] = pendingSymbol
        if pendingSymbol == .cross {
            sender.setTitle("Cross", for: .normal)
            pendingSymbol = .zero
        } else {
            sender.setTitle("Zero", for: .normal)
            pendingSymbol = .cross
        }
        sender.isEnabled = false
        checkBoard()
    }

    func checkBoard() {
        for combination in winningCombinations {
            if gameState[combination[0]] != .none &&
            gameState[combination[0]] == gameState[combination[1]] &&
                gameState[combination[1]] == gameState[combination[2]] {
                let winner = (gameState[combination[0]] == .zero) ? "ZERO" : "CROSS"
                label.text = "The winner is \(winner)!"
                for view in self.view.subviews {
                    if (view as? UIButton)?.titleLabel?.text != "Restart game" {
                        view.isUserInteractionEnabled = false
                    }
                }
            }
        }
    }
    
    @IBAction func restart(_ sender: UIButton) {
        self.loadView()
        gameState = [.none, .none, .none,
                     .none, .none, .none,
                     .none, .none, .none]
        pendingSymbol = .cross
    }
}

