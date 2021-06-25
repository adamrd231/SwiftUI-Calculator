//
//  adamsCalcApp.swift
//  adamsCalc
//
//  Created by Adam Reed on 6/17/21.
//

import SwiftUI
import GoogleMobileAds

@main
struct adamsCalcApp: App {
    
    var calculator = Calculator()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(calculator)
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
