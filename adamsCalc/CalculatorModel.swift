//
//  Calculator.swift
//  adamsCalc
//
//  Created by Adam Reed on 6/19/21.
//

import SwiftUI

class Calculator: ObservableObject, Identifiable {
    // Variables for Calculator
    @Published var leftNumber = UserDefaults.standard.string(forKey: "leftNumber") ?? "" {
        didSet {
            UserDefaults.standard.setValue(self.leftNumber, forKey: "leftNumber")
        }
    }
    @Published var rightNumber = UserDefaults.standard.string(forKey: "rightNumber") ?? "" {
        didSet {
            UserDefaults.standard.setValue(self.rightNumber, forKey: "rightNumber")
        }
    }
    @Published var operand = UserDefaults.standard.string(forKey: "operand") ?? "" {
        didSet {
            UserDefaults.standard.setValue(self.operand, forKey: "operand")
        }
    }
    @Published var savedAnswerOne = UserDefaults.standard.string(forKey: "savedAnswerOne") ?? "" {
        didSet {
            UserDefaults.standard.setValue(self.savedAnswerOne, forKey: "savedAnswerOne")
        }
    }
    @Published var savedAnswerTwo = UserDefaults.standard.string(forKey: "savedAnswerTwo") ?? "" {
    didSet {
        UserDefaults.standard.setValue(self.savedAnswerTwo, forKey: "savedAnswerTwo")
    }
}
    @Published var savedAnswerThree = UserDefaults.standard.string(forKey: "savedAnswerThree") ?? "" {
        didSet {
            UserDefaults.standard.setValue(self.savedAnswerThree, forKey: "savedAnswerThree")
        }
    }
    @Published var lockOne = UserDefaults.standard.bool(forKey: "lockOne") ?? false {
        didSet {
            UserDefaults.standard.setValue(self.lockOne, forKey: "lockOne")
        }
    }
    @Published var lockTwo = UserDefaults.standard.bool(forKey: "lockTwo") ?? false {
        didSet {
            UserDefaults.standard.setValue(self.lockTwo, forKey: "lockTwo")
        }
    }
    @Published var lockThree = UserDefaults.standard.bool(forKey: "lockThree") ?? false {
        didSet {
            UserDefaults.standard.setValue(self.lockThree, forKey: "lockThree")
        }
    }

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
        if leftNumber == "" && rightNumber == "" && operand == "" && savedAnswerOne == "" && savedAnswerTwo == "" && savedAnswerThree == "" {
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
            savedAnswerOne = ""
        }
        if lockTwo == false {
            savedAnswerTwo = ""
        }
        if lockThree == false {
            savedAnswerThree = ""
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
        
        if savedAnswerOne == "" && lockOne == false {
            savedAnswerOne = numberAsString
        } else if savedAnswerTwo == "" && lockTwo == false {
            savedAnswerTwo = numberAsString
        } else if savedAnswerThree == "" && lockThree == false {
            savedAnswerThree = numberAsString
           
        } else if savedAnswerThree != "" && lockThree == false {
            savedAnswerThree = numberAsString
        } else if savedAnswerTwo != "" && lockTwo == false  {
            savedAnswerTwo = numberAsString
        } else if savedAnswerOne != "" && lockOne == false {
            savedAnswerOne = numberAsString
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

