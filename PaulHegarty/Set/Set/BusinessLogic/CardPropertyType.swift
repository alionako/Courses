//
//  CardType.swift
//  Set
//
//  Created by Aliona Kozlova on 05.05.2020.
//  Copyright © 2020 Aliona Kozlova. All rights reserved.
//

import Foundation

enum CardPropertyType: Int {
    case one
    case two
    case three
    
    static var allValues: [CardPropertyType] = [.one, .two, .three]
}

extension Array where Element == CardPropertyType {

    var isSame: Bool {
        return Set(self).count == 1
    }
    
    var isDifferent: Bool {
        return Set(self).count == self.count
    }
    
}
