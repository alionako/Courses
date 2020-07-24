//
//  CardType.swift
//  Set
//
//  Created by Aliona Kozlova on 05.05.2020.
//  Copyright © 2020 Aliona Kozlova. All rights reserved.
//

import Foundation

enum CardProperty: Int {
    case one
    case two
    case three
}

extension Array where Element == CardProperty {

    var isSame: Bool {
        return Set(self).count == 1
    }
    
    var isDifferent: Bool {
        return Set(self).count == self.count
    }
    
}
