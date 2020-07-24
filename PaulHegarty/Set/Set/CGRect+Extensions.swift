//
//  CGRect+Extensions.swift
//  Set
//
//  Created by Aliona Kozlova on 07.05.2020.
//  Copyright © 2020 Aliona Kozlova. All rights reserved.
//

import CoreGraphics

extension CGRect {
    
    var topCenter: CGPoint {
        return CGPoint(x: origin.x + size.width / 2, y: origin.y)
    }
    
    var rightCenter: CGPoint {
        return CGPoint(x: size.width, y: origin.y + size.height / 2)
    }
    
    var bottomCenter: CGPoint {
        return CGPoint(x: origin.x + size.width / 2, y: origin.y + size.height)
    }
    
    var leftCenter: CGPoint {
        return CGPoint(x: origin.x, y: origin.y + size.height / 2)
    }
    
    var center: CGPoint {
        return CGPoint(x: origin.x + size.width / 2, y: origin.y + size.height / 2)
    }
    
    func rectSubstracting(_ points: CGFloat) -> CGRect {
        return CGRect(x: origin.x + points,
                          y: origin.y + points,
                          width: size.width - points * 2,
                          height: size.height - points * 2)
    }
    
}
