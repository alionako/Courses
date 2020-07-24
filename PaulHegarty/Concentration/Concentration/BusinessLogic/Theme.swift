//
//  Theme.swift
//  Concentration
//
//  Created by Aliona Kozlova on 01.05.2020.
//  Copyright © 2020 Aliona Kozlova. All rights reserved.
//

import UIKit

struct Theme {
    let emojis: [String]
    let backgroundColor: UIColor
    let cardColor: UIColor
}

extension Theme {
    
    static var simple = Theme(
        emojis: ["😁", "😚", "🤩", "🥰", "😩", "😎", "🤯", "🤓", "😷", "🥺", "🥱", "🤐"],
        backgroundColor: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1),
        cardColor: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
    )
    
    static var halloween = Theme(
        emojis: ["🧟‍♀️", "🧛🏻‍♂️", "🧚🏽‍♀️", "🌑", "🍭", "🦇", "🕷", "👽", "🎃", "💀", "☠️", "🧙🏻‍♀️"],
        backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
        cardColor: #colorLiteral(red: 1, green: 0.5843137255, blue: 0, alpha: 1)
    )
    
    static var nature = Theme(
        emojis: ["🦋", "🐠", "🐳", "🌳", "🌲", "🍁", "🦌", "🦚", "⛈", "❄️", "🌊", "🦥"],
        backgroundColor: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1),
        cardColor: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
    )
    
    static var allThemes: [Theme] = [.simple, .nature, .halloween]
    
}
