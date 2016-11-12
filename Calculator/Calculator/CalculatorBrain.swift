//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Yulia Vasenina on 16/01/16.
//  Copyright (c) 2016 Yulia Vasenina. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    
    private enum Op: CustomStringConvertible{
        case Operand (Double)
        case ConstantOperation(String, ()->Double)
        case UnaryOperation(String, Double->Double)
        case BinaryOperation(String, (Double, Double)->Double)
        case Variable(String)
        
        var description:String{
            get{
                switch self{
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .ConstantOperation(let symbol, _):
                    return symbol
                case .Variable(let symbol):
                    return symbol
                }
            }
        }
        
    }
    
    private var opStack = [Op] ()
    private var knownOps = [String : Op] ()
    var description: String{
        get{
            if (!opStack.isEmpty){
                //let (result, remainder) = evaluate(opStack)
                return "\(opStack) ="
            }
            else{
                return " "
            }
            
        }
    
    }
    private var variableValues = [String: Double]()
    
    func setVariable(symbol: String, value: Double){
        variableValues[symbol] = value
        
    }
    
    func getVariable(symbol: String)->Double?{
        return variableValues[symbol]
    }
    
    func clearVariables(){
        variableValues.removeAll()
    }
    
    init(){
        knownOps["×"] = Op.BinaryOperation("×", *)
        knownOps["÷"] = Op.BinaryOperation("÷") {$1/$0}
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["−"] = Op.BinaryOperation("−") {$1-$0}
        knownOps["sin"] = Op.UnaryOperation("sin", sin)
        knownOps["cos"] = Op.UnaryOperation("cos", cos)
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
        knownOps["π"] = Op.ConstantOperation("π") {M_PI}
        knownOps["±"] = Op.UnaryOperation("±") {-$0}
    }
    
    
    func pushOperand(operand: Double)->Double?{
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func pushOperand(symbol: String)->Double?{
        opStack.append(Op.Variable(symbol))
        return evaluate()
    }
    
    
    func performOperation(symbol: String)->Double?{
        if let operation = knownOps[symbol]{
            opStack.append(operation)
        }
        return evaluate()
    }
    
    private func evaluate (ops: [Op]) -> (result:Double?, remainingOps: [Op]){
        
        if !ops.isEmpty{
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op{
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return(operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let operand1Evaluation = evaluate(remainingOps)
                if let operand1 = operand1Evaluation.result {
                    let operand2Evaluation = evaluate(operand1Evaluation.remainingOps)
                    if let operand2 = operand2Evaluation.result {
                        return(operation(operand1, operand2), operand2Evaluation.remainingOps)
                    }
                }
            case .ConstantOperation(_, let constant):
                return (constant(), remainingOps)
           
            case .Variable(let variable):
                return (getVariable(variable), remainingOps)
                
            }
            
        }
        
        return (nil, ops)
        
    }
    
    func evaluate()->Double?{
        let (result, remainder) = evaluate(opStack)
        print ("\(opStack) = \(result) with \(remainder) left over")
        return result;
    }
    
    func clearStory()->Double?{
        opStack.removeAll()
        return nil;
    }

    
}
