//
//  ShapeView.swift
//  Set
//
//  Created by Aliona Kozlova on 07.05.2020.
//  Copyright © 2020 Aliona Kozlova. All rights reserved.
//

import UIKit

private struct Constants {
    static let strokeWidth: CGFloat = 4
}

class ShapeView: UIView {
    
    var card: Card? {
        didSet {
            setNeedsDisplay()
        }
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
        let drawingRect = rect.rectSubstracting(Constants.strokeWidth)
        switch card?.formType {
        case .one:
            drawOval(in: drawingRect)
        case .two:
            drawDiamond(in: drawingRect)
        case .three:
            drawSquiggles(in: drawingRect)
        default:
            break
        }
    }
    
}

// MARK: - Drawing

private extension ShapeView {
    
    func drawOval(in rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect)
        colorify(path: path, rect: rect)
    }
    
    func drawDiamond(in rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: rect.topCenter)
        path.addLine(to: rect.rightCenter)
        path.addLine(to: rect.bottomCenter)
        path.addLine(to: rect.leftCenter)
        path.close()
        colorify(path: path, rect: rect)
    }
    
    func drawSquiggles(in rect: CGRect) {
        let path = UIBezierPath()
     
        let currentShapeX = rect.origin.x
        let currentShapeY = rect.origin.y
        let shapeWidth = rect.width
        let shapeHeight = rect.height
        let curveXOffset = shapeWidth * 0.35
        
        path.move(to: CGPoint(x: currentShapeX, y: currentShapeY))

        path.addCurve(to: CGPoint(x: currentShapeX, y: currentShapeY + shapeHeight),
                      controlPoint1: CGPoint(x: currentShapeX + curveXOffset, y: currentShapeY + shapeHeight / 3),
                      controlPoint2: CGPoint(x: currentShapeX - curveXOffset, y: currentShapeY + (shapeHeight / 3) * 2))
        
        path.addLine(to: CGPoint(x: currentShapeX + shapeWidth, y: currentShapeY + shapeHeight))
        
        path.addCurve(to: CGPoint(x: currentShapeX + shapeWidth, y: currentShapeY),
                      controlPoint1: CGPoint(x: currentShapeX + shapeWidth - curveXOffset, y: currentShapeY + (shapeHeight / 3) * 2),
                      controlPoint2: CGPoint(x: currentShapeX + shapeWidth + curveXOffset, y: currentShapeY + shapeHeight / 3))
        
        path.addLine(to: CGPoint(x: currentShapeX, y: currentShapeY))
        
        path.close()
        colorify(path: path, rect: rect)
    }

}

// MARK: - Colors

private extension ShapeView {
    
    func colorify(path: UIBezierPath, rect: CGRect) {
        guard let card = card else {
            return
        }
        let color = getColor(for: card.colorType)
        switch card.shadingType {
        case .one:
            color.setFill()
            path.fill()
        case .two:
            color.setStroke()
            path.lineWidth = Constants.strokeWidth
            path.stroke()
        case .three:
            path.addClip()
            color.setStroke()
            for y in stride(from: 0.0, to: rect.height + rect.width, by: Constants.strokeWidth * 3) {
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: rect.width + Constants.strokeWidth,
                                         y: y - rect.width - Constants.strokeWidth))
                path.lineWidth = Constants.strokeWidth
            }
            path.stroke()
        }
    }
    
    private func getColor(for type: CardPropertyType) -> UIColor {
        switch type {
        case .one:
            return .red
        case .two:
            return .green
        case .three:
            return .yellow
        }
    }

}
