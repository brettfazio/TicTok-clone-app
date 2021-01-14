//
//  newLoginViewController.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 09/10/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import FBSDKLoginKit
import GoogleSignIn
import AuthenticationServices
import NVActivityIndicatorView

@available(iOS 13.0, *)
class newLoginViewController: UIViewController, UITabBarControllerDelegate {
    
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var fbView: UIView!
    @IBOutlet weak var googleView: UIView!
    @IBOutlet weak var siwaView: UIView!
    
    var first_name:String! = ""
    var last_name:String! = ""
    var email:String! = ""
    var socialID:String! = ""
    var profile_pic:String! = ""
    var signUPType:String! = ""
    var authToken:String! = ""
    var pass:String! = ""
    var dob:String! = ""
    
    var my_id = ""
    
    var deviceData = [String:String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewTapGesture()
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("dobNoti"), object: nil)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeBackgroundAni()
    }
    
    
    func changeBackgroundAni() {
//        let red   = CGFloat(211.0)
//        let green = CGFloat(211.0)
//        let blue  = CGFloat(211.0)
//        let alpha = CGFloat(0.5)

        UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)

        }, completion:nil)
    }
    // MARK:- view tap gesture
    func viewTapGesture(){
        let tapGoogleView = UITapGestureRecognizer(target: self, action: #selector(self.googleTouchTapped(_:)))
        self.googleView.addGestureRecognizer(tapGoogleView)
        
        let tapPhoneView = UITapGestureRecognizer(target: self, action: #selector(self.phoneTouchTapped(_:)))
        self.phoneView.addGestureRecognizer(tapPhoneView)
        
        let tapFbView = UITapGestureRecognizer(target: self, action: #selector(self.fbTouchTapped(_:)))
        self.fbView.addGestureRecognizer(tapFbView)
        
        let tapSIWAView = UITapGestureRecognizer(target: self, action: #selector(self.siwaTouchTapped(_:)))
        self.siwaView.addGestureRecognizer(tapSIWAView)
        
        
    }
    @objc func googleTouchTapped(_ sender: UITapGestureRecognizer) {
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    @objc func phoneTouchTapped(_ sender: UITapGestureRecognizer) {
    
        let vc = storyboard?.instantiateViewController(withIdentifier: "phoneNoVC") as! phoneNoViewController
        self.navigationController?.pushViewController(vc, animated: true)

        UserDefaults.standard.set("emailSignin", forKey: "signUpType")

      //  self.showToast(message: "Comming soon..", font: .systemFont(ofSize: 12))
    }
    @objc func fbTouchTapped(_ sender: UITapGestureRecognizer) {
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : LoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                    }
                }
            }
        }
    }
    
    @IBAction func btnSignup(_ sender: Any) {
        //self.showToast(message: "Comming soon..", font: .systemFont(ofSize: 12))
        
        UserDefaults.standard.set("emailSignup", forKey: "signUpType")
        let vc = storyboard?.instantiateViewController(identifier: "phoneNoVC") as! phoneNoViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func btnCross(_ sender: Any) {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        dismiss(animated: true, completion: nil)
//            let tabBarController = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
////        tabBarController.selectedIndex = 0
//        self.presentingViewController!.dismiss(animated: true, completion: {})
//        navigationController?.popToRootViewController(animated: true)
        
        print("dismiss vc")
    }
    



    // UITabBarControllerDelegate
    private func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        print("Selected view controller: ",viewController)
    }
    
    func getFBUserData(){
        
        //        let sv = HomeViewController.displaySpinner(onView: self.view)
        AppUtility?.startLoader(view: view)
        if((AccessToken.current) != nil){
            
            print("access token fb: ",AccessToken.current!)
            
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email,age_range"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    let dict = result as! [String : AnyObject]
                    print(dict)
                    if let dict = result as? [String : AnyObject]{
                        if(dict["email"] as? String == nil || dict["id"] as? String == nil || dict["email"] as? String == "" || dict["id"] as? String == "" ){
                            
                            //                            HomeViewController.removeSpinner(spinner: sv)
                            AppUtility?.stopLoader(view: self.view)
                            
                            self.alertModule(title:"Error", msg:"You cannot login with this facebook account because your facebook is not linked with any email")
                            
                        }else{
                            
                            //                            MARK:- FB DATA
                            //                            HomeViewController.removeSpinner(spinner: sv)
                            AppUtility?.stopLoader(view: self.view)
                            self.email = dict["email"] as? String
                            self.first_name = dict["first_name"] as? String
                            self.last_name = dict["last_name"] as? String
                            self.my_id = (dict["id"] as? String)!
                            let dic1 = dict["picture"] as! NSDictionary
                            let pic = dic1["data"] as! NSDictionary
                            self.profile_pic = pic["url"] as? String
                            self.socialID = dict["id"] as? String
                            self.authToken = AccessToken.current?.tokenString
                            
                            print("email: ",dict["email"] as? String)
                            
                            
                            print("email: \(self.email), name: \(self.my_id)")
                            
                            self.signUPType = "facebook"
                            self.checkAlreadyRegistered()
                            
                        }
                    }
                    
                }else{
                    AppUtility?.stopLoader(view: self.view)
                    //                    HomeViewController.removeSpinner(spinner: sv)

                }
            })
        }
        
    }
    
    @objc func siwaTouchTapped(_ sender: UITapGestureRecognizer) {
        
        self.setupAppleIDCredentialObserver()
        let appleSignInRequest = ASAuthorizationAppleIDProvider().createRequest()
        appleSignInRequest.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [appleSignInRequest])
        controller.delegate = self
        controller.presentationContextProvider = self
        
        controller.performRequests()
        
        
    }
    
    @available(iOS 13.0, *)
    private func setupAppleIDCredentialObserver() {
        let authorizationAppleIDProvider = ASAuthorizationAppleIDProvider()
        authorizationAppleIDProvider.getCredentialState(forUserID: "currentUserIdentifier") { (credentialState: ASAuthorizationAppleIDProvider.CredentialState, error: Error?) in
            if let error = error {
                print(error)
                // Something went wrong check error state
                return
            }
            switch (credentialState) {
            case .authorized:
                //User is authorized to continue using your app
                
                print("authorized")
                break
            case .revoked:
                //User has revoked access to your app
                break
            case .notFound:
                //User is not found, meaning that the user never signed in through Apple ID
                break
            default: break
            }
        }
    }
    
        //    MARK:- Terms & privacy
        @IBAction func privacy(_ sender: Any) {
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "termsCondVC") as! termsCondViewController
            vc.privacyDoc = true
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
    //        guard let url = URL(string: "https://termsfeed.com/privacy-policy/9a03bedc2f642faf5b4a91c68643b1ae") else { return }
    //        UIApplication.shared.open(url)
        }
        
        @IBAction func terms(_ sender: Any) {
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "termsCondVC") as! termsCondViewController
            vc.privacyDoc = false
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
            
    //        guard let url = URL(string: "https://termsfeed.com/terms-conditions/72b8fed5b38e082d48c9889e4d1276a9") else { return }
    //        UIApplication.shared.open(url)
            
        }
    
    func signUpWithSocial(){
        
    }
    
    //    MARK:- ALERT MODULE
    func alertModule(title:String,msg:String){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
}
@available(iOS 13.0, *)
extension newLoginViewController:GIDSignInDelegate{
    
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        //UIActivityIndicatorView.stopAnimating()
    }
    
    func signIn(signIn: GIDSignIn!,
                presentViewController viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func signIn(signIn: GIDSignIn!,
                dismissViewController viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if (error == nil) {
            // Perform any operations on signed in user here.
            self.GoogleApi(user: user)
            
            // ...
        } else {
            
            //            self.view.isUserInteractionEnabled = true
            //            KRProgressHUD.dismiss {
            //                print("dismiss() completion handler.")
            //
            //            }
            print("\(error.localizedDescription)")
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!){
        
    }
    
    
    
    func GoogleApi(user: GIDGoogleUser!){
        
        print("user.authentication.accessTokenExpirationDate: ",user.authentication.accessTokenExpirationDate)
        
        //        let sv = HomeViewController.displaySpinner(onView: self.view)
        AppUtility?.startLoader(view: view)
        
        if(user.profile.email == nil || user.userID == nil || user.profile.email == "" || user.userID == ""){
            
            //            HomeViewController.removeSpinner(spinner: sv)
            AppUtility?.stopLoader(view: self.view)
            alertModule(title:"Error", msg:"You cannot signup with this Google account because your Google is not linked with any email.")
            
        }else{
            
            //            HomeViewController.removeSpinner(spinner: sv)
            AppUtility?.stopLoader(view: self.view)
            //SliderViewController.removeSpinner(spinner: sv)
            self.email = user.profile.email
            self.first_name = user.profile.givenName
            self.last_name = user.profile.familyName
            self.socialID = user.userID
            self.authToken = user.authentication.accessToken
            
            print("user.authentication.accessToken: ",user.authentication.accessToken)

            print("user.userID: ",user.userID)
            
            UserDefaults.standard.set(user.authentication.accessToken, forKey: "authToken")
            UserDefaults.standard.set(user.authentication.accessToken, forKey: "socialUserID")
            
            print("email: ",email!)
            
            if user.profile.hasImage
            {
                let pic = user.profile.imageURL(withDimension: 100)
                self.profile_pic = pic!.absoluteString
                
            }else{
                self.profile_pic = ""
            }
            let userName = first_name+last_name
            
            self.signUPType = "gmail"

            checkAlreadyRegistered()
            
        }
    }
    
//    MARK:- Check already registered
    
    func checkAlreadyRegistered(){
        let userName = first_name+last_name
        let deviceToken = UserDefaults.standard.string(forKey: "deviceKey")
        print("Authtoken: ",authToken!)
        print("deviceToken: ",deviceToken!)
        print("social id: ",socialID)
        ApiHandler.sharedInstance.alreadySocialRegisteredUserCheck(social_id: socialID, social: signUPType, auth_token: authToken) { (isSuccess, response) in
            if isSuccess{
                print("response: ",response?.allValues)
                if response?.value(forKey: "code") as! NSNumber == 200 {

                    let userObjMsg = response?.value(forKey: "msg") as! NSDictionary
                    let userObj = userObjMsg.value(forKey: "User") as! NSDictionary
                    print("user obj: ",userObj)
                    //if user already registered code it
                    let user = User()

                    user.id = userObj.value(forKey: "id") as? String
                    user.active = userObj.value(forKey: "active") as? String
                    user.city = userObj.value(forKey: "city") as? String
                    
                    print("userID: ",userObj.value(forKey: "id") as? String)
                    //user id for login
                    UserDefaults.standard.set(userObj.value(forKey: "id") as? String, forKey: "userID")
                    
                    user.country = userObj.value(forKey: "country") as? String
                    user.created = userObj.value(forKey: "created") as? String
                    user.device = userObj.value(forKey: "device") as? String
                    user.dob = userObj.value(forKey: "dob") as? String
                    
                    user.email = userObj.value(forKey: "email") as? String
                    user.fb_id = userObj.value(forKey: "fb_id") as? String
                    
                    user.first_name = userObj.value(forKey: "first_name") as? String
                    user.gender = userObj.value(forKey: "gender") as? String
                    user.last_name = userObj.value(forKey: "last_name") as? String
                    user.ip = userObj.value(forKey: "ip") as? String
                    user.lat = userObj.value(forKey: "lat") as? String
                    user.long = userObj.value(forKey: "long") as? String
                    user.online = userObj.value(forKey: "online") as? String
                    user.password = userObj.value(forKey: "password") as? String
                    user.phone = userObj.value(forKey: "phone") as? String
                    
                    user.profile_pic = userObj.value(forKey: "profile_pic") as? String
                    user.role = userObj.value(forKey: "role") as? String
                    user.social = userObj.value(forKey: "social") as? String
                    user.social_id = userObj.value(forKey: "social_id") as? String
                    user.username = userObj.value(forKey: "username") as? String
                    user.verified = userObj.value(forKey: "verified") as? String
                    user.version = userObj.value(forKey: "version") as? String
                    user.website = userObj.value(forKey: "website") as? String
                    
                    user.comments = userObj.value(forKey: "comments") as? String
                    user.direct_messages = userObj.value(forKey: "direct_messages") as? String
                    
                    user.likes = userObj.value(forKey: "likes") as? String
                    user.mentions = userObj.value(forKey: "mentions") as? String
                    user.new_followers = userObj.value(forKey: "new_followers") as? String
                    user.video_updates = userObj.value(forKey: "video_updates") as? String
                    user.direct_message = userObj.value(forKey: "direct_message") as? String
                    
                    user.duet = userObj.value(forKey: "duet") as? String
                    user.liked_videos = userObj.value(forKey: "liked_videos") as? String
                    user.video_comment = userObj.value(forKey: "video_comment") as? String
                    user.videos_download = userObj.value(forKey: "videos_download") as? String
                    
                    AppUtility?.addDeviceData()
                    
                    if User.saveUserToArchive(user: [user]){
                        self.navigationController?.popToRootViewController(animated: true)
                        self.presentingViewController!.dismiss(animated: true, completion: nil)
                        self.tabBarController?.selectedIndex = 3
//                         self.showToast(message: "Signin", font: .systemFont(ofSize: 12))
                    }
                }else{
                    //                    self.alertModule(title: "Not Registered", msg: response?.value(forKey: "msg") as! String)
                    self.registerSocialUser()
                }
            }else{
                self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12.0))
            }
        }
    }
    /*
     func registerSocialUser(){
     let userName = first_name+last_name
     let deviceToken = UserDefaults.standard.string(forKey: "deviceKey")
     print("Authtoken: ",authToken!)
     print("deviceToken: ",deviceToken!)
     
     ApiHandler.sharedInstance.registerSocialUser(dob: self.dob, username: userName, email: self.email, social_id: self.socialID, social: self.signUPType, first_name: self.first_name, last_name: self.last_name, auth_token: self.authToken, device_token: deviceToken!) { (isSuccess, response) in
     if isSuccess{
     if response?.value(forKey: "code") as! NSNumber == 200 {
     self.alertModule(title: "Signin", msg: "\(userName) Successfully Registered" )
     }else{
     self.alertModule(title: "Not Registered", msg: response?.value(forKey: "msg") as! String)
     }
     }else{
     self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12.0))
     }
     }
     }
     */
    
    func registerSocialUser(){
        let alert = UIAlertController(title: NSLocalizedString("alert_app_name", comment: ""), message: "Want to create new account?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Signup", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                UserDefaults.standard.set(self.signUPType, forKey: "signUpType")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "dobVC") as! dobViewController
                
                vc.authToken = self.authToken
                vc.socialUserName = self.first_name+self.last_name
                vc.firstName = self.first_name
                vc.lastName = self.last_name
                vc.socialID = self.socialID
                vc.socialEmail = self.email
                vc.socialSignUpType = self.signUPType
                
                //                 vc.phoneNo = phoneNoNew
                self.navigationController?.pushViewController(vc, animated: true)
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            }}))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - - - - - Method for receiving Data through Post Notificaiton - - - - -
    @objc func methodOfReceivedNotification(notification: Notification) {
        print("Value of notification : ", notification.object ?? "")
        let dobNoti = notification.object as! String
        print("dob: ",dobNoti)
        self.dob = dobNoti
        
        //        self.SignUpApi()
    }
    
    
}
@available(iOS 13.0, *)
extension newLoginViewController: ASAuthorizationControllerDelegate {
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        
        print("User ID: \(appleIDCredential.user)")
        
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            print(appleIDCredential)
        case let passwordCredential as ASPasswordCredential:
            print(passwordCredential)
        default: break
        }
        
        
        if let userEmail = appleIDCredential.email {
            print("Email: \(userEmail)")
            self.email = userEmail
            self.my_id = appleIDCredential.user
        }
        
        if let userGivenName = appleIDCredential.fullName?.givenName,
            
            let userFamilyName = appleIDCredential.fullName?.familyName {
            //print("Given Name: \(userGivenName)")
            // print("Family Name: \(userFamilyName)",
            self.my_id = appleIDCredential.user
            self.first_name = userGivenName
            self.last_name = userFamilyName
            self.authToken = "\(appleIDCredential.authorizationCode?.base64EncodedString())"
            self.socialID = appleIDCredential.user
            self.signUPType = "apple"
            print("my id apple: ",my_id)
            //            checkAlreadyRegistered()
            
            
            if let authorizationCode = appleIDCredential.authorizationCode,
                let identifyToken = appleIDCredential.identityToken {
                print("Authorization Code: \(authorizationCode.base64EncodedString())")
                print("Identity Token: \(identifyToken)")
                //First time user, perform authentication with the backend
                //TODO: Submit authorization code and identity token to your backend for user validation and signIn
                
                self.signUPType = "apple"
                self.profile_pic = ""
                self.authToken = "\(authorizationCode.base64EncodedString())"
                self.socialID = appleIDCredential.user
                checkAlreadyRegistered()
                //                           self.SignUpApi()
                return
            }
            //                    MARK:- JK
        }else{
            //Next time get data from backend
            print("id: ",appleIDCredential.user)
            self.signUPType = "apple"
            self.profile_pic = ""
            self.authToken = "\(appleIDCredential.authorizationCode!.base64EncodedString())"
            self.socialID = appleIDCredential.user
            
            UserDefaults.standard.set(self.my_id, forKey: "uid")
            
            checkAlreadyRegistered()
            
        }
        
        
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Authorization returned an error: \(error.localizedDescription)")
    }
}

@available(iOS 13.0, *)
extension newLoginViewController: ASAuthorizationControllerPresentationContextProviding {
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

extension UIViewController {

    func presentDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        viewControllerToPresent.modalPresentationStyle = .fullScreen
        present(viewControllerToPresent, animated: false)
    }

    func dismissDetail() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)

        dismiss(animated: false)
    }
}


