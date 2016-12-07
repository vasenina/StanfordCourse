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
    private var internalProgram = [AnyObject]()
    
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
        descriptionAccumulator = formatter.stringFromNumber(accumulator) ?? ""
        internalProgram.append(operand)
    }
    
    func setOperand (variable:String){
        accumulator = variableValues[variable] ?? 0
        descriptionAccumulator = variable
        internalProgram.append(variable)
    }
    
    var variableValues = [String : Double](){
        didSet{
            program = internalProgram
        }
    }
    
    func clearAll(){
        descriptionAccumulator = "0"
        accumulator = 0.0
        pending = nil
        currentPrecendence = Int.max
        internalProgram.removeAll(keepCapacity: false)
    }
    
    func clearVariables(){
        variableValues = [:]
    }
    
    func Undo(){
        guard !internalProgram.isEmpty else { clearAll(); return}
        internalProgram.removeLast()
        program = internalProgram
        
    }
    
    
    private var operations: Dictionary <String, Operation> = [
        "rand" : Operation.NullaruOperation(drand48, "rand()"),
        "π" : Operation.Constant(M_PI), //M_PI,
        "e" : Operation.Constant(M_E),
        "±" : Operation.UnaryOperation({-$0}, {"-("+$0+")"}),
        "√" : Operation.UnaryOperation(sqrt, {"√("+$0+")"}),
        "cos" : Operation.UnaryOperation(cos, {"cos("+$0+")"}),
        "sin" : Operation.UnaryOperation(sin, {"sin("+$0+")"}),
        "×" : Operation.BinaryOperation(*, {$0+"×"+$1}, 1 ),
        "÷" : Operation.BinaryOperation(/, {$0+"÷"+$1}, 1),
        "+" : Operation.BinaryOperation(+, {$0+"+"+$1 }, 0),
        "−" : Operation.BinaryOperation(-, {$0+"-"+$1 }, 0),
        "=" : Operation.Equals
    ]
    
    private enum Operation{
        case NullaruOperation(()->Double, String)
        case Constant(Double)
        case UnaryOperation((Double) -> Double, (String)->String)
        case BinaryOperation((Double, Double) -> Double, (String, String)->String, Int)
        case Equals
       
    }
    
    
    func performOperation (symbol: String){
        internalProgram.append(symbol)
        if let operation = operations[symbol]{
            switch operation{
            case .NullaruOperation(let function, let descriptionValue):
                accumulator = function()
                descriptionAccumulator = descriptionValue
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
    
    
    typealias PropertyList = AnyObject
    var program: PropertyList{
        get{
            return internalProgram
            
        }
        set{
            clearAll()
            if let arrayOfOps = newValue as? [AnyObject]{
                for op in arrayOfOps{
                    if let operand  = op as? Double{
                        setOperand(operand)
                    }
                    else if let symbol = op as? String{
                        // checking is it variable or operation
                        if operations[symbol] != nil{
                            performOperation(symbol)
                        }
                        else{
                            setOperand(symbol)
                        }
                    }
                   
                }
            }
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


class CalculatorFormatter: NSNumberFormatter{
    required init?(coder aDecoder:NSCoder){
        super.init(coder: aDecoder)
    }
    
    override init(){
        super.init()
        self.locale = NSLocale.currentLocale()
        self.numberStyle = .DecimalStyle
        self.maximumFractionDigits = 6
        self.notANumberSymbol = "Error"
        self.groupingSeparator = " "
    }
}
let formatter = CalculatorFormatter()
