
//
//  ViewController.swift
//  Calculator2
//
//  Created by Andrew Loutfi on 2/15/16.
//  Copyright © 2016 Andrew Loutfi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var history: UILabel!

    @IBOutlet weak var display: UILabel!
    
    var decimalUsed: Bool = false
    
    var brain = CalculatorBrain()
    
    var userInputing = false
    let x = M_PI
    
    @IBAction func decimal(sender: UIButton) {
        if decimalUsed == false{
            userInputing = true
            display.text = display.text! + "."
            decimalUsed = true
        }
        updateHistory()
    }
    
    @IBAction func pi(sender: UIButton) {
        userInputing = true
        display.text = "∏"
        displayValue = x
        updateHistory()
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle! //! unwraps or crashes if optional is nil
        if userInputing {
                display.text = display.text! + digit
        }else{
            display.text = digit
            userInputing = true
        }
        updateHistory()
    }
    
    @IBAction func backspace(sender: UIButton) {
        if display.text!.characters.count > 1 {
        
            display.text! = display.text!.substringToIndex(countElements(display.text!) - 1)
        }else{
            display.text = "0"
        }
        updateHistory()

    }
    @IBAction func setMemory(sender: UIButton) {
        if displayValue != nil {
            userInputing = false
            brain.variableValues["M"] = displayValue 
            if let result = brain.evaluate() {
                displayValue = result
            } else {
                displayValue = nil
            }
            updateHistory()
        }

    }

    @IBAction func pushMemory(sender: UIButton) {
        if userInputing {
            enter()
        }
        if let result = brain.pushOperand("M") {
            displayValue = result
        } else {
            displayValue = nil
        }
        updateHistory()
    }
    
    @IBAction func operate(sender: UIButton) {
        if userInputing {
            enter()
        }
        if let operation = sender.currentTitle{
            if let result = brain.performOperation(operation){
                displayValue = result
            }else{
                displayValue = 0
            }
        }
        updateHistory()
    }
    
    @nonobjc
    
    func updateHistory() {
        
        history.text = brain.description + (userInputing && brain.lastOpIsAnOperation ? "=" : "")
    }

    
    @IBAction func clear() {
        userInputing = false
        displayValue = 0
        brain.clearOperationStack()
        updateHistory()
    }
    
    @IBAction func enter() {
        decimalUsed = false
        userInputing = false
        if let result = brain.pushOperand(displayValue!) {
            displayValue = result
        } else {
            displayValue = nil
        }
        updateHistory()
    }
    
    var displayValue: Double?{
        get {
            if let displayValueAsDouble = NSNumberFormatter().numberFromString(display.text!)?.doubleValue {
                return displayValueAsDouble
            }
            return nil
        }
        set {
            display.text = newValue != nil ? "\(newValue!)" : " "
            userInputing = false
        }
    }

}

