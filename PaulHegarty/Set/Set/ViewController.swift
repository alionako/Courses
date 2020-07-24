//
//  ViewController.swift
//  Set
//
//  Created by Aliona Kozlova on 01.05.2020.
//  Copyright © 2020 Aliona Kozlova. All rights reserved.
//

import UIKit

class SetViewController: UIViewController {
    
    private lazy var game = Game()

    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet var buttons: [UIButton]! {
        didSet {
            buttons.forEach {
                $0.layer.cornerRadius = 10
                $0.layer.borderWidth = 2
            }
        }
    }
    
    @IBAction func touchButton(_ sender: UIButton) {
        setSelected(button: sender)
    }
    
    @IBAction func startNewGame(_ sender: Any) {
        game = Game()
        updateViewFromViewModel()
    }
    
    @IBAction func addMoreCards(_ sender: Any) {
        game.addCards()
        updateViewFromViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromViewModel()
    }
    
    private func setSelected(button: UIButton) {
        if let index = buttons.firstIndex(of: button) {
            game.selectCard(at: index)
        }
        updateViewFromViewModel()
    }
    
    private func updateViewFromViewModel() {
        let cards = game.cards
        for index in buttons.indices {
            if cards.indices.contains(index) {
                updateButton(button: buttons[index], with: game.cards[index])
            } else {
                buttons[index].setAttributedTitle(nil, for: .normal)
                buttons[index].backgroundColor = #colorLiteral(red: 0.3529411765, green: 0.7843137255, blue: 0.9803921569, alpha: 1)
                buttons[index].layer.borderColor = #colorLiteral(red: 0.3529411765, green: 0.7843137255, blue: 0.9803921569, alpha: 1).cgColor
            }
        }
        newGameButton.isEnabled = cards.count > buttons.count
    }
    
    private func updateButton(button: UIButton, with card: Card) {
        if card.isMatched {
            button.setTitle(nil, for: .normal)
            button.layer.borderColor = UIColor.green.cgColor
        } else {
            let title = NSAttributedString(string: titleString(for: card), attributes: attributes(for: card))
            button.setAttributedTitle(title, for: .normal)
            button.layer.borderColor = card.isSelected ? UIColor.blue.cgColor : UIColor.white.cgColor
        }
        button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    private func titleString(for card: Card) -> String {
        let char: Character
        switch card.formType {
        case .one:
            char = "▲"
        case .two:
            char = "◼︎"
        case.three:
            char = "●"
        }
        var title: String = ""
        for _ in 0...card.numberType.rawValue {
            title = title.appending(String(char))
        }
        return title
    }
    
    private func attributes(for card: Card) -> [NSAttributedString.Key: Any] {
        let color, strokeColor, foregroundColor: UIColor
        switch card.colorType {
        case .one:
            color = .magenta
        case .two:
            color = .green
        case.three:
            color = .red
        }
        var strokeWidth = 0
        switch card.shadingType {
        case .one:
            strokeColor = color
            foregroundColor = .clear
            strokeWidth = 4
        case .two:
            strokeColor = color.withAlphaComponent(0.25)
            foregroundColor = strokeColor
        case .three:
            strokeColor = color
            foregroundColor = color
        }
        return [
            .strokeColor: strokeColor,
            .strokeWidth: strokeWidth,
            .foregroundColor: foregroundColor,
            .font: UIFont.systemFont(ofSize: 20)
        ]
    }
    
}

