//
//  Concentration.swift
//  Concentration
//
//  Created by Aliona Kozlova on 01.05.2020.
//  Copyright © 2020 Aliona Kozlova. All rights reserved.
//

import Foundation

class Concentration {
    
    // MARK: - Vars
    
    private var indexOfTheOneAndOnlyFacedUpCard: Int?
    
    private(set) var cards = [Card]()
    
    private(set) var flipCount = 0
    
    private(set) var score = 0
    
    // MARK: - Initialization
    
    init(numberOfPairsOfCards: Int) {
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        shuffleTheCards()
    }
    
    // MARK: - Private
    
    private func shuffleTheCards() {
        var result = [Card]()
        var cardsCopy = cards
        for _ in cards.indices {
            let randomIndex = cardsCopy.count.arc4random
            result.append(cardsCopy[randomIndex])
            cardsCopy.remove(at: randomIndex)
        }
        cards = result
    }
    
    // MARK: - Public
    
    func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            flipCount += 1
            if let matchIndex = indexOfTheOneAndOnlyFacedUpCard, matchIndex != index {
                if cards[index].identifier == cards[matchIndex].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 2
                } else if cards[index].isSeen {
                    score -= 1
                }
                cards[index].isFaceUp = true
                indexOfTheOneAndOnlyFacedUpCard = nil
            } else {
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfTheOneAndOnlyFacedUpCard = index
            }
        }
    }
    
}

extension Int {
    
    var arc4random: Int {
        return Int(arc4random_uniform(UInt32(self)))
    }
    
}
