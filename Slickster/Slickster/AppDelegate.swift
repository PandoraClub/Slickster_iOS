//
//  AppDelegate.swift
//  Slickster
//
//  Created by NonGT on 9/7/2558 BE.
//  Copyright (c) 2558 Donoma Solutions. All rights reserved.
//

import UIKit
import CoreData
import Parse
import ParseUI
import ParseFacebookUtilsV4
import ParseTwitterUtils
import DrawerController
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,
        PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate,
        GIDSignInDelegate {

    var window: UIWindow?

    let transitionManager: TransitionManager = TransitionManager()
    let reverseTransitionManager: TransitionManager = TransitionManager()

    let loginViewController = LogInViewController()
    let signupViewController = SignUpViewController()
    var tutorialViewController: TutorialViewController?

    var drawerController: DrawerController!
    var mainMenuViewController: MainMenuViewController!
    
    var bgRootImage: UIImageView?
    var topBarView: UIView?
    
    var autoOpenAgendaId: String?

    func application(application: UIApplication,
            didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Fabric.with([Crashlytics.self])
        
        // Setup parse
        let clientConfig = ParseClientConfiguration {
            $0.applicationId = Config.parse.appId
            $0.clientKey = Config.parse.clientKey
            $0.server = Config.parse.server
            $0.localDatastoreEnabled = true
        }
        
        Parse.initializeWithConfiguration(clientConfig)
        
        // Parse subclass register
        UserDetails.registerSubclass()
        UserAccount.registerSubclass()
        UserAgenda.registerSubclass()
        UserAgendaCalendar.registerSubclass()
        UserInterest.registerSubclass()
        
        // Parse Facebook Utils
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
                
        // Parse Twitter Utils
        // PFTwitterUtils.initializeWithConsumerKey()
        
        loginViewController.delegate = self
        signupViewController.delegate = self
        
        loginViewController.signUpController = signupViewController
        loginViewController.fields = [
            PFLogInFields.UsernameAndPassword,
            PFLogInFields.LogInButton,
            PFLogInFields.SignUpButton,
            PFLogInFields.Facebook,
            //PFLogInFields.Twitter,
            PFLogInFields.PasswordForgotten]
                
        // Google SignIn Initialization
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().delegate = self

        // NonGT: This is what client demands...
        NSThread.sleepForTimeInterval(2.0)
                
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        tutorialViewController = storyboard
            .instantiateViewControllerWithIdentifier("TutorialViewController") as? TutorialViewController
                
        // Show the root view.
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                
        if(PFUser.currentUser() != nil) {
            
            enterMainScreen(false)
            
        } else {
            
            self.window?.rootViewController = loginViewController
            self.window?.makeKeyAndVisible()
            self.window?.rootViewController!.view.hidden = false
            
            reverseTransitionManager.reverse = true
            tutorialViewController!.transitioningDelegate = reverseTransitionManager

            self.window?.rootViewController?.presentViewController(
                tutorialViewController!, animated: false, completion: nil)
        }
        
        return true
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
        
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    func addTopBarDecor() {
        
        if topBarView == nil {
            
            let mainViewController = self.drawerController.centerViewController as? MainViewController
            
            if(mainViewController == nil) {
                
                return
            }
            
            topBarView = UIView()
            topBarView?.backgroundColor = UIColor(rgb: 0x18141A)
            topBarView?.frame = CGRectMake(
                0, 0,
                UIScreen.mainScreen().bounds.width,
                80)
            
            let logo = UIImageView()
            logo.image = UIImage(named: "logo-text.png")
            
            let x = (UIScreen.mainScreen().bounds.width - mainViewController!.logoText!.frame.width) / 2
            let y = CGFloat(25)
            
            logo.frame = CGRectMake(
                x, y,
                mainViewController!.logoText!.frame.width,
                mainViewController!.logoText!.frame.height)
            
            topBarView!.addSubview(logo)
            
            window?.addSubview(topBarView!)
            window?.bringSubviewToFront(topBarView!)
            
            topBarView?.hidden = true
        }
    }
    
    func enterMainScreen(animated: Bool) {
     
        loginViewController.logInView?.passwordField?.text = ""
        
        // Prepare main controller.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController =
            storyboard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
        
        mainMenuViewController = MainMenuViewController()
        
        self.drawerController = DrawerController(
            centerViewController: mainViewController,
            leftDrawerViewController: mainMenuViewController)
        
        let bgImage = UIImageView(image: UIImage(named: "main-bg.png"))
        bgImage.contentMode = .ScaleAspectFill
        bgImage.frame = CGRectMake(
            0, 0,
            UIScreen.mainScreen().bounds.width,
            UIScreen.mainScreen().bounds.height)
        
        self.drawerController.view.addSubview(bgImage)
        self.drawerController.view.sendSubviewToBack(bgImage)
        
        if bgRootImage == nil {
            
            bgRootImage = UIImageView(image: UIImage(named: "main-bg.png"))
            bgRootImage!.contentMode = .ScaleAspectFill
            bgRootImage!.frame = CGRectMake(
                0, 0,
                UIScreen.mainScreen().bounds.width,
                UIScreen.mainScreen().bounds.height)

            window?.addSubview(bgRootImage!)
            window?.sendSubviewToBack(bgRootImage!)
        }
        
        addTopBarDecor()
        
        self.drawerController.showsShadows = false
        
        self.drawerController.restorationIdentifier = "Drawer"
        self.drawerController.transitioningDelegate = self.transitionManager
        self.drawerController.maximumLeftDrawerWidth = (self.window?.bounds.width)! - 50
        self.drawerController.openDrawerGestureModeMask = .All
        self.drawerController.closeDrawerGestureModeMask = .All
        
        self.drawerController.drawerVisualStateBlock = {
            (drawerController, drawerSide, percentVisible) in
            
            let block = DrawerVisualStateManager
                .sharedManager.drawerVisualStateBlockForDrawerSide(drawerSide)
            
            block?(drawerController, drawerSide, percentVisible)
            mainViewController.updateBackgroundConstraint(drawerController, percent: percentVisible)
        }
        
        print("enter mainscreen \(animated)")
        
        if(animated) {
            
            self.window?.rootViewController?.presentViewController(
                drawerController, animated: animated, completion: nil)
            
            self.window?.rootViewController?.view.hidden = false
            self.drawerController.view.hidden = false
            
        } else {
            
            self.window?.rootViewController = self.drawerController
            self.window?.makeKeyAndVisible()
        }
    }
    
    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.donoma.Slickster" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] 
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Slickster", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Slickster.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch var error1 as NSError {
            error = error1
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        } catch {
            fatalError()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch let error1 as NSError {
                    error = error1
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    NSLog("Unresolved error \(error), \(error!.userInfo)")
                    abort()
                }
            }
        }
    }
    
    // MARK: - PFLogInViewControllerDelegate
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) -> Void {
        
        enterMainScreen(true)
    }
    
    // MARK: - PFSignUpViewControllerDelegate
    
    func signUpViewController(
        signUpController: PFSignUpViewController, didSignUpUser user: PFUser) -> Void {
            
        //self.loginViewController.logInView!.hidden = true

        self.window?.rootViewController?.dismissViewControllerAnimated(true, completion: {
            
            self.enterMainScreen(true)
        })
    }
    
    // MARK: - Facebook / Google Login With Parse

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        // FB Result.
        let fbResult = FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        
        if(fbResult) {
            
            return true
        }
        
        // Google Result.
        let gResult = GIDSignIn.sharedInstance().handleURL(url,
            sourceApplication: sourceApplication, annotation: annotation)
        
        if(gResult) {
            
            return true
        }
        
        // Slickster URL.
        if url.scheme == "slicksterapp" {
            
            let parts = url.query?.characters.split{$0 == "="}.map(String.init)
            if parts == nil || parts!.count < 2 {
                
                return false
            }
            
            let id = parts![1]
            showSharedAgenda(id)

            return true
        }
        
        return false
    }
    
    // MARK: - Google Sign In
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
            
        if (error == nil) {
            
            PFUser.logInWithUsernameInBackground(
                user.userID, password: Config.parse.secret3rdPassword,
                block: { (loggedInUser, error) in
                    
                    if error != nil {
                        
                        let userId = user.userID
                        let idToken = user.authentication.idToken
                        let name = user.profile.name
                        let email = user.profile.email
                        let imageUrl = user.profile.imageURLWithDimension(100)
                        
                        print("creating 3rd party user")
                        
                        UserManager.sharedInstance.create3rdParseUser(userId,
                            token: idToken, name: name,
                            email: email, imageUrl: imageUrl, service: "google",
                            callback: { (user, error) in
                                
                            print("create 3rd party user success")
                                
                            if(PFUser.currentUser() != nil) {
                                
                                self.enterMainScreen(true)
                            }
                        })
                        
                    } else {
                        
                        if(PFUser.currentUser() != nil) {
                            
                            self.enterMainScreen(true)
                        }
                    }
                })
            
        } else {
            
            print("\(error.localizedDescription)")
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!, withError error: NSError!) {
        
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    func showSharedAgenda(id: String) {
        
        if(PFUser.currentUser() == nil) {
         
            autoOpenAgendaId = id
            return
        }
        
        let mainViewController = self.drawerController
            .centerViewController as? MainViewController
        
        if(mainViewController == nil) {
            
            return
        }
        
        mainViewController!.showSharedAgenda(id)
    }
}

