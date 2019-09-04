//
//  AppDelegate.swift
//  ChefZs
//
//  Created by Daniel Duan on 2/23/19.
//  Copyright © 2019 Daniel Duan. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import RealmSwift

var isAppAlreadyLaunchedOnce = false

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        
        FirebaseApp.configure()
        let db = Firestore.firestore()
        
        let defaults = UserDefaults.standard
        if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce") {
            print("App already launched")
            isAppAlreadyLaunchedOnce = true
        } else {
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App Launched first time")
            isAppAlreadyLaunchedOnce = false
        }
        
        var configuration = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                    
                    // if just the name of your model's property changed you can do this
//                    migration.renameProperty(onType: NotSureItem.className(), from: "text", to: "title")
                    
                    // if you want to fill a new property with some values you have to enumerate
                    // the existing objects and set the new value
//                    migration.enumerateObjects(ofType: NotSureItem.className()) { oldObject, newObject in
//                        let text = oldObject!["text"] as! String
//                        newObject!["textDescription"] = "The title is \(text)"
//                    }
                    
                    // if you added a new property or removed a property you don't
                    // have to do anything because Realm automatically detects that
                }
        })
        Realm.Configuration.defaultConfiguration = configuration
        
        // opening the Realm file now makes sure that the migration is performed
        let realm = try! Realm()
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
         // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

