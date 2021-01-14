//
//  ApiHandler.swift
//  Tik Tik
//
//  Created by Junaid Kamoka on 2020/10/3.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


var baseUrl = "http://apps.domain.com/"
let apiKEY = "fill your API-KEY here"
var imgBaseUrl = "\(baseUrl)musictok/"

private let SharedInstance = ApiHandler()

enum Endpoint : String {
    
    case registerUser            = "registerUser"
    case login                   = "login"
    case verifyPhoneNo           = "verifyPhoneNo"
    case addDeviceData           = "addDeviceData"
    case registerDevice          = "registerDevice"
    case showDeviceDetail        = "showDeviceDetail"
    case postVideo               = "postVideo"
    case showRelatedVideos       = "showRelatedVideos"
    case showFollowingVideos     = "showFollowingVideos"
    case showVideosAgainstUserID = "showVideosAgainstUserID"
    case showUserDetail          = "showUserDetail"
    case likeVideo               = "likeVideo"
    case watchVideo              = "watchVideo"
    case showSounds              = "showSounds"
    case addSoundFavourite       = "addSoundFavourite"
    case showFavouriteSounds     = "showFavouriteSounds"
    case showUserLikedVideos     = "showUserLikedVideos"
    case followUser              = "followUser"
    case showDiscoverySections   = "showDiscoverySections"
    case showVideoComments       = "showVideoComments"
    case postCommentOnVideo      = "postCommentOnVideo"
    case editProfile             = "editProfile"
    case showFollowers           = "showFollowers"
    case showFollowing           = "showFollowing"
    case showVideosAgainstHashtag = "showVideosAgainstHashtag"
    case sendMessageNotification = "sendMessageNotification"
    case addUserImage            = "addUserImage"
    case deleteVideo             = "admin/deleteVideo"
    case search                  = "search"
    case showVideoDetail         = "showVideoDetail"
    case showAllNotifications    = "showAllNotifications"
    case userVerificationRequest = "userVerificationRequest"
    case downloadVideo           = "downloadVideo"
    case deleteWaterMarkVideo    = "deleteWaterMarkVideo"
    case showAppSlider           = "showAppSlider"
    case logout                  = "logout"
    case showVideosAgainstSound  = "showVideosAgainstSound"
    case showReportReasons       = "showReportReasons"
    case NotInterestedVideo      = "NotInterestedVideo"
    case addVideoFavourite       = "addVideoFavourite"
    case showFavouriteVideos     = "showFavouriteVideos"
    case updatePushNotificationSettings  = "updatePushNotificationSettings"
    case addHashtagFavourite     =  "addHashtagFavourite"
    case showFavouriteHashtags   = "showFavouriteHashtags"
    case reportUser              = "reportUser"
    case addPrivacySetting       = "addPrivacySetting"
    case reportVideo             = "reportVideo"
    case blockUser             = "blockUser"
    case showSoundsAgainstSection   = "showSoundsAgainstSection"
    
}
class ApiHandler:NSObject{
    var baseApiPath:String!
    var apiKey = apiKEY
    class var sharedInstance : ApiHandler {
        return SharedInstance
    }
    
    override init() {
        self.baseApiPath = "\(imgBaseUrl)api/"
    }
    
    //MARK:Register
    func registerSocialUser(dob:String,username:String,email:String,social_id:String ,social:String,first_name:String,last_name:String,auth_token:String,device_token:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":apiKey
            
        ]
        var parameters = [String : String]()
        parameters = [
            "dob"         : dob,
            "username"    : username,
            "email"       : email,
//            "password"    : password,
            "social_id"   : social_id,
            "social"      : social,
            "first_name"  : first_name,
            "last_name"   : last_name,
            "auth_token"  : auth_token,
            "device_token": device_token
            
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.registerUser.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    
        func alreadySocialRegisteredUserCheck(social_id:String,social:String,auth_token:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
            let headers: HTTPHeaders = [
                "Api-Key":apiKey,
                
            ]
            var parameters = [String : String]()
            parameters = [
    //            "dob"         : dob,
    //            "username"    : username,
    //            "email"       : email,
    //            "password"    : password,
                "social_id"   : social_id,
                "social"      : social,
    //            "first_name"  : first_name,
    //            "last_name"   : last_name,
                "auth_token"  : auth_token
    //            "device_token": device_token,
                
                
            ]
            let finalUrl = "\(self.baseApiPath!)\(Endpoint.registerUser.rawValue)"
            
            print(finalUrl)
            print(parameters)
            AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                    print(response.result)

                    switch response.result {

                    case .success(_):
                        if let json = response.value
                        {
                            do {
                                let dict = json as? NSDictionary
                                print(dict)
                                completionHandler(true, dict)
                                
                            } catch {
                                completionHandler(false, nil)
                            }
                        }
                        break
                    case .failure(let error):
                        if let json = response.value
                        {
                            do {
                                let dict = json as? NSDictionary
                                print(dict)
                                
                                completionHandler(true, dict)
                                
                            } catch {
                                completionHandler(false, nil)
                            }
                        }
                        break
                    }
                }
        }
    
    
    
    //MARK:- Login
    func login(email:String,password:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":apiKey,
            "User_Id":"",
            "Auth_token" : ""
        ]
        var parameters = [String : String]()
        parameters = [
            
            "email"   : email,
            "password": password,
        
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.login.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    
    //MARK:- Verify Phone number
    func verifyPhoneNo(phone:String,verify:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":apiKey
        ]
        var parameters = [String : String]()
        parameters = [
            
            "phone" : phone,
            "verify": verify,
           // "code"  : code,
            
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.verifyPhoneNo.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    //OTP VERIFY
    func verifyOTP(phone:String,verify:String,code:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":apiKey
        ]
        var parameters = [String : String]()
        parameters = [
            
            "phone" : phone,
            "verify": verify,
            "code"  : code
            
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.verifyPhoneNo.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    
    //register Phone no check
    func registerPhoneCheck(phone:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
            let headers: HTTPHeaders = [
                "Api-Key":apiKey
            ]
            var parameters = [String : String]()
            parameters = [
                "phone"         : phone
            ]
            let finalUrl = "\(self.baseApiPath!)\(Endpoint.registerUser.rawValue)"
            
            print(finalUrl)
            print(parameters)
            AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                    print(response.result)

                    switch response.result {

                    case .success(_):
                        if let json = response.value
                        {
                            do {
                                let dict = json as? NSDictionary
                                print(dict)
                                completionHandler(true, dict)
                                
                            } catch {
                                completionHandler(false, nil)
                            }
                        }
                        break
                    case .failure(let error):
                        if let json = response.value
                        {
                            do {
                                let dict = json as? NSDictionary
                                print(dict)
                                
                                completionHandler(true, dict)
                                
                            } catch {
                                completionHandler(false, nil)
                            }
                        }
                        break
                    }
                }
        }
    //MARK:- register Phone
    func registerPhone(phone:String,dob:String,username:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":apiKey
        ]
        var parameters = [String : String]()
        parameters = [
            "dob"         : dob,
            "phone"         : phone,
            "username"         : username
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.registerUser.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
//    MARK:- Register With EMAIL
    func registerEmail(email:String,password:String,dob:String,username:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":apiKey
        ]
        var parameters = [String : String]()
        parameters = [
            "dob"         : dob,
            "email"         : email,
            "username"         : username,
            "password"         : password
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.registerUser.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    
//    MARK:- login with EMAIL
    func loginEmail(email:String,password:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":apiKey
        ]
        var parameters = [String : String]()
        parameters = [
            "email"         : email,
            "password"         : password
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.login.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    
    //MARK:- Add Device Data
    
    func addDeviceData(user_id:String,device:String,version:String,ip:String,device_token:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": apiKey
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"      : user_id,
            "device"       : device,
            "version"      : version,
            "ip"           : ip,
            "device_token" : device_token,
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.addDeviceData.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    
    //MARK:- registerDevice
    
    func registerDevice(key:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":apiKey

        ]
        var parameters = [String : String]()
        parameters = [
            "key"      : key
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.registerDevice.rawValue)"
        
        print(finalUrl)
        print(parameters)
        print(headers)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    //MARK:- showDeviceDetail
    
    func showDeviceDetails(key:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":apiKey
        ]
        var parameters = [String : String]()
        parameters = [
            "key"      : key

        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showDeviceDetail.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
   
    //MARK:- postVideo
    
//    IN POST VIEW CONTROLLER CODE MULTIPART
    func postVideo(User_id :String ,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":apiKey,
            "User-Id":User_id
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.postVideo.rawValue)"
        
        print(finalUrl)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    
    
    //MARK:-showRelatedVideos
    func showRelatedVideos(device_id:String,user_id:String,starting_point:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
             "Api-Key": apiKey
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"        : user_id,
            "device_id"      : device_id,
            "starting_point" : starting_point
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showRelatedVideos.rawValue)"
        
        print("finalURL",finalUrl)
        print(parameters)
        print(headers)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default
            , headers: headers).responseJSON { (response) in
                print("response: related vid",response.value)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    print("Failure")
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    //MARK:-showFollowingVideos
    func showFollowingVideos(user_id:String,device_id:String,starting_point:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":apiKey,
            "User_Id":user_id,
//            "Auth_token" : UserDefaults.standard.string(forKey: "authToken")!
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"        : user_id,
            "device_id"      : device_id,
            "starting_point" : starting_point
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showFollowingVideos.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    //MARK:-showVideosAgainstUserID
    func showVideosAgainstUserID(user_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
                "Api-Key": apiKey
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"        : user_id,
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showVideosAgainstUserID.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    
    //MARK:-showOtherUserDetail
    func showOtherUserDetail(user_id:String,other_user_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":apiKey
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"        : user_id,
            "other_user_id"  : other_user_id
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showUserDetail.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    //MARK:-showOwnDetail
    func showOwnDetail(user_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":apiKey
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"        : user_id
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showUserDetail.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    //MARK:-LikeVideo
    func likeVideo(user_id:String,video_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": apiKey
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"        : user_id,
            "video_id"       : video_id,
            
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.likeVideo.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    
    //MARK:-WatchVideo
    func watchVideo(device_id:String,video_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": apiKey
        ]
        var parameters = [String : String]()
        parameters = [
            "device_id"        : device_id,
            "video_id"         : video_id,
            
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.watchVideo.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    
    //MARK:-showSounds
    func showSounds(user_id:String,starting_point:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": apiKey
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"          : user_id,
            "starting_point"   : starting_point,
            
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showSounds.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    

    //MARK:-addSoundFavourite
    func addSoundFavourite(user_id:String,sound_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": apiKey
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"    : user_id,
            "sound_id"   : sound_id,
            
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.addSoundFavourite.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    
    
    //MARK:-showSounds
    func showSoundsAgainstSection(user_id:String,starting_point:String,sectionID:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": apiKey
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"          : user_id,
            "starting_point"   : starting_point,
            "sound_section_id"   : sectionID
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showSoundsAgainstSection.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    //MARK:-showFavouriteSounds
    func showFavouriteSounds(user_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": apiKey
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"    : user_id,
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showFavouriteSounds.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    
    //MARK:-showUserLikedVideos
    func showUserLikedVideos(user_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": apiKey
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"    : user_id,
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showUserLikedVideos.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    
    
    //MARK:-followUser
    func followUser(sender_id:String,receiver_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":apiKey
        ]
        var parameters = [String : String]()
        parameters = [
            "sender_id"    : sender_id,
            "receiver_id"  : receiver_id
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.followUser.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    
    
    //MARK:- showDiscoverySections
    
    func showDiscoverySections(completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showDiscoverySections.rawValue)"
        let headers: HTTPHeaders = [
             "Api-Key":apiKey
         ]
         var parameters = [String : String]()
        parameters = [ "":""
             
         ]
        print(finalUrl)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    
    //MARK:-showVideoComments
    func showVideoComments(video_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": apiKey
        ]
        var parameters = [String : String]()
        parameters = [
            "video_id"    : video_id
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showVideoComments.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    //MARK:- postCommentOnVideo
    func postCommentOnVideo(user_id:String,comment:String,video_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.postCommentOnVideo.rawValue)"
        let headers: HTTPHeaders = [
            "Api-Key": apiKey
        ]
        var parameters = [String : String]()
        parameters = [
            "video_id"    : video_id,
            "comment"    : comment,
            "user_id"    : user_id
        ]
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    
    //MARK:- editProfile
    func editProfile(username:String,user_id:String,first_name:String,last_name:String,gender:String,website:String,bio:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.editProfile.rawValue)"
        
        let headers: HTTPHeaders = [
            "Api-Key": apiKey
        ]
        
        var parameteres = [String:String]()
        parameteres = [
            "username":username,
            "user_id":user_id,
            "first_name":first_name,
            "last_name":last_name,
            "gender":gender,
            "website":website,
            "bio":bio
        ]
        print(finalUrl)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameteres, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    //MARK:- showFollowers
    func showFollowers(user_id:String,other_user_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": apiKey
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"          : user_id,
            "other_user_id"    : other_user_id,
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showFollowers.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    
    //MARK:- ShowFollowing
    func showFollowing(user_id:String,other_user_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": apiKey
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"          : user_id,
            "other_user_id"    : other_user_id,
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showFollowing.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    
    //MARK:- showVideosAgainstHashtag
    func showVideosAgainstHashtag(user_id:String,hashtag:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": apiKey
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"    : user_id,
            "hashtag"    : hashtag,
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showVideosAgainstHashtag.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    
    //MARK:- sendMessageNotification
    
    func sendMessageNotification(senderID:String,receiverID:String,msg:String,title:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": apiKey
        ]
        var parameters = [String : String]()
        parameters = [
            "sender_id": senderID,
            "receiver_id": receiverID,
            "message": msg,
            "title": title
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.sendMessageNotification.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    
    //MARK:- Add User Image
    func addUserImage(user_id:String,profile_pic:Any,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": apiKey
        ]
        var parameters = [String : Any]()
        parameters = [
            "user_id"    : user_id,
            "profile_pic"    : profile_pic
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.addUserImage.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    
    //MARK:- admin/deleteVideo
    
    func deleteVideo(video_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": apiKey
        ]
        var parameters = [String : String]()
        parameters = [
            "video_id"    : video_id,
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.deleteVideo.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    //MARK:- Search
    func Search(user_id:String,type:String,keyword:String,starting_point:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": apiKey
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"        : user_id,
            "type"           : type,
            "keyword"        : keyword,
            "starting_point" : starting_point
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.search.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    //MARK:- showVideoDetail
    func showVideoDetail(user_id:String,video_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": apiKey
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"    : user_id,
            "video_id"   : video_id
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showVideoDetail.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    
    
    //MARK:- showAllNotifications
    func showAllNotifications(user_id:String,starting_point:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": apiKey
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id":user_id,
            "starting_point":starting_point
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showAllNotifications.rawValue)"
        
        print(finalUrl)
        print(parameters)

        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    
    //MARK:- userVerificationRequest
    func userVerificationRequest(user_id:String,attachment:Any,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": apiKey
        ]
        var parameters = [String : Any]()
        parameters = [
            "user_id"      : user_id,
            "attachment"   : attachment
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.userVerificationRequest.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    
    //MARK:- downloadVideo
    func downloadVideo(video_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key" : apiKey
        ]
        var parameters = [String : String]()
        parameters = [
            "video_id" : video_id
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.downloadVideo.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    
    //MARK:- deleteWaterMarkVideo
    func deleteWaterMarkVideo(video_url:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": apiKey
        ]
        var parameters = [String : String]()
        parameters = [
            "video_url" : video_url
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.deleteWaterMarkVideo.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    //MARK:- showAppSlider
    func showAppSlider(completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": apiKey
        ]
        var parameters = [String : String]()
        parameters = [
            "" : ""
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showAppSlider.rawValue)"
        
        print(finalUrl)
        print(parameters)
        
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    
    //MARK:- logout
    func logout(user_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":apiKey,
            "User_Id":user_id
//            "Auth_token" : UserDefaults.standard.string(forKey: "authToken")!
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.logout.rawValue)"
        var parameters = [String : String]()
        parameters = [
            "user_id"        : user_id
        ]
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    
    //MARK:- showVideosAgainstSound
    
    func showVideosAgainstSound(sound_id:String,starting_point:String,device_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": apiKey
        ]
        
        var parameters = [String : String]()
        parameters = [
            "sound_id"   : sound_id,
            "sound_id"   : starting_point,
            "device_id"  : device_id,
            
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showVideosAgainstSound.rawValue)"
        print(finalUrl)
        print(parameters)
       
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    
    //MARK:-showReportReasons
    func showReportReasons(completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": apiKey
        ]
        
        var parameters = [String : String]()
        parameters = [
            "":""
            
        ]
        
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showReportReasons.rawValue)"
        print(finalUrl)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    
    //MARK:-reportVideo
    func reportVideo(user_id:String,video_id:String,report_reason_id:String,description:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": apiKey
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.reportVideo.rawValue)"
        var parameters = [String : String]()
        parameters = [
            "user_id"           : user_id,
            "video_id"          : video_id,
            "report_reason_id"  : report_reason_id,
            "description"       : description,

        ]
        print(finalUrl)
        print(parameters)
        
        print(finalUrl)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    
    //MARK:- Block User
    func blockUser(user_id:String,block_user_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": apiKey
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.blockUser.rawValue)"
        var parameters = [String : String]()
        parameters = [
            "user_id" : user_id,
            "block_user_id" : block_user_id
        ]
        print(finalUrl)
        print(parameters)
        
        print(finalUrl)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    //MARK:- NotInterestedVideo
    func NotInterestedVideo(video_id:String,user_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": apiKey
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.NotInterestedVideo.rawValue)"
        var parameters = [String : String]()
        parameters = [
            "video_id"  : video_id,
            "user_id"   : user_id,
        ]
        print(finalUrl)
        print(parameters)
        
        print(finalUrl)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    
    //MARK:- addVideoFavourite
    func addVideoFavourite(video_id:String,user_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": apiKey
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.addVideoFavourite.rawValue)"
        var parameters = [String : String]()
        parameters = [
            "video_id"   : video_id,
            "user_id"    : user_id,
            
            
        ]
        print(finalUrl)
        print(parameters)
        
        print(finalUrl)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    
    
    //MARK:- showFavouriteVideos
    func showFavouriteVideos(user_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": apiKey
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showFavouriteVideos.rawValue)"
        var parameters = [String : String]()
        parameters = [
            "user_id"          : user_id,
        ]
        print(finalUrl)
        print(parameters)
        
        print(finalUrl)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response.result)

            switch response.result {

            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
}
    
    //MARK:- updatePushNotificationSettings
    func updatePushNotificationSettings(user_id:String,comments:String,new_followers:String,mentions:String,likes:String,direct_messages:String,video_updates:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
            let headers: HTTPHeaders = [
                "Api-Key": apiKey
            ]
            let finalUrl = "\(self.baseApiPath!)\(Endpoint.updatePushNotificationSettings.rawValue)"
            var parameters = [String : String]()
            parameters = [
                "likes"          : likes,
                "comments"       : comments,
                "new_followers"  : new_followers,
                "mentions"       : mentions,
                "video_updates"  : video_updates,
                "direct_messages"  : direct_messages,
                "user_id"        : user_id
            ]
            print(finalUrl)
            print(parameters)
            
            print(finalUrl)
            AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    if let json = response.value
                    {
                        do {
                            let dict = json as? NSDictionary
                            print(dict)
                            completionHandler(true, dict)
                            
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                    break
                }
            }
    }
    //MARK:- addHashtagFavourite
    func addHashtagFavourite(user_id:String,hashtag_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": apiKey
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.addHashtagFavourite.rawValue)"
        var parameters = [String : String]()
        parameters = [
            "hashtag_id"    : hashtag_id,
            "user_id"       : user_id,
            
            
        ]
        print(finalUrl)
        print(parameters)
        
        print(finalUrl)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response.result)

            switch response.result {

            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
}
    
    //MARK:- showFavouriteHashtags
    func showFavouriteHashtags(user_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": apiKey
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showFavouriteHashtags.rawValue)"
        var parameters = [String : String]()
        parameters = [
            "user_id"       : user_id,

        ]
        print(finalUrl)
        print(parameters)
        
        print(finalUrl)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response.result)

            switch response.result {

            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
}
    
    //MARK:- reportUser
    func reportUser(user_id:String,report_user_id:String,report_reason_id:String,description:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": apiKey
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.reportUser.rawValue)"
        var parameters = [String : String]()
        parameters = [
            "user_id"          : user_id,
            "report_user_id"   : report_user_id,
            "report_reason_id" : report_reason_id,
            "description"      : description

        ]
        print(finalUrl)
        print(parameters)
        
        print(finalUrl)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response.result)

            switch response.result {

            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
}
    
    //MARK:- addPrivacySetting
    func addPrivacySetting(videos_download:String,direct_message:String,duet:String,liked_videos:String,video_comment:String,user_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": apiKey
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.addPrivacySetting.rawValue)"
        var parameters = [String : String]()
        parameters = [
            "videos_download" : videos_download,
            "direct_message"  : direct_message,
            "duet"            : duet,
            "liked_videos"    : liked_videos,
            "video_comment"   : video_comment,
            "user_id"         : user_id,
            
            
        ]
        print(finalUrl)
        print(parameters)
        
        print(finalUrl)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response.result)

            switch response.result {

            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
}

}
