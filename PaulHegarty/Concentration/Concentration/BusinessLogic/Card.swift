//
//  Card.swift
//  Concentration
//
//  Created by Aliona Kozlova on 01.05.2020.
//  Copyright © 2020 Aliona Kozlova. All rights reserved.
//

import Foundation

struct Card {
    
    var isFaceUp = false {
        didSet {
            if isFaceUp {
                isSeen = true
            }
        }
    }
    var isMatched = false
    var isSeen = false
    var identifier: Int
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
    
    static var identifierFactory = 0
    
    static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
}
