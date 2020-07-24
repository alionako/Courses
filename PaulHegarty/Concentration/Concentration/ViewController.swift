//
//  ViewController.swift
//  Concentration
//
//  Created by Aliona Kozlova on 01.05.2020.
//  Copyright © 2020 Aliona Kozlova. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet private weak var flipCountLabel: UILabel!
    @IBOutlet private weak var newGameButton: UIButton!
    @IBOutlet private weak var scoreLabel: UILabel!
    
    // MARK: - Vars
    
    private lazy var game = Concentration(numberOfPairsOfCards: pairsCount)
    
    private lazy var theme = Theme.allThemes[Theme.allThemes.count.arc4random]
    
    private var emojiDictionary = [Int: String]()
    
    private var pairsCount: Int {
        return (cardButtons.count + 1) / 2
    }
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromViewModel()
        setupTheme()
    }
    
    // MARK: - Actions
    
    @IBAction private func didTapButton(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromViewModel()
        } else {
            print("This button is not in the buttons array!")
        }
    }
    
    @IBAction private func startNewGame(_ sender: UIButton) {
        game = Concentration(numberOfPairsOfCards: pairsCount)
        theme = Theme.allThemes[Int(arc4random_uniform(UInt32(Theme.allThemes.count)))]
        updateViewFromViewModel()
        setupTheme()
    }
    
    private func updateViewFromViewModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : theme.cardColor
            }
        }
        flipCountLabel.text = "FlipCount: \(game.flipCount)"
        scoreLabel.text = "\(game.score)"
    }
    
    private func setupTheme() {
        emojiDictionary = [:]
        var emojiChoises = theme.emojis
        for card in game.cards {
            let identifier = card.identifier
            if emojiDictionary[identifier] == nil, emojiChoises.count > 0 {
                let index = Int(arc4random_uniform(UInt32(emojiChoises.count)))
                emojiDictionary[identifier] = emojiChoises[index]
                emojiChoises.remove(at: index)
            }
        }
        view.backgroundColor = theme.backgroundColor
        flipCountLabel.textColor = theme.cardColor
        scoreLabel.textColor = theme.cardColor
        newGameButton.setTitleColor(theme.cardColor, for: .normal)
    }
    
    private func emoji(for card: Card) -> String {
        return emojiDictionary[card.identifier] ?? "?"
    }
    
}

