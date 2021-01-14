//
//  newNotificationsViewController.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 27/10/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class newNotificationsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var notificationTblView: UITableView!
    @IBOutlet weak var noDataView: UIView!
    
    var notificationsArr = [notificationsMVC]()
    var notiVidDataArr = [videoMainMVC]()
    
    var startPoint = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getNotifications(startPoint: "\(startPoint)")
        // Do any additional setup after loading the view.
    }
    
    func getNotifications(startPoint:String){
                
        print("userid: ",UserDefaults.standard.string(forKey: "userID")!)
        AppUtility?.startLoader(view: self.view)
        ApiHandler.sharedInstance.showAllNotifications(user_id: UserDefaults.standard.string(forKey: "userID")!, starting_point: "\(startPoint)") { (isSuccess, response) in
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    let resMsg = response?.value(forKey: "msg") as! [[String:Any]]
                    for dic in resMsg{
                        let notiDic = dic["Notification"] as! NSDictionary
                        
//                        let vidDic = dic["Video"] as! NSDictionary
                        let senderDic = dic["Sender"] as! NSDictionary
                        let receiverDic = dic["Receiver"] as! NSDictionary
                        
                        let notiString = notiDic.value(forKey: "string") as! String
                        let type = notiDic.value(forKey: "type") as! String
                        let receiver_id = notiDic.value(forKey: "receiver_id") as! String
                        let sender_id = notiDic.value(forKey: "sender_id") as! String
                        let video_id = notiDic.value(forKey: "video_id") as! String
                        let notiID  = notiDic.value(forKey: "id") as! String
                        
                        let senderUserame  = senderDic.value(forKey: "username") as! String
                        let senderImg = senderDic.value(forKey: "profile_pic") as! String
                        let senderFirstName = senderDic.value(forKey: "first_name") as! String
                        
                        let receiverName = receiverDic.value(forKey: "username") as! String
                        
                        let notiObj = notificationsMVC(notificationString: notiString, id: notiID, sender_id: sender_id, receiver_id: receiver_id, type: type, video_id: video_id, senderName: senderUserame, senderFirstName: senderFirstName, receiverName: receiverName, senderImg: senderImg)
                        
                        self.notificationsArr.append(notiObj)

                    }
                    AppUtility?.stopLoader(view: self.view)
                    self.notificationTblView.reloadData()
                }else{
                    AppUtility?.stopLoader(view: self.view)
//                    self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                    
                    print("!200",response?.value(forKey: "msg"))
                }
            }else{
                self.showToast(message: "Failed to load notifications", font: .systemFont(ofSize: 12))
                AppUtility?.stopLoader(view: self.view)
            }
            AppUtility?.stopLoader(view: self.view)
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.notificationsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:FollowTableViewCell = self.notificationTblView.dequeueReusableCell(withIdentifier: "cell01") as! FollowTableViewCell
        
        let obj = self.notificationsArr[indexPath.row]
        
        cell.folow_name.text = obj.senderName
        cell.folow_username.text = obj.notificationString
        if(obj.type == "video_like"){
            cell.foolow_btn_view.alpha = 1
        }else if(obj.type == "video_comment"){
            cell.foolow_btn_view.alpha = 1
        }else{
            cell.foolow_btn_view.alpha = 0
        }
        
        
        let senderImg = AppUtility?.detectURL(ipString: obj.senderImg) 
        cell.follow_img.sd_setImage(with: URL(string:senderImg!), placeholderImage: UIImage(named:"noUserImg"))
        cell.follow_img.layer.cornerRadius = cell.follow_img.frame.size.width / 2
        cell.follow_img.clipsToBounds = true
        
        cell.follow_view.layer.cornerRadius = cell.follow_view.frame.size.width / 2
        cell.follow_view.clipsToBounds = true
        
        cell.foolow_btn_view.layer.cornerRadius = 5
        cell.foolow_btn_view.clipsToBounds = true
        
        cell.btn_follow.tag = indexPath.item
        
        cell.btnWatch.addTarget(self, action: #selector(newNotificationsViewController.btnWatchAction(_:)), for:.touchUpInside)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let obj = notificationsArr[indexPath.row]
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "newProfileVC") as!  newProfileViewController
        UserDefaults.standard.set(obj.sender_id, forKey: "otherUserID")
        vc.isOtherUserVisting = true
        vc.otherUserID = obj.sender_id
        navigationController?.pushViewController(vc, animated: true)
        

    }
    
    @objc func btnWatchAction(_ sender : UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.notificationTblView)
        let indexPath = self.notificationTblView.indexPathForRow(at:buttonPosition)
        let cell = self.notificationTblView.cellForRow(at: indexPath!) as! FollowTableViewCell
        
        
        self.getVideo(ip:indexPath!)
        
        print("btn watch tapped")

    }
    
    @IBAction func btnInbox(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "conversationVC") as! ConversationViewController
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getVideo(ip:IndexPath){
        AppUtility?.startLoader(view: self.view)
        let obj = notificationsArr[ip.row]
        ApiHandler.sharedInstance.showVideoDetail(user_id: UserDefaults.standard.string(forKey: "userID")!, video_id: obj.video_id) { (isSuccess, response) in
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    
                    let resMsg = response?.value(forKey: "msg") as! NSDictionary
                    
                    let videoDic = resMsg.value(forKey: "Video") as! NSDictionary
                    let userDic = resMsg.value(forKey: "User") as! NSDictionary
                    let soundDic = resMsg.value(forKey: "Sound") as! NSDictionary
                        
                        print("videoDic: ",videoDic)
                        print("userDic: ",userDic)
                        print("soundDic: ",soundDic)
                        
                        let videoURL = videoDic.value(forKey: "video") as! String
                        let desc = videoDic.value(forKey: "description") as! String
                        let allowComments = videoDic.value(forKey: "allow_comments")
                        let videoUserID = videoDic.value(forKey: "user_id")
                        let videoID = videoDic.value(forKey: "id") as! String
                        let allowDuet = videoDic.value(forKey: "allow_duet")
                        
                        //                        not strings
                        let commentCount = videoDic.value(forKey: "comment_count")
                        let likeCount = videoDic.value(forKey: "like_count")
                        let duetVidID = videoDic.value(forKey: "duet_video_id")
                        
                        let userImgPath = userDic.value(forKey: "profile_pic") as! String
                        let userName = userDic.value(forKey: "username") as! String
                        let followBtn = userDic.value(forKey: "button") as! String
                        let uid = userDic.value(forKey: "id") as! String
                        let verified = userDic.value(forKey: "verified")
                        
                        let soundName = soundDic.value(forKey: "name")
                        
                    let videoObj = videoMainMVC(videoID: videoID, videoUserID: "\(videoUserID!)", fb_id: "", description: desc, videoURL: videoURL, videoTHUM: "", videoGIF: "", view: "", section: "", sound_id: "", privacy_type: "", allow_comments: "\(allowComments!)", allow_duet: "\(allowDuet!)", block: "", duet_video_id: "", old_video_id: "", created: "", like: "", favourite: "", comment_count: "\(commentCount!)", like_count: "\(likeCount!)", followBtn: followBtn, duetVideoID: "\(duetVidID!)", userID: uid, first_name: "", last_name: "", gender: "", bio: "", website: "", dob: "", social_id: "", userEmail: "", userPhone: "", password: "", userProfile_pic: userImgPath, role: "", username: userName, social: "", device_token: "", videoCount: "", verified: "\(verified!)", soundName: "\(soundName!)")
                    
                        self.notiVidDataArr.append(videoObj)
                    
                    print("response@200: ",response!)
                    
                    AppUtility?.stopLoader(view: self.view)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "homeFeedVC") as! homeFeedViewController
                    vc.userVideoArr = self.notiVidDataArr
                    vc.indexAt = ip
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    AppUtility?.stopLoader(view: self.view)
                    print("!200: ",response as Any)
                }
                

            }else{
                AppUtility?.startLoader(view: self.view)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "homeFeedVC") as! homeFeedViewController
                vc.userVideoArr = self.notiVidDataArr
                vc.indexAt = ip
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if notificationsArr.isEmpty{
            noDataView.isHidden = false
        }else{
            noDataView.isHidden = true
        }
        
        if indexPath.row == notificationsArr.count - 4{
            self.startPoint+=1
            print("StartPoint: ",startPoint)
                self.getNotifications(startPoint: "\(self.startPoint)")
            print("index@row: ",indexPath.row)
        }
    }

    
}
