//
//  nameViewController.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 12/10/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit

class nameViewController: UIViewController,UITextFieldDelegate {
    
    var dob = ""
    var phoneNo = ""
    var username = ""
    
    var email = ""
    var pass = ""
    
    var socialEmail = ""
    var socialID = ""
    var authToken = ""
    var firstName = ""
    var lastName = ""
    var socialUserName = ""
    var socialSignUpType = ""
    
    var fromVC = ""
    
    @IBOutlet weak var usernameTxtField: UITextField!
    @IBOutlet weak var btnSignup: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSignup.backgroundColor = #colorLiteral(red: 0.9528577924, green: 0.9529947639, blue: 0.9528278708, alpha: 1)
        btnSignup.setTitleColor(#colorLiteral(red: 0.6437677741, green: 0.6631219387, blue: 0.6758852601, alpha: 1), for: .normal)
        btnSignup.isUserInteractionEnabled = false
        
        if socialUserName != ""{
            usernameTxtField.text = socialUserName
        }
        usernameTxtField.addTarget(self, action: #selector(nameViewController.textFieldDidChange(_:)), for: .editingChanged)
        // Do any additional setup after loading the view.
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        let textCount = usernameTxtField.text?.count
        
        print("change textCount: ",textCount!)
        if textCount! > 3{
            btnSignup.backgroundColor = #colorLiteral(red: 0.9847028852, green: 0.625120461, blue: 0.007359095383, alpha: 1)
            btnSignup.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            btnSignup.isUserInteractionEnabled = true
        }else{
            btnSignup.backgroundColor = #colorLiteral(red: 0.9528577924, green: 0.9529947639, blue: 0.9528278708, alpha: 1)
            btnSignup.setTitleColor(#colorLiteral(red: 0.6437677741, green: 0.6631219387, blue: 0.6758852601, alpha: 1), for: .normal)
            btnSignup.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func btnSignup(_ sender: Any) {
        self.username = usernameTxtField.text!
        print("username: ",username)
        print("dob: ",dob)
        print("phoneNo: ",phoneNo)
        
        let type = UserDefaults.standard.string(forKey: "signUpType")!
        print("signup type: ",type)
        
        if email != ""{
            print("email signup")
            registerEmail()
        }
        
        if phoneNo != ""{
            print("password signup")
            registerPhoneNo()
        }
        
        if socialEmail != "" || socialID != ""{
            print("social signup")
            registerSocialUser()
        }
        
    }
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    func registerPhoneNo(){
        dismiss(animated: true, completion: nil)
        print("username: ",username)
        
        AppUtility?.startLoader(view: self.view)
        
        ApiHandler.sharedInstance.registerPhone(phone: phoneNo, dob: dob, username: username) { (isSuccess, response) in
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    AppUtility?.stopLoader(view: self.view)
                    
                    self.showToast(message: "Registered", font: .systemFont(ofSize: 12))
                    sleep(2)
                    
                    
                    let userObjMsg = response?.value(forKey: "msg") as! NSDictionary
                    let userObj = userObjMsg.value(forKey: "User") as! NSDictionary
                    print("user obj: ",userObj)
                    //if user already registered code it
                    let user = User()
                    
                    
                    user.id = userObj.value(forKey: "id") as? String
                    user.active = userObj.value(forKey: "active") as? String
                    user.city = userObj.value(forKey: "city") as? String
                    
                    //user id for login
                    UserDefaults.standard.set(userObj.value(forKey: "id") as? String, forKey: "userID")
                    UserDefaults.standard.set(userObj.value(forKey: "auth_token") as? String, forKey: "authToken")

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
                        NotificationCenter.default.post(name: Notification.Name("dismissVCnoti"), object: nil)
                    }

                }else{
                    AppUtility?.stopLoader(view: self.view)
                    self.alertModule(title: NSLocalizedString("alert_app_name", comment: ""), msg: response?.value(forKey: "msg") as! String)
                    
                }
            }
        }
    
        
    }
    
    func registerEmail(){
        
        print("email: ",email)
        print("pass: ",pass)
        print("dob: ",dob)
        print("username: ",username)
        AppUtility?.startLoader(view: self.view)
        ApiHandler.sharedInstance.registerEmail(email: email, password: pass, dob: dob, username: username) { (isSuccess, response) in
            
            print("Response: ",response)
                        if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    AppUtility?.stopLoader(view: self.view)
                    
                    self.showToast(message: "Registered", font: .systemFont(ofSize: 12))
                    sleep(2)
                    
                    
                    let userObjMsg = response?.value(forKey: "msg") as! NSDictionary
                    let userObj = userObjMsg.value(forKey: "User") as! NSDictionary
                    print("user obj: ",userObj)
                    //if user already registered code it
                    let user = User()
                    
                    
                    user.id = userObj.value(forKey: "id") as? String
                    user.active = userObj.value(forKey: "active") as? String
                    user.city = userObj.value(forKey: "city") as? String
                    
                    //user id for login
                    UserDefaults.standard.set(userObj.value(forKey: "id") as? String, forKey: "userID")
                    UserDefaults.standard.set(userObj.value(forKey: "auth_token") as? String, forKey: "authToken")

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
                        NotificationCenter.default.post(name: Notification.Name("dismissVCnoti"), object: nil)
                    }

                }else{
                    AppUtility?.stopLoader(view: self.view)
                    self.alertModule(title: NSLocalizedString("alert_app_name", comment: ""), msg: response?.value(forKey: "msg") as! String)
                    
                }
            }else{
                AppUtility?.stopLoader(view: self.view)
                self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12.0))
            }

        }
        
    }
    
    func registerSocialUser(){
        
        AppUtility?.startLoader(view: self.view)
        let deviceToken = UserDefaults.standard.string(forKey: "deviceKey")
        let signUPType = UserDefaults.standard.string(forKey: "signUpType")
        
        print("Authtoken: ",authToken)
        print("deviceToken: ",deviceToken!)

        ApiHandler.sharedInstance.registerSocialUser(dob: self.dob, username: username, email: self.socialEmail, social_id: self.socialID, social: signUPType!, first_name: self.firstName, last_name: self.lastName, auth_token: self.authToken, device_token: deviceToken!) { (isSuccess, response) in
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200 {
                   // self.alertModule(title: "Signin", msg: "\(self.username) Successfully Registered" )
                    AppUtility?.stopLoader(view: self.view)
                    self.showToast(message: "\(self.username) Successfully Registered", font: .systemFont(ofSize: 12))
                    
                    let userObjMsg = response?.value(forKey: "msg") as! NSDictionary
                     let userObj = userObjMsg.value(forKey: "User") as! NSDictionary
                     print("user obj: ",userObj)
                    let user = User()

                    user.id = userObj.value(forKey: "id") as? String
                    user.active = userObj.value(forKey: "active") as? String
                    user.city = userObj.value(forKey: "city") as? String
                    
                    //user id for login
                    UserDefaults.standard.set(userObj.value(forKey: "id") as? String, forKey: "userID")
                    UserDefaults.standard.set(userObj.value(forKey: "auth_token") as? String, forKey: "authToken")

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
                        NotificationCenter.default.post(name: Notification.Name("dismissVCnoti"), object: nil)
                    }
                    
                }else{
                    self.alertModule(title: "Not Registered", msg: response?.value(forKey: "msg") as! String)
                }
            }else{
                self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12.0))
            }
        }
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
