//
//  AppDelegate.swift
//  ProgressGif
//
//  Created by Zheng on 7/10/20.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        /// register defaults if user hasn't set yet
        UserDefaults.standard.register(defaults: [
            DefaultKeys.fps: FPS.normal.getString(),
            
            DefaultKeys.barHeight: 5,
            DefaultKeys.barForegroundColorHex: "FFB500",
            DefaultKeys.barBackgroundColorHex: "F4F4F4",
            
            DefaultKeys.edgeInset: 0,
            DefaultKeys.edgeCornerRadius: 0,
            DefaultKeys.edgeShadowIntensity: 0,
            DefaultKeys.edgeShadowRadius: 0,
            DefaultKeys.edgeShadowColorHex: "000000"
        ])
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

