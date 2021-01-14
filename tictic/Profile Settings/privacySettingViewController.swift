//
//  privacySettingViewController.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 05/11/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit

class privacySettingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var privacySettingData = [privacySettingMVC]()
    
    var video_download = "off"
    var direct_message = "everyone"
    var duet_videos = "everyone"
    var video_like = "everyone"
    var comment_video = "everyone"
    var btnTag = ""
    
    @IBOutlet weak var hiddenView: UIView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var tblData: UITableView!
    
    @IBOutlet weak var videoDownloadButton: UIButton!
    @IBOutlet weak var directButton: UIButton!
    @IBOutlet weak var duetButton: UIButton!
    @IBOutlet weak var videolikeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    //array
    var MainArray  = [String]()
    var downloadarray  = ["on","off","cancel"]
    var directMessagedarray = ["everyone","friend","no one","cancel"]
    var duetarray = ["everyone","friend","no one","cancel"]
    var videolikearray = ["everyone","friend","no one","cancel"]
    var commentarray = ["everyone","friend","no one","cancel"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hiddenView.isHidden = true
        popView.isHidden = true
        popView.layer.cornerRadius = 3.0
        tblHeight.constant = CGFloat(downloadarray.count * 45)
        viewHeight.constant = CGFloat(downloadarray.count * 45) + 100
        
        getData()
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return MainArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "privacySettingTVC", for: indexPath)as! privacySettingTableViewCell
        
        cell.stateLabel.text = MainArray[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row != self.MainArray.count - 1 {
            
            print(MainArray[indexPath.row])
            
            // self.offButton.setTitle(MainArray[indexPath.row], for: .normal)
            
            print(indexPath.row)
            if btnTag == "A" {
                self.videoDownloadButton.setTitle(MainArray[indexPath.row], for: .normal)
                if videoDownloadButton.titleLabel?.text == "on"{
                    video_download = "0"
                }else if videoDownloadButton.titleLabel?.text == "off" {
                   
                    video_download = "1"
                }
                
                
            }else if btnTag == "B"{
                self.directButton.setTitle(MainArray[indexPath.row], for: .normal)
                direct_message = MainArray[indexPath.row]
            }else if btnTag == "C"{
                self.duetButton.setTitle(MainArray[indexPath.row], for: .normal)
                duet_videos = MainArray[indexPath.row]
            }else if btnTag == "D"{
                self.videolikeButton.setTitle(MainArray[indexPath.row], for: .normal)
                video_like = MainArray[indexPath.row]
                print(video_like)
            }else if btnTag == "E"{
                self.commentButton.setTitle(MainArray[indexPath.row], for: .normal)
                  comment_video = MainArray[indexPath.row]
                
            }
            
        }
    
        
        self.addPrivacy()
        print(MainArray[indexPath.row])
        self.hiddenView.isHidden =  true
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    
    //MARK:-ACTION
    
    @IBAction func offButtonPressed(_ sender: UIButton) {
        self.btnTag = "A"
        self.MainArray = downloadarray
        self.mainLabel.text = "Select download option"
        self.tblData.reloadData()
        hiddenView.isHidden = false
        popView.isHidden = false
        
        tblHeight.constant = CGFloat(downloadarray.count * 45)
        viewHeight.constant = CGFloat(downloadarray.count * 45) + 45
        
    }
    
    @IBAction func messageButtonPressed(_ sender: UIButton) {
        self.btnTag = "B"
        self.MainArray = directMessagedarray
        self.mainLabel.text = "Select message option"
        self.tblHeight.constant = CGFloat(directMessagedarray.count * 45)
        self.tblData.reloadData()
        hiddenView.isHidden = false
        popView.isHidden = false
        
        viewHeight.constant = CGFloat(downloadarray.count * 45) + 90
        
    }
    
    @IBAction func duetButtonPressed(_ sender: UIButton) {
        self.btnTag = "C"
        
        self.MainArray = duetarray
        self.mainLabel.text = "Select duet option"
        self.tblHeight.constant = CGFloat(duetarray.count * 45)
        self.tblData.reloadData()
        hiddenView.isHidden = false
        popView.isHidden = false
        
        viewHeight.constant = CGFloat(downloadarray.count * 45) + 90
    }
    
    @IBAction func videoLikesButtonPressed(_ sender: UIButton) {
        self.btnTag = "D"
        
        self.MainArray = videolikearray
        self.mainLabel.text = "Select like video option"
        self.tblHeight.constant = CGFloat(videolikearray.count * 45)
        self.tblData.reloadData()
        hiddenView.isHidden = false
        popView.isHidden = false
        tblHeight.constant = CGFloat(downloadarray.count * 45)
        viewHeight.constant = CGFloat(downloadarray.count * 45) + 45
    }
    
    @IBAction func commentButtonPressed(_ sender: UIButton) {
        self.btnTag = "E"
        
        self.MainArray = commentarray
        self.mainLabel.text = "Select Comment option"
        self.tblHeight.constant = CGFloat(commentarray.count * 45)
        self.tblData.reloadData()
        hiddenView.isHidden = false
        
        popView.isHidden = false
        
        
        viewHeight.constant = CGFloat(downloadarray.count * 45) + 90
        
        
    }
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- API Handler
    func addPrivacy(){
        
        //        print("userid: ",UserDefaults.standard.string(forKey: "userID")!)
        AppUtility?.startLoader(view: self.view)
        ApiHandler.sharedInstance.addPrivacySetting(videos_download: video_download, direct_message: direct_message, duet: duet_videos, liked_videos: video_like, video_comment: comment_video, user_id: UserDefaults.standard.string(forKey: "userID")!) { (isSuccess, response) in
            if isSuccess {
                if response?.value(forKey: "code") as! NSNumber == 200{
                    AppUtility?.stopLoader(view: self.view)
                    self.showToast(message: "Setting Updated", font: .systemFont(ofSize: 12))
                    print(response!)
                }else{
                    AppUtility?.stopLoader(view: self.view)
                    self.showToast(message: "Something went wrong", font: .systemFont(ofSize: 12))
                    print(response!)
                }
            }
        }
    }
    
    func getData(){
        self.privacySettingData.removeAll()
        AppUtility?.startLoader(view: self.view)
        ApiHandler.sharedInstance.showOwnDetail(user_id: UserDefaults.standard.string(forKey: "userID")!) { (isSuccess, response) in
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200{
                    let msgDict = response?.value(forKey: "msg") as! NSDictionary
                    let privSettingObj = msgDict.value(forKey: "PrivacySetting") as! NSDictionary
                    
                    //                    MARK:- PRIVACY SETTING DATA
                    let direct_message = privSettingObj.value(forKey: "direct_message") as! String
                    let duet = privSettingObj.value(forKey: "duet") as! String
                    let liked_videos = privSettingObj.value(forKey: "liked_videos") as! String
                    let video_comment = privSettingObj.value(forKey: "video_comment") as! String
                    let videos_download = privSettingObj.value(forKey: "videos_download") as! String
                    let privID = privSettingObj.value(forKey: "id")
                    
                    
                    self.directButton.setTitle(direct_message, for: .normal)
                    self.duetButton.setTitle(duet, for: .normal)
                    self.videolikeButton.setTitle(liked_videos, for: .normal)
                    self.commentButton.setTitle(video_comment, for: .normal)
                    
                    if videos_download == "1"{
                        self.videoDownloadButton.setTitle("on", for: .normal)
                    }else{
                        self.videoDownloadButton.setTitle("off", for: .normal)
                    }
                    
                    
                    let privObj = privacySettingMVC(direct_message: direct_message, duet: duet, liked_videos: liked_videos, video_comment: video_comment, videos_download: "\(videos_download)", id: "\(privID!)")
                    self.privacySettingData.append(privObj)
                    
                    self.tblData.reloadData()
                    AppUtility?.stopLoader(view: self.view)
                }else{
                    print("!200: ",response as Any)
                    AppUtility?.stopLoader(view: self.view)
                }
            }
        }
    }
    
}

