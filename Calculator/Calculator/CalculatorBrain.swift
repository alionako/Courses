//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Aliona on 05/07/16.
//  Copyright © 2016 ptenster. All rights reserved.
//

import Foundation


class CalculatorBrain {
    
    private var accumulator = 0.0
    private var internalProgram = [AnyObject]()
    
    var description: String = ""
    var isPartialResult: Bool = false
    
    func setOperand(operand: Double) {
        accumulator = operand
        internalProgram.append(operand)
    }
    
    private var operations : Dictionary<String, Operation> = [
        "π" : Operation.Constant(M_PI),
        "℮" : Operation.Constant(M_E),
        "10ˣ" : Operation.UnaryOperation({pow(10, $0)}),
        "√" : Operation.UnaryOperation(sqrt),
        "∛" : Operation.UnaryOperation(cbrt),
        "1/x" : Operation.UnaryOperation({1 / $0}),
        "x²" : Operation.UnaryOperation({$0 * $0}),
        "ln" : Operation.UnaryOperation(log10),
        "log" : Operation.UnaryOperation(log),
        "±" : Operation.UnaryOperation({-$0}),
        "sin" : Operation.UnaryOperation(sin),
        "cos" : Operation.UnaryOperation(cos),
        "tan" : Operation.UnaryOperation(tan),
        "×" : Operation.BinaryOperation({$0 * $1}),
        "÷" : Operation.BinaryOperation({$0 / $1}),
        "+" : Operation.BinaryOperation({$0 + $1}),
        "−" : Operation.BinaryOperation({$0 - $1}),
        "=" : Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    
    func performOperation(symbol: String)
    {
        internalProgram.append(symbol)
        if let operation = operations[symbol]
        {
            if description == "" { description = "\(accumulator)" }
            switch operation {
            case .UnaryOperation(let function):
                if isPartialResult {
                    description = "\(description) \(symbol) (\(accumulator)) "
                } else {
                    description = "\(symbol) (\(description)) "
                }
                accumulator = function(accumulator)
                break
            case .BinaryOperation(let function):
                if (isPartialResult) {performOperation("=")}
                description = "\(description) \(symbol) "
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
                isPartialResult = true
                break
            case .Constant(let value):
                accumulator = value
                if !isPartialResult {
                    description = "\(accumulator)"
                }
                break
            case .Equals:
                if pending != nil {
                    if description.substringFromIndex(description.endIndex.advancedBy(-2)) == ") " {
                        description = "\(description)"
                    } else {
                        description = "\(description)\(accumulator)"
                    }
                    accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
                    pending = nil
                    isPartialResult = false
                }
                break
            }
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    typealias propertyList = AnyObject
    var program: propertyList {
        get {
            return internalProgram
        }
        set {
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand)
                    } else if let operation = op as? String {
                        performOperation(operation)
                    }
                }
            }
        }
    }
    
    func clear() {
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
}