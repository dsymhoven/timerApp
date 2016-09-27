//
//  AppDelegate.swift
//  TimerApp
//
//  Created by David Symhoven on 26.05.16.
//  Copyright © 2016 David Symhoven. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import UserNotifications
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Fabric.with([Crashlytics.self])
        GADMobileAds.configure(withApplicationID:PrivateConstants.adMobAppId);
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("Application did enter background")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        print("Application will enter foreground")
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("Application did become active")
        
        }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(handle(shortcutItem: shortcutItem))
    }

    /**
     accesses an instance of SpeechViewController via window property and starts a new timer with the respective selected pause from the quick action item if a timer is not already running.
     
     - parameters:
        - shortcutItem: An UIApplicationShortcutItem object associated with the quick action
     

    - returns: Bool value. True if handling was successful, false otherwise
     
     Called from the completionHandler of application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) method.
     If a cast of rootViewController as SpeechViewController is successful check if a timer is not already running via "isSelected" property of startStopButton. If a timer is already running the user is not allowed to overwrite the existing one. If the timer is not active yet get the seconds the user selected in the shortcutItem and assign the value to the totalPause property of SpeechViewController. In addition change the pickerView to the respective row, set isSelected proeprty of startStopButton to true and start a new timer.
     */
    private func handle(shortcutItem:UIApplicationShortcutItem ) -> Bool {
        var succeeded = false
        
            if let svc = self.window!.rootViewController as? SpeechViewController{
                if svc.startStopButton.isSelected == false{
                    let totalPauseAsString: String = shortcutItem.localizedTitle.replacingOccurrences(of: " sec", with: "")
                    if let rowOfPickerViewForTotalPause = svc.pickerData.index(of: totalPauseAsString){
                        svc.pickerView.selectRow(rowOfPickerViewForTotalPause, inComponent: 0, animated: true)
                    }
                
                    svc.totalPause = Int(totalPauseAsString)
                    svc.startStopButton.isSelected = true
                    svc.startTimer()
                    succeeded = true
                }
            }
        
        return succeeded
    }
}

