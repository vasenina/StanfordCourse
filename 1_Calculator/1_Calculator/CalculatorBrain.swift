//
//  CalculatorBrain.swift
//  1_Calculator
//
//  Created by user on 10/11/16.
//  Copyright © 2016 Vasenina. All rights reserved.
//

import Foundation


class CalculatorBrain
{
    private var accumulator = 0.0
    
    var result: Double{
        get{
            return accumulator
        }
    }
    
    private var currentPrecendence = Int.max
    private var descriptionAccumulator = "0"{
        didSet{
            if pending==nil{
                currentPrecendence = Int.max
            }
        }
    }
    
    var description: String{
        get{
            if pending==nil{
            return descriptionAccumulator
            }
            else{
                return pending!.descriptionFunction(pending!.descriptionOperand, pending!.descriptionOperand != descriptionAccumulator ? descriptionAccumulator:"")
            }
        }
    }

    var isPartialResult: Bool{
        get{
            return pending != nil
        }
    }
    
    
    func setOperand (operand:Double){
        accumulator = operand
        descriptionAccumulator = String(format:"%g", accumulator)
    }
    
    func clearAll(){
        descriptionAccumulator = "0"
        accumulator = 0.0
    }
    
    
    private var operations: Dictionary <String, Operation> = [
        "π" : Operation.Constant(M_PI), //M_PI,
        "e" : Operation.Constant(M_E),
        "±" : Operation.UnaryOperation({-$0}, {"-("+$0+")"}),
        "√" : Operation.UnaryOperation(sqrt, {"√("+$0+")"}),
        "cos" : Operation.UnaryOperation(cos, {"cos("+$0+")"}),
        "sin" : Operation.UnaryOperation(sin, {"cos("+$0+")"}),
        "×" : Operation.BinaryOperation(*, {$0+"×"+$1}, 1 ),
        "÷" : Operation.BinaryOperation(/, {$0+"÷"+$1}, 1),
        "+" : Operation.BinaryOperation(+, {$0+"+"+$1 }, 0),
        "−" : Operation.BinaryOperation(-, {$0+"-"+$1 }, 0),
        "=" : Operation.Equals
    ]
    
    private enum Operation{
        //case NullaruOperation(()->Double, String)
        case Constant(Double)
        case UnaryOperation((Double) -> Double, (String)->String)
        case BinaryOperation((Double, Double) -> Double, (String, String)->String, Int)
        case Equals
       
    }
    
    
    func performOperation (symbol: String){
        if let operation = operations[symbol]{
            switch operation{
            case .Constant(let value):
                accumulator=value
                descriptionAccumulator = symbol
            case .UnaryOperation(let function, let descriptionFunction):
                accumulator = function(accumulator)
                descriptionAccumulator = descriptionFunction(descriptionAccumulator)
            case .BinaryOperation(let function, let descriptionFunction, let precedence):
                executePendingBinaryOperation()
                if currentPrecendence < precedence{
                    descriptionAccumulator = "("+descriptionAccumulator+")"
                }
                currentPrecendence = precedence
                
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator, descriptionFunction: descriptionFunction, descriptionOperand:descriptionAccumulator)
            case .Equals:
                executePendingBinaryOperation()
                
            }
        }
    }
    
    private func executePendingBinaryOperation(){
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            descriptionAccumulator = pending!.descriptionFunction(pending!.descriptionOperand, descriptionAccumulator)
            pending = nil
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo{
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
        var descriptionFunction : (String,String)->String
        var descriptionOperand: String
    }
}
