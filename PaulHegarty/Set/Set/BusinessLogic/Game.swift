//
//  Game.swift
//  Set
//
//  Created by Aliona Kozlova on 02.05.2020.
//  Copyright © 2020 Aliona Kozlova. All rights reserved.
//

import Foundation

private struct Constants {
    static let selectedCardsMax = 3
    static let initialCardsCount = 12
}

class Game {
    
    private var allCards: [Card] = []
    private var cardCount = Constants.initialCardsCount
    
    private(set) var cards: [Card] = []
    private(set) var selectedCards: [Card] = []
    private(set) var matchedCards: [Card] = []
    

    init() {
        for color in CardPropertyType.allValues {
            for form in CardPropertyType.allValues {
                for number in CardPropertyType.allValues {
                    for shading in CardPropertyType.allValues {
                        allCards.append(Card(colorType: color, formType: form, numberType: number, shadingType: shading))
                    }
                }
            }
        }
        allCards.shuffle()
        addCardsFromAll(count: cardCount)
    }
    
}

extension Game {
    
    var hasMoreCards: Bool {
        return !allCards.isEmpty
    }
    
    func selectCard(_ card: Card) {
        let isSelected = selectedCards.contains(card)
        if !isSelected, selectedCards.count == Constants.selectedCardsMax {
            selectedCards = [card]
        } else if isSelected {
            selectedCards = selectedCards.filter { $0 != card }
        } else {
            selectedCards += [card]
        }
        if selectedCards.count == Constants.selectedCardsMax, checkIfIsSet(cards: selectedCards) {
            matchedCards = selectedCards
        }
    }
    
    func addCards() {
        clearMatchedCards()
        addCardsFromAll(count: Constants.selectedCardsMax)
    }
    
    func shuffleCards() {
        cards.shuffle()
    }
    
    func clearMatchedCards() {
        let nonmatchedCards = cards.filter { !matchedCards.contains($0) }
        cards = nonmatchedCards
        matchedCards = []
    }

}

private extension Game {
    
    func checkIfIsSet(cards: [Card]) -> Bool {
        return cards.isSameOrDifferent
    }
    
    func addCardsFromAll(count: Int) {
        for _ in 0..<count {
            cards += [allCards.popLast()].compactMap { $0 }
        }
    }
    
}
