//
//  CardView.swift
//  Set
//
//  Created by Aliona Kozlova on 06.05.2020.
//  Copyright © 2020 Aliona Kozlova. All rights reserved.
//

import UIKit

private struct Constants {
    static let cardWidthMultiplier: CGFloat = 0.3
    static let cardHeightMultiplier: CGFloat = 0.8
    static let cardSpacingMultiplier: CGFloat = 0.05
    static let inset: CGFloat = 3
    static let cornerRadus: CGFloat = 10
    static let selectedBorderWidth: CGFloat = 2
    static let defaultBorderWidth: CGFloat = 1
    static let defaultColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.09803921569)
}

class CardView: UIView {
    
    var card: Card? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var borderColor: UIColor = Constants.defaultColor {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var isFlipped = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func setNeedsDisplay() {
        self.subviews.forEach {
            $0.removeFromSuperview()
        }
        super.setNeedsDisplay()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
    }

    override func draw(_ rect: CGRect) {
        let drawingRect = rect.rectSubstracting(Constants.inset)
        let path = UIBezierPath(roundedRect: drawingRect, cornerRadius: Constants.cornerRadus)
        let color = isFlipped ? #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        color.setFill()
        path.fill()
        if !isFlipped {
            addShapeViews(for: drawingRect)
            addBorder(for: path)
        }
    }
    
}

// MARK: - Adding shapes

extension CardView {

    func addShapeViews(for rect: CGRect) {
        switch card?.numberType {
        case .one:
            addShape(for: rect, center: rect.center)
        case .two:
            let shapeHalfWidth = getShapeSize(for: rect).width / 2
            let spacingWidth = rect.size.width * Constants.cardSpacingMultiplier
            let leftCardCenterX = rect.center.x - shapeHalfWidth - spacingWidth
            let rightCardCenterX = rect.center.x + shapeHalfWidth + spacingWidth
            addShape(for: rect, center: CGPoint(x: leftCardCenterX, y: rect.center.y))
            addShape(for: rect, center: CGPoint(x: rightCardCenterX, y: rect.center.y))
        case .three:
            let shapeWidth = getShapeSize(for: rect).width
            let spacingWidth = rect.size.width * Constants.cardSpacingMultiplier
            let leftCardCenterX = rect.center.x - shapeWidth - spacingWidth
            let rightCardCenterX = rect.center.x + shapeWidth + spacingWidth
            addShape(for: rect, center: CGPoint(x: leftCardCenterX, y: rect.center.y))
            addShape(for: rect, center: rect.center)
            addShape(for: rect, center: CGPoint(x: rightCardCenterX, y: rect.center.y))
        default:
            break
        }
    }
    
    private func addShape(for rect: CGRect, center: CGPoint) {
        let shapeView = getShapeView(for: rect)
        shapeView.center = center
        addSubview(shapeView)
    }
    
    private func getShapeView(for rect: CGRect) -> ShapeView {
        let frame = CGRect(origin: .zero, size: getShapeSize(for: rect))
        let shapeView = ShapeView(frame: frame)
        shapeView.card = card
        return shapeView
    }
    
    private func getShapeSize(for rect: CGRect) -> CGSize {
        return CGSize(width: Constants.cardWidthMultiplier * rect.size.width,
                      height: Constants.cardHeightMultiplier * rect.size.height)
    }
    
    private func addBorder(for path: UIBezierPath) {
        borderColor.setStroke()
        path.lineWidth = borderColor == Constants.defaultColor ?
            Constants.defaultBorderWidth :
            Constants.selectedBorderWidth
        path.stroke()
    }

}
