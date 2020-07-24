//
//  ViewController.swift
//  Set
//
//  Created by Aliona Kozlova on 01.05.2020.
//  Copyright © 2020 Aliona Kozlova. All rights reserved.
//

import UIKit

class SetViewController: UIViewController {
    
    // MARK: - Private vars
    
    private lazy var game = Game()
    
    private var grid: Grid {
        var grid = Grid(layout: Grid.Layout.aspectRatio(1.5))
        grid.frame = gridView.bounds
        grid.cellCount = game.cards.count
        return grid
    }
    
    private lazy var animator = UIDynamicAnimator(referenceView: self.view)
    private lazy var cardBehavior = CardBehavior(animator: self.animator)
    
    // MARK: - IBOutlets

    @IBOutlet private weak var gridView: UIView!
    @IBOutlet private weak var buttonStackView: UIView!
    
    // MARK: - IBActions

    @IBAction func startNewGame(_ sender: Any) {
        game = Game()
        gridView.subviews.forEach { $0.removeFromSuperview() }
        updateViewFromViewModel()
    }
    
    @IBAction func shuffleCards(_ sender: Any) {
        game.shuffleCards()
        updateViewFromViewModel()
    }
    
    @IBAction func addMoreCards(_ sender: Any) {
        if game.hasMoreCards {
            game.addCards()
            updateViewFromViewModel()
        }
    }
    
    @objc private func setSelected(recognizer: UITapGestureRecognizer) {
        if let card = (recognizer.view as? CardView)?.card {
            game.selectCard(card)
            updateViewFromViewModel()
        }
    }
    
    // MARK: - Override
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateViewFromViewModel()
    }
    
}

// MARK: - Update from view model

private extension SetViewController {
    
    func updateViewFromViewModel() {
        let currentCardCount = gridView.subviews.count
        animateLayoutCurrentCards(currentCardCount: currentCardCount)
        animateNewCardsAddition(currentCardCount: currentCardCount)
        animateMatchingCards()
    }
    
}

// MARK: - Grid layout

private extension SetViewController {
    
    func animateLayoutCurrentCards(currentCardCount: Int) {
        UIView.animate(withDuration: 0.2) {
            self.layoutCurrentCards(currentCardCount: currentCardCount)
        }
    }
    
    func layoutCurrentCards(currentCardCount: Int) {
        for index in 0..<currentCardCount {
            if let frame = grid[index], let cardView = gridView.subviews[index] as? CardView {
                cardView.frame = frame
                updateCardView(cardView: cardView, with: game.cards[index])
            }
        }
    }
    
}

// MARK: - Dealing cards animation

private extension SetViewController {
    
    func animateNewCardsAddition(currentCardCount: Int) {
        let cards = game.cards
        guard currentCardCount < cards.count else {
            return
        }
        for index in currentCardCount..<cards.count {
            if let frame = grid[index] {
                let cardView = CardView(frame: frame)
                addGestureRecognizer(for: cardView)
                let indexForDelay = index - currentCardCount
                animateCardAddition(cardView: cardView, card: game.cards[index], delay: Double(indexForDelay) * 0.3)
            }
        }
    }
    
    func animateCardAddition(cardView: CardView, card: Card, delay: Double) {
        let initialFrame = cardView.frame
        cardView.isFlipped = true
        gridView.addSubview(cardView)
        cardView.frame = buttonStackView.frame
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5,
                                                       delay: delay,
                                                       options: .curveLinear,
                                                       animations: { cardView.frame = initialFrame },
                                                       completion: { [weak self] position in
                                                        if position == .end {
                                                            self?.animateCardFlip(cardView: cardView, card: card)
                                                        }
        })
    }
    
    func animateCardFlip(cardView: CardView, card: Card) {
        UIView.transition(with: cardView,
                          duration: 0.2,
                          options: [.transitionFlipFromLeft],
                          animations: { [weak self] in
                              self?.updateCardView(cardView: cardView, with: card)
                              cardView.isFlipped = false
                          },
                          completion: nil)
    }
    
}

// MARK: - Matching cards

private extension SetViewController {
    
    func animateMatchingCards() {
        let matchedCards = gridView.subviews.filter {
            if let card = ($0 as? CardView)?.card, game.matchedCards.contains(card) {
                return true
            }
            return false
        }
        for index in 0..<matchedCards.count {
            let cardView = matchedCards[index] as? CardView
            if let item = cardView {
                cardBehavior.addItem(item)
            }
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5,
                                                           delay: 0.5,
                                                           options: [],
                                                           animations: {
                                                            cardView?.borderColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                                                            cardView?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                                                           },
                                                           completion: { position in
                                                                if position == .end {
                                                                    animateMovingToStack(cardView: cardView)
                                                                }
                                                        })
        }
        
        func animateMovingToStack(cardView: CardView?) {
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5,
                                                           delay: 0,
                                                           options: .curveLinear,
                                                           animations: {
                                                            cardView?.frame = self.buttonStackView.frame
            },
                                                           completion: { [weak self] position in
                                                            if position == .end {
                                                                cardView?.removeFromSuperview()
                                                                self?.game.clearMatchedCards()
                                                                self?.updateViewFromViewModel()
                                                            }
            })
        }
        
    }
    
}


// MARK: - Setting card

private extension SetViewController {
    
    func addGestureRecognizer(for cardView: CardView) {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(setSelected(recognizer:)))
        cardView.addGestureRecognizer(tapRecognizer)
    }
    
    func updateCardView(cardView: CardView, with card: Card) {
        cardView.borderColor = game.selectedCards.contains(card) ? #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.09803921569)
        cardView.card = card
    }
    
}


extension CGFloat {
    
    var arc4random: CGFloat {
        return CGFloat(arc4random_uniform(UInt32(self)))
    }
}
