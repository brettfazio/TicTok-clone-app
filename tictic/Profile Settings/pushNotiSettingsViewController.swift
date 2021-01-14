//
//  pushNotiSettingsViewController.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 04/11/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit

class pushNotiSettingsViewController: UIViewController {
    
    var pushNotiSettingData = [pushNotiSettingMVC]()
    
    @IBOutlet var switchBtns: [UISwitch]!
    
    var newLikes = "1"
    var newMentions = "1"
    var newFollowers = "1"
    var newComments = "1"
    var directMsg = "1"
    var videoUpdates = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for swtch in switchBtns{
            swtch.set(width: 30, height: 20)
        }
        
        
        getData()
        // Do any additional setup after loading the view.
    }
    
    func setupFunc(){
        
        let obj = pushNotiSettingData[0]
        
        for swBtn in switchBtns{
            switch swBtn.tag
            {
            case 0:
                if obj.likes == "1"{
                    swBtn.isOn = true
                }else{
                    swBtn.isOn = false
                }
                break
            case 1:
                if obj.comments == "1"{
                    swBtn.isOn = true
                }else{
                    swBtn.isOn = false
                }
                break
            case 2:
                if obj.new_followers == "1"{
                    swBtn.isOn = true
                }else{
                    swBtn.isOn = false
                }
                break
            case 3:
                if obj.mentions == "1"{
                    swBtn.isOn = true
                }else{
                    swBtn.isOn = false
                }
                break
            case 4:
                if obj.direct_messages == "1"{
                    swBtn.isOn = true
                }else{
                    swBtn.isOn = false
                }
                break
            case 5:
                if obj.video_updates == "1"{
                    swBtn.isOn = true
                }else{
                    swBtn.isOn = false
                }
                break
            default:
                print("default")
            }
        }
    }
    
    @IBAction func switchBtnsAction(_ sender: UISwitch) {
        switch sender.tag
        {
        case 0:
            print("0")     //when switch1 is clicked...
            if sender.isOn{
                print("on...")
                self.newLikes = "1"
                pushNotiAPI()
            }else{
                print("off...")
                self.newLikes = "0"
                pushNotiAPI()
            }
            break
            
        case 1:
            print("1")     //when switch2 is clicked...
            if sender.isOn{
                print("on...")
                self.newComments = "1"
                pushNotiAPI()
            }else{
                print("off...")
                self.newComments = "0"
                pushNotiAPI()
            }
            break
            
        case 2:
            print("2")     //when switch3 is clicked...
            if sender.isOn{
                print("on...")
                self.newFollowers = "1"
                pushNotiAPI()
            }else{
                print("off...")
                self.newFollowers = "0"
                pushNotiAPI()
            }
            break
            
        case 3:
            print("3")     //when switch4 is clicked...
            if sender.isOn{
                print("on...")
                self.newMentions = "1"
                pushNotiAPI()
            }else{
                print("off...")
                self.newMentions = "0"
                pushNotiAPI()
            }
            break
            
        case 4:
            print("4")     //when switch5 is clicked...
            if sender.isOn{
                print("on...")
                self.directMsg = "1"
                pushNotiAPI()
            }else{
                print("off...")
                self.directMsg = "0"
                pushNotiAPI()
            }
            break
            
        case 5:
            print("5")     //when switch6 is clicked...
            if sender.isOn{
                print("on...")
                self.videoUpdates = "1"
                pushNotiAPI()
            }else{
                print("off...")
                self.videoUpdates = "0"
                pushNotiAPI()
                
            }
            break
        default:
            print("Other...")
        }
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func getData(){
        self.pushNotiSettingData.removeAll()
        AppUtility?.startLoader(view: self.view)
        ApiHandler.sharedInstance.showOwnDetail(user_id: UserDefaults.standard.string(forKey: "userID")!) { (isSuccess, response) in
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200{
                    let msgDict = response?.value(forKey: "msg") as! NSDictionary
                    let pushNotiSettingObj = msgDict.value(forKey: "PushNotification") as! NSDictionary
                    //                    MARK:- PUSH NOTIFICATION SETTING DATA
                    let cmnt = pushNotiSettingObj.value(forKey: "comments")
                    let direct_messages = pushNotiSettingObj.value(forKey: "direct_messages")
                    let likes = pushNotiSettingObj.value(forKey: "likes")
                    let pushID = pushNotiSettingObj.value(forKey: "id")
                    let new_followers = pushNotiSettingObj.value(forKey: "new_followers")
                    let video_updates = pushNotiSettingObj.value(forKey: "video_updates")
                    let mentions = pushNotiSettingObj.value(forKey: "mentions")
                    
                    self.newLikes = "\(likes!)"
                    self.newComments = "\(cmnt!)"
                    self.directMsg = "\(direct_messages!)"
                    self.newFollowers = "\(new_followers!)"
                    self.videoUpdates = "\(video_updates!)"
                    self.newMentions = "\(mentions!)"
                    
                    print("newFollowers",new_followers)
                    let pushObj = pushNotiSettingMVC(comments: "\(cmnt!)", direct_messages: "\(direct_messages!)", likes: "\(likes!)", mentions: "\(mentions!)", new_followers: "\(new_followers!)", video_updates: "\(video_updates!)", id: "\(pushID!)")
                    
                    self.pushNotiSettingData.append(pushObj)
                    
                    self.setupFunc()
                    AppUtility?.stopLoader(view: self.view)
                }else{
                    print("!200: ",response as Any)
                    AppUtility?.stopLoader(view: self.view)
                }
            }
        }
    }
    
    func pushNotiAPI(){
        AppUtility?.startLoader(view: self.view)
        print("comment: ",newComments)
        print("likes: ",newLikes)
        print("newFollowers: ",newFollowers)
        print("mentions: ",newMentions)
        print("videoUpdates: ",videoUpdates)
        print("directMsg: ",directMsg)
        
        ApiHandler.sharedInstance.updatePushNotificationSettings(user_id: UserDefaults.standard.string(forKey: "userID")!, comments: self.newComments, new_followers: self.newFollowers, mentions: self.newMentions, likes: self.newLikes, direct_messages: self.directMsg, video_updates: self.videoUpdates) { (isSuccess, response) in
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200{
                    
                    
                    AppUtility?.stopLoader(view: self.view)
                    self.showToast(message: "Setting Updated", font: .systemFont(ofSize: 12))
                    print("response:",response)
                }else{
                    AppUtility?.stopLoader(view: self.view)
                    self.showToast(message: "Something Went Wrong", font: .systemFont(ofSize: 12))
                }
            }
            
        }
    }
    
}
extension UISwitch {
    
    func set(width: CGFloat, height: CGFloat) {
        
        let standardHeight: CGFloat = 31
        let standardWidth: CGFloat = 51
        
        let heightRatio = height / standardHeight
        let widthRatio = width / standardWidth
        
        transform = CGAffineTransform(scaleX: widthRatio, y: heightRatio)
    }
}
