//
//  adamsCalcApp.swift
//  adamsCalc
//
//  Created by Adam Reed on 6/17/21.
//

import SwiftUI
import GoogleMobileAds
import StoreKit

@main
struct adamsCalcApp: App {
    
    @StateObject var calculator = Calculator()
    @StateObject var storeManager = StoreManager()
    
    
    var productIds = ["remove_advertising"]
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView(storeManager: storeManager).environmentObject(calculator)
                .onAppear(perform: {
                    SKPaymentQueue.default().add(storeManager)
                    storeManager.getProducts(productIDs: productIds)
                    
            })
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Setup google admob instance
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        return true
    }

}

