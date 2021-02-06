//
//  AppDelegate.swift
//  MTMs-Task
//
//  Created by Abdelrahman Sobhy on 2/5/21.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        return true
    }


}

