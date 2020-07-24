//
//  Int+RandomNumber.swift
//  Set
//
//  Created by Aliona Kozlova on 05.05.2020.
//  Copyright © 2020 Aliona Kozlova. All rights reserved.
//

import Foundation

extension Int {
    
    var random: Int {
        return Int(arc4random_uniform(UInt32(self)))
    }
    
}
