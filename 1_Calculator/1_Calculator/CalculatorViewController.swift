//
//  ViewController.swift
//  1_Calculator
//
//  Created by user on 09/11/16.
//  Copyright © 2016 Vasenina. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController, UISplitViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        splitViewController?.delegate = self
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool{
        return true
    }
    

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
    
    private var displayValue: Double? {
        get{
            if let text = display.text,
                value = formatter.numberFromString(text)?.doubleValue{
                return value
            }
            else {
                return nil
            }
        }
        set{
            if let value = newValue{
                display.text = formatter.stringFromNumber(value)
                formula.text = brain.description + (brain.isPartialResult ? "..." : "=")
            }
            else{
                display.text = " "
                formula.text = " "
                userIsInTheMiddleOfTyping = false
            }
            
        }
    }
    
    
    @IBAction func clear(sender: UIButton) {
        brain.clearAll()
        brain.clearVariables()
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
        else{
            brain.Undo()
            formula.text = brain.description
            displayValue = brain.result
            
            
        }
            
    }
    
    var savedProgram: CalculatorBrain.PropertyList?
   
    @IBAction func save() {
        userIsInTheMiddleOfTyping = false
        if let value = displayValue{
            brain.variableValues["M"] = value
            displayValue = brain.result
        }
        //savedProgram = brain.program
    }
    
    
    @IBAction func get() {
       /* if savedProgram != nil{
            brain.program = savedProgram!
            displayValue = brain.result
        }*/
        brain.setOperand("M")
        displayValue = brain.result
    }
    
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            if let value = displayValue{
                brain.setOperand(value)
            }
            
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

    override func shouldPerformSegueWithIdentifier(idetifier: String, sender: AnyObject?) -> Bool{
        return !brain.isPartialResult
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destinationvc = segue.destinationViewController
        if let navcon = destinationvc as? UINavigationController{
            destinationvc = navcon.visibleViewController ?? destinationvc
        }
        if let graphvc = destinationvc as? GraphViewController{
            graphvc.navigationItem.title = brain.description
            
            graphvc.yForX = { [weak weakSelf = self] x in
                weakSelf?.brain.variableValues["M"] = x
                return weakSelf?.brain.result
            }
            
        }
    }
    
}

