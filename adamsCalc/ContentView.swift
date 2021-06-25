//
//  ContentView.swift
//  adamsCalc
//
//  Created by Adam Reed on 6/17/21.
//

import SwiftUI
import GoogleMobileAds

struct ContentView: View {
   
    @EnvironmentObject var calculator: Calculator

    
    // UI Setting for layout
    var geometryDivisor = 9
    
    func toggleButtonStatus(boolVariable: Bool) -> Bool {
        var newBool = boolVariable
        newBool.toggle()
        return newBool
    }
    
    func displayLockImage(boolVariable:Bool) -> Image {
        if boolVariable == false {
            return Image(systemName: "lock").resizable()
        } else {
            return Image(systemName: "lock.fill").resizable()
        }
    }
    
    // MARK: App UI
    var body: some View {
        
        GeometryReader { geometry in
            ZStack(alignment: .top) {
            // Setup backgound Color
            Color(.systemGray6).edgesIgnoringSafeArea([.top,.bottom])
            
            // Main Stack
                VStack(alignment: .center) {
                
                
                
                // Display the calculator as user types and enters equations
                HStack {
                    Text("\(calculator.leftNumber)").foregroundColor(Color.white).font(.system(size: 50.0))
                    Text("\(calculator.operand)").foregroundColor(Color.white).font(.system(size: 50.0))
                    Text("\(calculator.rightNumber)").foregroundColor(Color.white).font(.system(size: 50.0))
                }.padding()
                .frame(minWidth: 0,
                       maxWidth: .infinity,
                       minHeight: 100,
                       maxHeight: 150,
                       alignment: .trailing)
                .background(Color(.darkGray))
                
                
                // Saved Answer Array
                HStack {
                    ForEach(0...calculator.savedAnswerArray.count - 1, id: \.self) { savedAnswer in
                        Button( action: {
                            calculator.usingSavedAnswers(answer: calculator.savedAnswerArray[savedAnswer])
                        }) {
                            Text("\(calculator.savedAnswerArray[savedAnswer])").font(.system(size: 18.0))
                        }.buttonStyle(SavedAnswersButtonStyle())
                        
                    }
                }
                
                // Lock Button Row
                HStack {
                    Button(action: {
                        calculator.lockOne = toggleButtonStatus(boolVariable: calculator.lockOne)
                    }) { displayLockImage(boolVariable: calculator.lockOne).frame(width: 23, height: 27) }
                    Spacer()
                    Button(action: {
                        calculator.lockTwo = toggleButtonStatus(boolVariable: calculator.lockTwo)
                    }) { displayLockImage(boolVariable: calculator.lockTwo).frame(width: 23, height: 27) }
                    Spacer()
                    Button(action: {
                        calculator.lockThree = toggleButtonStatus(boolVariable: calculator.lockThree)
                    }) { displayLockImage(boolVariable: calculator.lockThree).frame(width: 23, height: 27) }
                }.frame(minWidth: 200,
                        maxWidth: 250)
                
                
                // Number Pad Buttons
                VStack(alignment: .center) {
                    ForEach(calculator.numberPadButtons, id: \.self) { row in
                        HStack {
                            ForEach(row, id: \.self) { item in
                                Button(action:{
                                    switch item.rawValue {
                                    case "1": calculator.handleNumberInputs(title: "1")
                                    case "2": calculator.handleNumberInputs(title: "2")
                                    case "3": calculator.handleNumberInputs(title: "3")
                                    case "4": calculator.handleNumberInputs(title: "4")
                                    case "5": calculator.handleNumberInputs(title: "5")
                                    case "6": calculator.handleNumberInputs(title: "6")
                                    case "7": calculator.handleNumberInputs(title: "7")
                                    case "8": calculator.handleNumberInputs(title: "8")
                                    case "9": calculator.handleNumberInputs(title: "9")
                                    case "0": calculator.handleNumberInputs(title: "0")
                                    case "/": calculator.handleOperandInputs(operandInput: "/")
                                    case "*": calculator.handleOperandInputs(operandInput: "*")
                                    case "-": calculator.handleOperandInputs(operandInput: "-")
                                    case "+": calculator.handleOperandInputs(operandInput: "+")
                                    case "+/-": calculator.handleNumberInputs(title: "+/-")
                                    case ".": calculator.handleNumberInputs(title: ".")
                                    case "<": calculator.backspaceClear()
                                    case "=": calculator.equalsOperand()
                                    case "AC": calculator.clearButton()
                                        default: return
                                    }
                        

                                }) {
                                    Text(item.rawValue)
                                        .foregroundColor(.white)
                                        .font(.system(size: 20.0))
                                        
                                        
                                        
                                }.buttonStyle(NumberPadButtonStyle())
                                }
                        }
                        }
                }.padding(.bottom).padding(.top)
                    
                // Google Ad Mob
                Banner().frame(alignment: .center)
                }
            }
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().environmentObject(Calculator())
        }
    }
}





extension Float {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
 

