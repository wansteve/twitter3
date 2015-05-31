//
//  AppDelegate.swift
//  Twitter
//
//  Created by Steve Wan on 5/20/15.
//  Copyright (c) 2015 Steve Wan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var storyboard = UIStoryboard(name: "Main", bundle: nil)


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDidLogout", name: userDidLoginNotification, object: nil)
        
        
        if User.currentUser != nil {
            // Go to the logged in screen
            println("Current user detected: \(User.currentUser?.name)")
            var vc = storyboard.instantiateViewControllerWithIdentifier("TweetsViewController") as! UIViewController
            window?.rootViewController = vc
            
        }


        /* FIXED
        let vc1 = UIViewController()
        let vc2 = UIViewController()
        let vc3 = UIViewController()
        
        vc1.view.backgroundColor = UIColor.redColor()
        vc2.view.backgroundColor = UIColor.greenColor()
        vc3.view.backgroundColor = UIColor.blueColor()
        
        vc1.title = "One"
        vc2.title = "Two"
        vc3.title = "Three"
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let viewController = storyboard.instantiateViewControllerWithIdentifier("IdentifierThatWasSetInStoryboard") as MyViewControllerClass
        let menuViewController = storyboard.instantiateViewControllerWithIdentifier("MenuViewController") as! UIViewController
//        let menuViewController = MenuViewController(nibName: "MenuViewController", bundle: nil)
//        let menuViewController = MenuViewController(nibName: "MenuViewController")
        
        // the window object is already created for us since this is a storyboard app
        // we would have to initialize this manually in non-storyboard apps
        window?.rootViewController = menuViewController
        
// FIXED        menuViewController.viewControllers = [vc1, vc2, vc3]

        */
        return true
    }
    
    func userDidLogout() {
        var vc = storyboard.instantiateInitialViewController() as! UIViewController
        window?.rootViewController = vc

    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        
        TwitterClient.sharedInstance.openURL(url)

        return true
    }
}

