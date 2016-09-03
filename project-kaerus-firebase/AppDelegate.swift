//
//  AppDelegate.swift
//  project-kaerus-firebase
//
//  Created by Brandon Chen on 7/15/16.
//  Copyright © 2016 Brandon Chen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import FBSDKCoreKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	
	override init() {
		FIRApp.configure()
//		FIRDatabase.database().persistenceEnabled = true
	}
	
	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
		// Override point for customization after application launch.
		OneSignal.registerForPushNotifications()
		
		OneSignal.initWithLaunchOptions(launchOptions, appId: "da90c42a-5313-4857-94cd-f323c2261a00",
		                                handleNotificationReceived: { (notification) in self.notifRcv(notification) },
			handleNotificationAction: { (result) in self.notifAct(result) },
			settings: [kOSSettingsKeyAutoPrompt : false, kOSSettingsKeyInAppAlerts : false])
		
		let user = FIRAuth.auth()?.currentUser
		if user != nil { // user is logged in so load their info and go to loadingViewController
			let loadVC = self.window?.rootViewController as! LoadingViewController
			loadVC.user = user
		} else { // not logged in, go to loginViewController
			let loginStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
			let loginVC : UIViewController = loginStoryboard.instantiateViewControllerWithIdentifier("loginViewController") as! LoginViewController
			self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
			self.window?.rootViewController = loginVC
			self.window?.makeKeyAndVisible()
		}
		
		return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
	}
	
	// called when user is in app and receives a notification
	func notifRcv(notification: OSNotification!) {
		print("notification received while user was in app")
	}
	
	// called when user opens notification
	func notifAct(result: OSNotificationOpenedResult!) {
		print("notification opened")
//		let loadVC = self.window?.rootViewController as! LoadingViewController
//		print("did")
////		if result.notification.
//		loadVC.selectedIndex = 2
//		print("leaving")
	}
 
	func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
		print("Failed to register:", error)
	}
	
	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
		FBSDKAppEvents.activateApp()
	}
	
	func applicationDidEnterBackground(application: UIApplication) {
	}
	
	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}
	
	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}
	
	
	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
	
	func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
		return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
	}
}

