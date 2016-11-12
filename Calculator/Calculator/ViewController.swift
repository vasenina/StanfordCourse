//
//  ViewController.swift
//  Calculator
//
//  Created by Yulia Vasenina on 08/01/16.
//  Copyright (c) 2016 Yulia Vasenina. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var calcStack: UILabel!

    
    
    var isInTheMiddleOfTyping = false
    var brain = CalculatorBrain()
    

    @IBAction func appendDidgit(sender: UIButton) {
       
        
        let digit = sender.currentTitle!
        if (digit==".")&&(display.text?.rangeOfString(".") != nil){return}
        if (digit=="0")&&(display.text=="0") {return}
      
        if(isInTheMiddleOfTyping){
            display.text = display.text! + digit
        }
        else{
            display.text = digit
            isInTheMiddleOfTyping=true
        }
    }
    var operandStack:Array<Double> = Array<Double>()
    
  
    
    func setHistory(){
     
      /*  if calcStack.text!.rangeOfString("=") != nil{
        dropLast(calcStack.text!)
        dropLast(calcStack.text!)
        }*/
        
       /* calcStack.text = calcStack.text!.rangeOfString("=") != nil ?dropLast(calcStack.text!):calcStack.text*/
        
        calcStack.text = brain.description
    }
    
    
    
    @IBAction func enter() {
        isInTheMiddleOfTyping = false
        if let result = brain.pushOperand(displayValue!){
            displayValue = result
        }
        else {
            displayValue = nil
        }
        setHistory()
        //setHistory("\(displayValue)")
    }
    
    var displayValue: Double?{
    
        set{
            if let displayText = newValue{
                display.text = "\(displayText)"
                isInTheMiddleOfTyping = false
            }
            else{
                display.text = " "
            }
        }
        get{
            if let displayText = display.text {
                return NSNumberFormatter().numberFromString(displayText)?.doubleValue
             //   return NumberFormatter.formatter.numberFromString(display.text!)?.doubleValue
            }
            return nil
           // return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
    }
    
    
    @IBAction func operate(sender: UIButton) {
        if (isInTheMiddleOfTyping){
            enter()
        }
        if let operation  = sender.currentTitle{
            if let result = brain.performOperation(operation){
                displayValue = result
                
            }
            else {
                displayValue = nil
            }
            setHistory()
        }

    }
  /*              setHistory(operation + "=")
        
        switch operation{
            case "×":performOperation{$0*$1}
            case "÷":performOperation{$1/$0}
            case "+":performOperation{$0+$1}
            case "−":performOperation{$1-$0}
            case "sin":performOperation{sin($0)}
            case "cos":performOperation{cos($0)}
            case "√":performOperation{sqrt($0)}
            case "π":performOperation{M_PI}
            case "±": performOperation{-$0}
            default:break
    
    func performOperation(operation:(Double, Double)->Double)
    {
        if (operandStack.count>=2){
        displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    func performOperation(operation:(Double)->Double)
    {
        if (operandStack.count>=1){
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    func performOperation(operation:()->Double)
    {
            displayValue = operation()
            enter()
    } */

    
    @IBAction func clearAll(sender: AnyObject) {
        calcStack.text = " ";
        displayValue = brain.clearStory()
        brain.clearVariables()
    }
    
    
    
    @IBAction func backSpace(sender: AnyObject) {
       
        if (isInTheMiddleOfTyping){
            
            //  var text = display.text!
            //  let x = countElements(text)
            
            if ((display.text!).characters.count>1){
                display.text = String((display.text!).characters.dropLast())
            }
            else{
                display.text = "0"
            }
        }

        }
    
    }
    
    


