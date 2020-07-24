//
//  Card.swift
//  Set
//
//  Created by Aliona Kozlova on 05.05.2020.
//  Copyright © 2020 Aliona Kozlova. All rights reserved.
//

struct Card: Equatable {
    let colorType: CardPropertyType
    let formType: CardPropertyType
    let numberType: CardPropertyType
    let shadingType: CardPropertyType
}

extension Array where Element == Card {
    
    var isSameOrDifferent: Bool {
        let colorsArray = self.map { $0.colorType }
        let formsArray = self.map { $0.formType }
        let numbersArray = self.map { $0.numberType }
        let shadingArray = self.map { $0.shadingType }
        return (colorsArray.isSame || colorsArray.isDifferent) &&
            (formsArray.isSame || formsArray.isDifferent) &&
            (numbersArray.isSame || numbersArray.isDifferent) &&
            (shadingArray.isSame || shadingArray.isDifferent)
    }
    
}
