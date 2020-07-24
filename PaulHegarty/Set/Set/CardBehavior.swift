//
//  CardBehavior.swift
//  Set
//
//  Created by Aliona Kozlova on 25.05.2020.
//  Copyright © 2020 Aliona Kozlova. All rights reserved.
//

import UIKit

class CardBehavior: UIDynamicBehavior {
    
    private lazy var collisionBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }()
    
    private lazy var itemBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.elasticity = 1
        behavior.allowsRotation = false
        behavior.resistance = 0
        return behavior
    }()
    
    private func addPushBehavior(_ item: UIDynamicItem) {
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        push.angle = (2*CGFloat.pi).arc4random
        push.magnitude = CGFloat(2.0).arc4random + 1.0
        push.action = { [unowned push, weak self] in
            self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
    }
    
    func addItem(_ item: UIDynamicItem) {
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
        addPushBehavior(item)
    }
    
    func removeItem(_ item: UIDynamicItem) {
        collisionBehavior.removeItem(item)
        itemBehavior.removeItem(item)
    }
    
    override init() {
        super.init()
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehavior)
    }
    
    convenience init(animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }

}
