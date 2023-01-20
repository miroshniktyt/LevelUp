//
//  AppDelegate.swift
//  Wild Melody
//
//  Created by Book of Dead on 10/11/2020.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        self.window = UIWindow()
        self.window?.makeKeyAndVisible()
        let vc = MenuViewController()
        self.window?.rootViewController = vc
        
        return true
    }
    
}
