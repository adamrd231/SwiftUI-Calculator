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
    @StateObject var storeManager: StoreManager

    @State var interstitial: GADInterstitialAd?
    @State var playedInterstitial = false
//    @State var purchasedRemoveAds = false
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
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
       print("Ad did fail to present full screen content.")
     }

     func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
       print("Ad did present full screen content.")
     }

     func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
       print("Ad did dismiss full screen content.")
     }

    
    // MARK: App UI
    var body: some View {
        
        TabView {
            
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
                        Button( action: {
                            calculator.usingSavedAnswers(answer: calculator.savedAnswerOne)
                        }) {
                            Text("\(calculator.savedAnswerOne)").font(.system(size: 13.0))
                        }.buttonStyle(SavedAnswersButtonStyle())
                        
                        Button( action: {
                            calculator.usingSavedAnswers(answer: calculator.savedAnswerTwo)
                        }) {
                            Text("\(calculator.savedAnswerTwo)").font(.system(size: 13.0))
                        }.buttonStyle(SavedAnswersButtonStyle())
                        
                        Button( action: {
                            calculator.usingSavedAnswers(answer: calculator.savedAnswerThree)
                        }) {
                            Text("\(calculator.savedAnswerThree)").font(.system(size: 13.0))
                        }.buttonStyle(SavedAnswersButtonStyle())
                            
                        
                    }.padding(.top)
                    
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
                        
                        if storeManager.purchasedRemoveAds == false {
                            // Google Ad Mob
                            Banner().frame(alignment: .center)
                        }
                    
                    }
                }
                
            }
            
            .tabItem {
                Image(systemName: "house").frame(width: 15, height: 15, alignment: .center)
                Text("Home")
                
            }
            .onAppear(perform: {
                if storeManager.purchasedRemoveAds == false {
                    if playedInterstitial == false {
                        let request = GADRequest()
                            GADInterstitialAd.load(withAdUnitID:"ca-app-pub-4186253562269967/2135766372",
                                    request: request, completionHandler: { [self] ad, error in
                                        // Check if there is an error
                                        if let error = error {
                                            return
                                        }
                                        // If no errors, create an ad and serve it
                                        interstitial = ad
                                        let root = UIApplication.shared.windows.first?.rootViewController
                                            self.interstitial!.present(fromRootViewController: root!)
                                            // Let user use the app until the next time ad free
                                            playedInterstitial = true
                                        }
                                    )
                                        } else {
                                            return
                                        }
                }
            })
            
            // Second Screen
            VStack(alignment: .leading) {
                Text("Thank you!").bold().font(.system(size:35.0)).padding(.bottom)
                Text("My calculator is designed to keep your answers from recent calculations in usable buttons, you can 'lock' or 'unlock' your saved numbers to keep them for the future, future you thanks current you!").padding(.bottom)
                Text("You've made it here, and I thank you. As a independent developer, I have always enjoyed solving unique problems with my own special approach. In order for me to do so, I advertise on these free apps to help make money. I get it, advertising is lame and you do not really want to see a video every time you open up. Here's the deal, help me to build my future as a developer and I'll turn them off for you, forever. Just $5.")
                HStack {
                    Button( action: {
                        storeManager.purchaseProduct(product: storeManager.myProducts.first!)
                    }) {
                        VStack {
                            if storeManager.purchasedRemoveAds == true {
                                Text("Purchased")
                            } else {
                                Text(storeManager.myProducts.first?.localizedTitle ?? "").bold()
                                    .padding()
                                    .font(.system(size:15.0))
                                    .background(Color(.darkGray))
                                    .foregroundColor(.white)
                                    .cornerRadius(55.0)
                            }
                        }
                    }.padding().disabled(storeManager.purchasedRemoveAds)
                    
                    
                    Button( action: {
                        storeManager.restoreProducts()
                    }) {
                        Text("Restore Purchases").bold()
                            .padding()
                            .font(.system(size:15.0))
                            .background(Color(.darkGray))
                            .foregroundColor(.white)
                            .cornerRadius(55.0)
                    }.padding(.top).padding(.bottom).padding(.trailing)
                }
                
            }.padding().tabItem {
                VStack {
                    Image(systemName: "lock").frame(width: 15, height: 15, alignment: .center)
                    Text("Remove Ads")
                }
            }
            
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(storeManager: StoreManager()).environmentObject(Calculator())
        }
    }
}





extension Float {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
 

