//
//  ViewController.swift
//  1_Calculator
//
//  Created by user on 09/11/16.
//  Copyright © 2016 Vasenina. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var display: UILabel!
    
    @IBOutlet private weak var formula: UILabel!
    
    private var userIsInTheMiddleOfTyping=false
    
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            if (digit != ".") || (textCurrentlyInDisplay.rangeOfString(".") == nil) {
                display.text = textCurrentlyInDisplay + digit
            }
        }
        else{
            if digit=="."{
                display.text = "0" + digit
            }
            else{
                   display.text = digit
            }
        }
        userIsInTheMiddleOfTyping = true
    }
    
    private var displayValue: Double {
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }
    
    
    @IBAction func clear(sender: UIButton) {
        brain.clearAll()
        formula.text = brain.description
        displayValue = brain.result
        
    }
    
    
    @IBAction func backspace(sender: UIButton) {
        
        if userIsInTheMiddleOfTyping && displayValue != 0{
            
            if display.text!.characters.count>1{
                display.text!.removeAtIndex(display.text!.endIndex.predecessor())
            }
            else{
                display.text = "0"
                userIsInTheMiddleOfTyping = false
                
            }
            
        }
            
    }
    
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
        }
        
        userIsInTheMiddleOfTyping = false
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        displayValue = brain.result
        
        formula.text = brain.description
        if formula.text == " " {return}
        if brain.isPartialResult{
            formula.text! += "..."
        }
        else{
            formula.text! += "="
        }
    }
  
}

