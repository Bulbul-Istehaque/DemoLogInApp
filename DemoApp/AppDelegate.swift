//
//  AppDelegate.swift
//  DemoApp
//
//  Created by Bul on 24/11/23.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window:UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        NetworkRechability.shared
        
        AppManager.shared
        
        UserAccountService.setAppStateForCurrentUser()
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    
    class func getWindow() -> UIWindow {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if let tempWindow = appDelegate.window {
            
            return tempWindow
        }
        
        let tempWindow = UIWindow(frame: UIScreen.main.bounds)
        
        appDelegate.window = tempWindow
        
        return tempWindow
    }

}

