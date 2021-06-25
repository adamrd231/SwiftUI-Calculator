//
//  Calculator.swift
//  adamsCalc
//
//  Created by Adam Reed on 6/19/21.
//

import SwiftUI

class Calculator: ObservableObject, Identifiable {
    // Variables for Calculator
    @Published var leftNumber = ""
    @Published var rightNumber = ""
    @Published var operand = ""
    @Published var savedAnswerArray = ["", "", ""]
    @Published var lockOne = false
    @Published var lockTwo = false
    @Published var lockThree = false
    @Published var locksStatus = [false, true, false]

    // UI Settings that users might be able to adjust
    @Published var decimalPlaces = 2
    
    enum NumberPadButtons:String {
        case one = "1"
        case two = "2"
        case three = "3"
        case four = "4"
        case five = "5"
        case six = "6"
        case seven = "7"
        case eight = "8"
        case nine = "9"
        case zero = "0"
        case add = "+"
        case period = "."
        case subtract = "-"
        case multiply = "*"
        case divide = "/"
        case equals = "="
        case clear = "AC"
        case negativePostive = "+/-"
        case percentage = "%"
        case backSpace = "<"
    }
    
    let numberPadButtons: [[NumberPadButtons]] = [
        [.clear, .backSpace, .negativePostive, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .period, .equals]
    ]
    
    
    // MARK: Helper Functions
    func checkACDisabled() -> Bool {
        if leftNumber == "" && rightNumber == "" && operand == "" && savedAnswerArray[0] == "" && savedAnswerArray[1] == "" && savedAnswerArray[2] == "" {
            return true
        } else {
            return false
        }
    }
    
    
    func handleNumberInputs(title: String) {

        if operand == "" {
            if (leftNumber == "") {
                if title == "+/-" {
                    return
                } else {
                    leftNumber = title
                }
                
            } else {
                if leftNumber.contains(".") && title == "." {
                    return
                }
                
                
                if title == "+/-" {
                    leftNumber = changeNegativePositive(numberFromString: leftNumber)
                } else {
                    leftNumber.append(title)
                }
                
            }
        } else {
            if rightNumber == "" {
                if title == "+/-" {
                    return
                } else {
                    rightNumber = title
                }
                
            } else {
                if rightNumber.contains(".") && title == "." {
                    return
                }
                if title == "+/-" {
                    rightNumber = changeNegativePositive(numberFromString: rightNumber)
                } else {
                    rightNumber.append(title)
                }
                
            }
        }
        
    }
    
    func changeNegativePositive(numberFromString: String) -> String {
        var floatNumber = Float(numberFromString)
        if var floatCheck = floatNumber {
            floatCheck = floatCheck * -1
            return String(floatCheck)
        } else {
            return numberFromString
        }
    }
    
    
    func equalsOperand() {

        // Check to make sure all inputs are entered, otherwise return
        if leftNumber != "" && rightNumber != "" && operand != "" {
            
            // Setup float numbers from the inputs
            let floatLeftNumber = Float(leftNumber)
            let floatRightNumber = Float(rightNumber)
            var answer:String = ""
            
            // Perform the math operation based on the operand
            if operand == "*" {
                answer = (floatLeftNumber! * floatRightNumber!).clean
            } else if operand == "-" {
                answer = (floatLeftNumber! - floatRightNumber!).clean
            } else if operand == "+" {
                answer = (floatLeftNumber! + floatRightNumber!).clean
            } else {
                answer = (floatLeftNumber! / floatRightNumber!).clean
            }
            
            // Clear the operator inputs
            leftNumber = ""
            operand = ""
            rightNumber = ""
            
            if lockOne == true && lockTwo == true && lockThree == true {
                
                leftNumber = answer
            } else {
                
                fillAnswerArrays(numberAsString: answer)
            }
        } else {
            return
        }
    }
    
    func continuedOperatation(newOperator: String) {
        
        if leftNumber.last == "." {
            leftNumber.removeLast()
        }
        if rightNumber.last == "." {
            rightNumber.removeLast()
        }
        
        if leftNumber != "" && rightNumber != "" && operand != "" {
            // Use number and operator inputs to do math
            let doubleLeftNumber = Float(leftNumber)
            let doubleRightNumber = Float(rightNumber)
            var answer:Float = 0
            
            if operand == "*" || operand  == "x" {
                answer = doubleLeftNumber! * doubleRightNumber!
            } else if operand == "-" {
                answer = doubleLeftNumber! - doubleRightNumber!
            } else if operand == "+" {
                answer = doubleLeftNumber! + doubleRightNumber!
            } else {
                answer = doubleLeftNumber! / doubleRightNumber!
            }
            
            leftNumber = String(format: "%.\(decimalPlaces)f", answer)
            operand = newOperator
            rightNumber = ""
            
            
            
            fillAnswerArrays(numberAsString: leftNumber)
            
        } else {
            return
        }
    }
    
    func handleOperandInputs(operandInput: String) {
        
        if leftNumber.last == "." {
            leftNumber.removeLast()
        }
        if rightNumber.last == "." {
            rightNumber.removeLast()
        }

        
        
        // Check place in calculator sequence
        // if leftNumber has not been entered, do nothing
        if leftNumber == "" {
            return
        // if leftNumber is filled, choose operator
        } else if leftNumber != "" && operand == "" {
            operand = operandInput
        // if leftNumber is filled and operator, replace operator
        } else if leftNumber != "" && operand != "" && rightNumber == "" {
            operand = operandInput
        // if leftNumber is filled, operator and rightnumber being filled, do nothing
        } else {
            continuedOperatation(newOperator: operandInput)
        }
        
    }
    
    func clearButton() {
        leftNumber = ""
        rightNumber = ""
        operand = ""
        
        if lockOne == false {
            savedAnswerArray[0] = ""
        }
        if lockTwo == false {
            savedAnswerArray[1] = ""
        }
        if lockThree == false {
            savedAnswerArray[2] = ""
        }
        
        
        
        
    }
    
    func backspaceClear() {
        if leftNumber != "" && operand != "" && rightNumber != "" {
            rightNumber.removeLast()
        } else if leftNumber != "" && operand != "" {
            operand = ""
        } else if leftNumber != "" {
            leftNumber.removeLast()
        } else {
            return
        }
    }
    

    
    func fillAnswerArrays(numberAsString: String) {
        
        if savedAnswerArray[0] == "" && lockOne == false {
            savedAnswerArray[0] = numberAsString
        } else if savedAnswerArray[1] == "" && lockTwo == false {
            savedAnswerArray[1] = numberAsString
        } else if savedAnswerArray[2] == "" && lockThree == false {
            savedAnswerArray[2] = numberAsString
           
        } else if savedAnswerArray[2] != "" && lockThree == false {
            savedAnswerArray[2] = numberAsString
        } else if savedAnswerArray[1] != "" && lockTwo == false  {
            savedAnswerArray[1] = numberAsString
        } else if savedAnswerArray[0] != "" && lockOne == false {
            savedAnswerArray[0] = numberAsString
        }
    }
    
    func usingSavedAnswers(answer: String) {
        if leftNumber == "" {
            leftNumber = answer
        } else if leftNumber != "" && operand == "" {
            leftNumber = answer
        } else if operand != "" && leftNumber != "" && rightNumber == "" {
            rightNumber = answer
        } else {
            rightNumber = answer
        }
    }
}

