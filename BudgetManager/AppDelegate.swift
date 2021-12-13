//
//  AppDelegate.swift
//  BudgetManager
//
//  Created by Yundong Lee on 2021/11/17.
//

import UIKit
import IQKeyboardManagerSwift
import RealmSwift
import Firebase


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UITabBar.appearance().barTintColor = UIColor(red: 44/255, green: 48/255, blue: 66/255, alpha: 1)

        
        let attributes = [NSAttributedString.Key.font:UIFont(name: "American Typewriter", size: 20)]
        
                          UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .normal)
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        
        let config = Realm.Configuration(
            schemaVersion: 2,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 2 {
                    // Rename the "age" property to "yearsSinceBirth".
                    // The renaming operation should be done outside of calls to `enumerateObjects(ofType: _:)`.
                    migration.enumerateObjects(ofType: BudgetModel.className()) { oldObject, newObject in
                        newObject!["uuid"] = UUID()
                    }
                }
            })
        
        
        Realm.Configuration.defaultConfiguration = config
        
        FirebaseApp.configure()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

