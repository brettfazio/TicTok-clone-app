//
//  AppDelegate.swift
//  tictic
//
//  Created by Junaid Kamoka on 24/04/2019.
//  Copyright © 2019 Junaid Kamoka. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FBSDKCoreKit
import FirebaseCore
import FirebaseMessaging
import GoogleSignIn
import UserNotifications
import UserNotifications
import FirebaseInstanceID

let NextLevelAlbumTitle = "NextLevel"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInDelegate,UNUserNotificationCenterDelegate,MessagingDelegate {

    var window: UIWindow?
    
    // Web Apis Urls
    
//    var baseUrl:String? = "http://domain/API/tictic/index.php?p="
    var baseUrl:String? = "http://bringthings.com/API/tictic/?p="
    var imgbaseUrl:String? = "http://bringthings.com/API/tictic/"
    var sharURl:String? =  "http://bringthings.com/"
    var signUp:String? = "signup"
    var uploadVideo:String? = "uploadVideo_json"
    var showAllVideos:String? = "showAllVideos"
    var showMyAllVideos:String? = "showMyAllVideos"
    var likeDislikeVideo:String? = "likeDislikeVideo"
    var postComment:String? = "postComment"
    var showVideoComments:String? = "showVideoComments"
    var updateVideoView:String? = "updateVideoView"
    var fav_sound:String? = "fav_sound"
    var my_FavSound:String? = "my_FavSound"
    var allSounds:String? = "allSounds"
    var my_liked_video:String? = "my_liked_video"
    var discover:String? = "discover"
    var edit_profile:String? = "edit_profile"
    var follow_users:String? = "follow_users"
    var get_user_data:String? = "get_user_data"
    var uploadImage:String? = "uploadImage"
    var get_followers:String? = "get_followers"
    var get_followings:String? = "get_followings"
    var downloadFile:String? = "downloadFile"
    var getNotifications:String? = "getNotifications"
    
    var uploadMultipartVideo:String? = "uploadVideo"



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        let uid = UIDevice.current.identifierForVendor!.uuidString
//        settingUDID(uid:uid)
 
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        GIDSignIn.sharedInstance().clientID = "964642536474-jaldv56dmv19ijuc9nqfos51rt5rji85.apps.googleusercontent.com"
//         GIDSignIn.sharedInstance().clientID = "964642536474-a56q1usomp30acldh0u6udtaid38962e.apps.googleusercontent.com"
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound],
                                           categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        
          ApplicationDelegate.shared.application(
                  application,
                  didFinishLaunchingWithOptions: launchOptions
              )
        
        UserDefaults.standard.set("", forKey: "otherUserID")
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
       
        
        let handled=ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        
        return GIDSignIn.sharedInstance().handle(url)  || handled
    }
    
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }

        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
    }
    
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            // ...
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    // Register Push Notifications Methods
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
                
                UserDefaults.standard.set("NuLL", forKey:"DeviceToken")
               
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                UserDefaults.standard.set(result.token, forKey:"DeviceToken")
            }
        }
        
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Registration failed!")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
      
    }
    
    // Firebase notification received
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .badge, .sound])
        
        // custom code to handle push while app is in the foreground
        print("Handle push from foreground, received: \n \(notification.request.content)")
        print(notification.request.content.userInfo)
       
        
    }
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Handle tapped push from background, received: \n \(response.notification.request.content)")

        completionHandler()
    }
    
    func application(received remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        
        UserDefaults.standard.set(fcmToken, forKey:"DeviceToken")
        print("fcm firebase token notification: ",fcmToken)
    }
    
    
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!){
        
        
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

