//
//  homeFeedViewController.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 01/10/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit
import GSPlayer
import SDWebImage
import MarqueeLabel
import NVActivityIndicatorView
import EFInternetIndicator
import Lottie
import AVFoundation

//@available(iOS 13.0, *)
class homeFeedViewController: UIViewController,InternetStatusIndicable {
    var internetConnectionIndicator: InternetViewIndicator?
    
    @IBOutlet weak var feedCV: UICollectionView!
    @IBOutlet weak var segmentVideos: UISegmentedControl!
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var feedCVtopConstraint: NSLayoutConstraint!
    
//    var refreshControl:UIRefreshControl!
    
    var ShowRelatedVideoArr = [[String:Any]]()
    
    var videosMainArr = [videoMainMVC]()
    var videosRelatedArr = [videoMainMVC]()
    var videosFollowingArr = [videoMainMVC]()
    
    var userVideoArr = [videoMainMVC]()
    var discoverVideoArr = [videoMainMVC]()
    
    var videoDetail = [videoDetailMVC]()
    
    var indexAt : IndexPath!
    
    var currentVidIP : IndexPath!
    
    var isFollowing = false
    
    var videoID = ""
    var videoURL = ""
    var otherUserID = ""
        
    /*
     var items: [URL] = [
     URL(string: "http://vfx.mtime.cn/Video/2019/06/29/mp4/190629004821240734.mp4")!,
     URL(string: "http://vfx.mtime.cn/Video/2019/06/27/mp4/190627231412433967.mp4")!,
     URL(string: "http://vfx.mtime.cn/Video/2019/06/25/mp4/190625091024931282.mp4")!,
     URL(string: "http://vfx.mtime.cn/Video/2019/06/16/mp4/190616155507259516.mp4")!,
     URL(string: "http://vfx.mtime.cn/Video/2019/06/15/mp4/190615103827358781.mp4")!,
     URL(string: "http://vfx.mtime.cn/Video/2019/06/05/mp4/190605101703931259.mp4")!,
     ]
     */
    
    var items = [URL]()
    var startPoint = 0
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
        
        return refreshControl
    }()
    
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    
//    MARK:- IMPORTAB; BTN FOLLOW IS HIDDEN FOR NOW
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAudio()
        
        self.startMonitoringInternet()
        
        self.btnBack.isHidden = true
        self.segmentVideos.isHidden = true
        
        settingUDID()
        
        print("indexpath: ",indexAt)
        
        segmentVideos.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentVideos.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        
        segmentVideos.addTarget(self, action: #selector(homeFeedViewController.indexChanged(_:)), for: .valueChanged)
        
        UserDefaults.standard.set("0", forKey: "sid")
        
        if(UserDefaults.standard.string(forKey: "uid") == nil){
            
            UserDefaults.standard.set("", forKey: "uid")
        }
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        //         feedCV.layoutIfNeeded()
        feedCV.isPagingEnabled = true
        feedCV.setCollectionViewLayout(layout, animated: true)
        
        devicesChecks()
        tapGesturesFunc()
        
        segmentVideos.selectedSegmentIndex = 1
        
        loaderView.type = .ballTrianglePath
        loaderView.backgroundColor = .clear
        loaderView.color = #colorLiteral(red: 1, green: 0.5223166943, blue: 0, alpha: 1)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("errInPlay"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadDataNotification(notification:)), name: NSNotification.Name(rawValue: "reloadVidDetails"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadScreenNotification(notification:)), name: NSNotification.Name(rawValue: "reloadScreenNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.pauseSongNoti(notification:)), name: NSNotification.Name(rawValue: "pauseSongNoti"), object: nil)
        
        if #available(iOS 10.0, *) {
            feedCV.refreshControl = refresher
        } else {
            feedCV.addSubview(refresher)
        }
    }
    
    
    @objc
    func requestData() {
        print("requesting data")
//        self.videosMainArr.removeAll()
        self.videosFollowingArr.removeAll()
        self.videosRelatedArr.removeAll()
        
        self.startPoint = 0
        getDataForFeeds()
        
        self.feedCV?.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath,at: .top,animated: true)
        
        let deadline = DispatchTime.now() + .milliseconds(700)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.refresher.endRefreshing()
        }
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        if let err = notification.userInfo?["err"] as? String {
            showToast(message: err, font: .systemFont(ofSize: 14.0))
        }}
    
    @objc func reloadDataNotification(notification: Notification) {
        if (notification.userInfo?["err"] as? String) != nil {
                    print("reloadVid Details Noti")
            
        }else{
            getVideoDetails(ip: self.currentVidIP)
        }
    }
    
    @objc func reloadScreenNotification(notification: Notification) {
        if (notification.userInfo?["err"] as? String) != nil {
                    print("reloadVid Details Noti")
            
        }else{
            requestData()
        }
    }
    
    @objc func pauseSongNoti(notification: Notification) {
        if (notification.userInfo?["err"] as? String) != nil {
                    print("reloadVid Details Noti")
            
        }else{
            let visiblePaths = self.feedCV.indexPathsForVisibleItems
            for i in visiblePaths  {
                let cell = feedCV.cellForItem(at: i) as? homeFeedCollectionViewCell
                cell?.pause()
                
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        check()
        hideShowObj()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        let visiblePaths = self.feedCV.indexPathsForVisibleItems
        for i in visiblePaths  {
            let cell = feedCV.cellForItem(at: i) as? homeFeedCollectionViewCell
            cell?.pause()
            
        }
//        NotificationCenter.default.removeObserver(self)
    }
    
    //    MARK:- DEVICE CHECKS
    func devicesChecks(){
        if !DeviceType.iPhoneWithHomeButton{
            
            feedCVtopConstraint.constant = -44
        }
        
    }
    
    func getDataForFeeds(){
        if userVideoArr.isEmpty == false
        {
            btnBack.isHidden = false
            segmentVideos.isHidden = true
            videosMainArr.removeAll()
            videosMainArr = userVideoArr
            //            feedCV.moveItem(at: indexAt, to: indexAt)
            feedCV.reloadData()
            feedCV.scrollToItem(at:indexAt, at: .bottom, animated: false)
        }
        else if discoverVideoArr.isEmpty == false
        {
            btnBack.isHidden = false
            segmentVideos.isHidden = true
            videosMainArr.removeAll()
            videosMainArr = discoverVideoArr
            //            feedCV.moveItem(at: indexAt, to: indexAt)
            feedCV.reloadData()
            feedCV.scrollToItem(at:indexAt, at: .bottom, animated: false)
        }
        else
        {
            segmentVideos.isHidden = false
            btnBack.isHidden = true
            getAllVideos(startPoint: "\(startPoint)")
        }
    }
    
    func hideShowObj(){
        if userVideoArr.isEmpty == false
        {
            btnBack.isHidden = false
            segmentVideos.isHidden = true
        }
        else if discoverVideoArr.isEmpty == false
        {
            btnBack.isHidden = false
            segmentVideos.isHidden = true

        }
        else
        {
            segmentVideos.isHidden = false
            btnBack.isHidden = true
        }
    }
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        
        self.videosMainArr.removeAll()
        self.videosFollowingArr.removeAll()
        self.videosRelatedArr.removeAll()
        
        self.startPoint = 0
        
        if segmentVideos.selectedSegmentIndex == 0 {
            print("Select 0")
            let userID = UserDefaults.standard.string(forKey: "userID")
            if userID == nil || userID == ""{
                segmentVideos.selectedSegmentIndex = 1
                loginScreenAppear()
            }else{
                print("device key: ",UserDefaults.standard.string(forKey: "deviceKey")!)
                
                self.isFollowing = true
                getFollowingVideos(startPoint: "\(startPoint)")
            }
        } else if segmentVideos.selectedSegmentIndex == 1 {
            print("Select 1")
            
            self.isFollowing = false
            getAllVideos(startPoint: "\(startPoint)")
            
        }
    }
    func tapGesturesFunc(){
        
        let singleTapGR = UITapGestureRecognizer(target: self, action: #selector(homeFeedViewController.handleSingleTap(_:)))
        singleTapGR.delegate = self
        singleTapGR.numberOfTapsRequired = 1
        view.addGestureRecognizer(singleTapGR)
        
        let doubleTapGR = UITapGestureRecognizer(target: self, action: #selector(homeFeedViewController.handleDoubleTap(_:)))
        doubleTapGR.delegate = self
        doubleTapGR.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapGR)
    }
    
    func getAllVideos(startPoint:String){
        
        //showToast(message: "Loading Videos...", font: .systemFont(ofSize: 12.0))
        var userID = UserDefaults.standard.string(forKey: "userID")
        
        if userID == "" || userID == nil{
            userID = ""
        }
        let startingPoint = startPoint
        let deviceID = UserDefaults.standard.string(forKey: "deviceID")
        
        print("deviceid: ",deviceID)
        self.showToast(message: "Loading ...", font: .systemFont(ofSize: 12))
//        self.loaderView.startAnimating()
        
        ApiHandler.sharedInstance.showRelatedVideos(device_id: deviceID!, user_id: userID!, starting_point: startingPoint) { (isSuccess, response) in
            print("res : ",response!)
            if isSuccess {
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    
                    let resMsg = response?.value(forKey: "msg") as! [[String:Any]]
                    
                    for dic in resMsg{
                        let videoDic = dic["Video"] as! NSDictionary
                        let userDic = dic["User"] as! NSDictionary
                        let soundDic = dic["Sound"] as! NSDictionary
                        
                        print("videoDic: ",videoDic)
                        print("userDic: ",userDic)
                        print("soundDic: ",soundDic)
                        
                        let videoURL = videoDic.value(forKey: "video") as! String
                        let desc = videoDic.value(forKey: "description") as! String
                        let allowComments = videoDic.value(forKey: "allow_comments")
                        let videoUserID = videoDic.value(forKey: "user_id")
                        let videoID = videoDic.value(forKey: "id") as! String
                        let allowDuet = videoDic.value(forKey: "allow_duet")
                        let duetVidID = videoDic.value(forKey: "duet_video_id")
                        
                        //                        not strings
                        let commentCount = videoDic.value(forKey: "comment_count")
                        let likeCount = videoDic.value(forKey: "like_count")
                        
                        let userImgPath = userDic.value(forKey: "profile_pic") as! String
                        let userName = userDic.value(forKey: "username") as! String
                        let followBtn = userDic.value(forKey: "button") as! String
                        let uid = userDic.value(forKey: "id") as! String
                        let verified = userDic.value(forKey: "verified")
                        
                        let soundName = soundDic.value(forKey: "name")
                        
                        let videoObj = videoMainMVC(videoID: videoID, videoUserID: "\(videoUserID!)", fb_id: "", description: desc, videoURL: videoURL, videoTHUM: "", videoGIF: "", view: "", section: "", sound_id: "", privacy_type: "", allow_comments: "\(allowComments!)", allow_duet: "\(allowDuet!)", block: "", duet_video_id: "", old_video_id: "", created: "", like: "", favourite: "", comment_count: "\(commentCount!)", like_count: "\(likeCount!)", followBtn: followBtn, duetVideoID: "\(duetVidID!)", userID: uid, first_name: "", last_name: "", gender: "", bio: "", website: "", dob: "", social_id: "", userEmail: "", userPhone: "", password: "", userProfile_pic: userImgPath, role: "", username: userName, social: "", device_token: "", videoCount: "", verified: "\(verified!)", soundName: "\(soundName!)")
                        self.videosRelatedArr.append(videoObj)
                    }
                    
                    //                    self.feedCV.delegate = self
                    //                    self.feedCV.dataSource = self
                    
                    self.videosMainArr = self.videosRelatedArr
//                    self.loaderView.stopAnimating()
                    
                    self.feedCV.reloadData()
                    print("response@200: ",response!)
                }
                
                
            }else{
                print("response failed: ",response!)
                self.showToast(message: (response?.value(forKey: "msg") as? String)!, font: .systemFont(ofSize: 12))
//                self.loaderView.stopAnimating()
            }
            
//            self.loaderView.stopAnimating()
        }
    }
    
    
    
    func getFollowingVideos(startPoint:String){
        
         showToast(message: "Loading ...", font: .systemFont(ofSize: 12.0))
        
        let startingPoint = startPoint
        
        let userID = UserDefaults.standard.string(forKey: "userID")
        let deviceID = UserDefaults.standard.string(forKey: "deviceID")
        
//        self.loaderView.startAnimating()
        
        ApiHandler.sharedInstance.showFollowingVideos(user_id: userID!, device_id: deviceID!, starting_point: startingPoint) { (isSuccess, response) in
            print("res;: ",response!)
            if isSuccess {
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    
                    let resMsg = response?.value(forKey: "msg") as! [[String:Any]]
                    
                    for dic in resMsg{
                        let videoDic = dic["Video"] as! NSDictionary
                        let userDic = dic["User"] as! NSDictionary
                        let soundDic = dic["Sound"] as! NSDictionary
                        
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
                        let uid = userDic.value(forKey: "id") as! String
                        let verified = userDic.value(forKey: "verified")
                        //                        let followBtn = userDic.value(forKey: "button") as! String
                        
                        let soundName = soundDic.value(forKey: "name")
                        
                        let videoObj = videoMainMVC(videoID: videoID, videoUserID: "\(videoUserID!)", fb_id: "", description: desc, videoURL: videoURL, videoTHUM: "", videoGIF: "", view: "", section: "", sound_id: "", privacy_type: "", allow_comments: "\(allowComments!)", allow_duet: "\(allowDuet!)", block: "", duet_video_id: "", old_video_id: "", created: "", like: "", favourite: "", comment_count: "\(commentCount!)", like_count: "\(likeCount!)", followBtn: "", duetVideoID: "\(duetVidID!)", userID: uid, first_name: "", last_name: "", gender: "", bio: "", website: "", dob: "", social_id: "", userEmail: "", userPhone: "", password: "", userProfile_pic: userImgPath, role: "", username: userName, social: "", device_token: "", videoCount: "", verified: "\(verified!)", soundName: "\(soundName!)")
                        self.videosFollowingArr.append(videoObj)
                    }
                    
                    //                    self.feedCV.delegate = self
                    //                    self.feedCV.dataSource = self
                    self.videosMainArr = self.videosFollowingArr
//                    self.loaderView.stopAnimating()
                    self.feedCV.reloadData()
                    print("response@200: ",response!)
                }else{
//                    self.loaderView.stopAnimating()
                    self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                }
                
                
            }else{
                print("response failed: ",response!)
//                self.loaderView.stopAnimating()
                self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
            }
            
            //            self.loaderView.stopAnimating()
        }
    }
    
    func getVideoDetails(ip:IndexPath){
        videoDetail.removeAll()
        
        var uid = UserDefaults.standard.string(forKey: "userID")
        
        if uid == nil || uid == ""{
            uid = ""
        }
        
        if userVideoArr.isEmpty == false || discoverVideoArr.isEmpty == false{
            uid = UserDefaults.standard.string(forKey: "otherUserID")
        }
        
        ApiHandler.sharedInstance.showVideoDetail(user_id: uid!, video_id: self.videoID) { (isSuccess, response) in
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    let resMsg = response?.value(forKey: "msg") as! NSDictionary
                    
                    let videoDic = resMsg.value(forKey: "Video") as! NSDictionary
                    let userDic = resMsg.value(forKey: "User") as! NSDictionary
                    let soundDic = resMsg.value(forKey: "Sound") as! NSDictionary
                    
                    print("videoDic: ",videoDic)
                    print("userDic: ",userDic)
                    print("soundDic: ",soundDic)
                    
                    let likeCount = videoDic.value(forKey: "like_count")
                    let commentCount = videoDic.value(forKey: "comment_count")
                    let like = videoDic.value(forKey: "like")
                    
                    let cell = self.feedCV.cellForItem(at: ip) as? homeFeedCollectionViewCell
                    //                cell?.playerView.pause()
                    //                cell?.pause()
                    cell?.lblLike.text = "\(likeCount!)"
                    cell?.lblComment.text = "\(commentCount!)"
                    let liked = "\(like!)"
                    if liked == "1"{
                        //                            cell?.like()
                        cell?.alreadyLiked()
                        
                    }else{
                        cell?.heartAnimationView?.removeFromSuperview()
                    }
                        print("likedd: ",like!)
                    
                    let vidDetail = videoDetailMVC(vidLikes: "\(likeCount!)", vidComments: "\(commentCount!)", isLike: "\(like!)")
                    
                    self.videoDetail.append(vidDetail)
                    
                }
            }
        }
    }
    
    func settingUDID(){
        let uid = UIDevice.current.identifierForVendor!.uuidString
        ApiHandler.sharedInstance.registerDevice(key: uid) { (isSuccess, response) in
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    
                    let msg = response?.value(forKey: "msg") as! NSDictionary
                    let device = msg.value(forKey: "Device") as! NSDictionary
                    let key = device.value(forKey: "key") as! String
                    let deviceID = device.value(forKey: "id") as! String
                    print("deviceKey: ",key)
                    
                    UserDefaults.standard.set(key, forKey: "deviceKey")
                    UserDefaults.standard.set(deviceID, forKey: "deviceID")
                    
                    print("response@200: ",response!)
                    
                    self.getDataForFeeds()
                }else{
                    print("response not 200: ",response!)
                    
                    ApiHandler.sharedInstance.showDeviceDetails(key: uid) { (isSuccess, response) in
                        if isSuccess{
                            if response?.value(forKey: "code") as! NSNumber == 200 {
                                
                                let msg = response?.value(forKey: "msg") as! NSDictionary
                                let device = msg.value(forKey: "Device") as! NSDictionary
                                let key = device.value(forKey: "key") as! String
                                let deviceID = device.value(forKey: "id") as! String
                                print("device id: ",deviceID)
                                
                                UserDefaults.standard.set(key, forKey: "deviceKey")
                                UserDefaults.standard.set(deviceID, forKey: "deviceID")
                                
                                self.getDataForFeeds()
                                
                                print("deviceKey: ", key)
                                print("response@200: ",response!)
                            }else{
                                self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12.0))
                            }
                        }
                    }
                    
                }
            }else{
                print("Something went wrong in API registerDevice: ",response!)
            }
        }
    }
    
    func likeVideo(uid:String){
        
        let vidID = videoID
        ApiHandler.sharedInstance.likeVideo(user_id: uid, video_id: vidID) { (isSuccess, response) in
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    print("likeVideo response msg: ",response?.value(forKey: "msg"))
                }else{
                    print("likeVideo response msg: ",response?.value(forKey: "msg"))
                }
            }
        }
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    
}
//@available(iOS 13.0, *)
extension homeFeedViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        videosMainArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeFeedCVC", for: indexPath) as! homeFeedCollectionViewCell
        
        if userVideoArr.isEmpty == false{
//            cell.btnFollow.isHidden = true
            cell.userImg.isUserInteractionEnabled = false
            
        }else{
//            cell.btnFollow.isHidden = false
            cell.userImg.isUserInteractionEnabled = true
        }
        
        if isFollowing == true{
//            cell.btnFollow.isHidden = true
        }else{
//            cell.btnFollow.isHidden = false
        }
        
    
        let vidObj = videosMainArr[indexPath.row]
        let vidString = AppUtility?.detectURL(ipString: vidObj.videoURL)
        let vidURL = URL(string: vidString!)
        self.items.append(vidURL!)
        
        let vidDesc = vidObj.description
        let commentCount = vidObj.comment_count
        let likeCount = vidObj.like_count
        
        let soundName = vidObj.soundName
        
        let userImgPath = AppUtility?.detectURL(ipString: vidObj.userProfile_pic)
        let userImgUrl = URL(string: userImgPath!)
        let userName = vidObj.username
        
        if vidObj.verified == "0"{
            cell.verifiedUserImg.isHidden = true
        }
        
        let duetVidID = vidObj.duetVideoID
        if duetVidID != "0"{
            cell.playerView.contentMode = .scaleAspectFit
        }else{
            cell.playerView.contentMode = .scaleAspectFill
        }
        print("CommentCount: ",commentCount)
        cell.set(url: vidURL!)
        cell.txtDesc.text = vidDesc
        cell.lblComment.text = commentCount
        cell.lblLike.text = likeCount
        cell.userName.text = "@\(userName)"
        cell.musicName.text = soundName
        
        cell.musicName.startLoading()
        
        cell.userImg.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.userImg.sd_setImage(with: userImgUrl, placeholderImage: UIImage(named: "noUserImg"))

        print("vidObj.followBtn: ",vidObj.followBtn)
        
        if vidObj.followBtn == "following"{
//            cell.btnFollow.setTitle("UnFollow", for: .normal)
        }else{
//            cell.btnFollow.setTitle("Follow", for: .normal)
        }
        
//        cell.btnFollow.tag = indexPath.row
//        cell.btnFollow.addTarget(self, action: #selector(btnFollowFunc(sender:)), for: .touchUpInside)
        
        //cell.userImg.tag = indexPath.row
        
        let gestureUserImg = UITapGestureRecognizer(target: self, action:  #selector(self.userImgTapped(sender:)))
        cell.userImg.tag = indexPath.row
        cell.userImg.addGestureRecognizer(gestureUserImg)
        
        let gestureBtnLike = UITapGestureRecognizer(target: self, action:  #selector(self.btnLikeTapped(sender:)))
        cell.btnLike.tag = indexPath.row
        cell.btnLike.isUserInteractionEnabled = true
        cell.btnLike.addGestureRecognizer(gestureBtnLike)
        
        let gestureBtnShare = UITapGestureRecognizer(target: self, action:  #selector(self.btnShareTapped(sender:)))
        cell.btnShare.tag = indexPath.row
        cell.btnShare.isUserInteractionEnabled = true
        cell.btnShare.addGestureRecognizer(gestureBtnShare)
        
        let gestureBtnComment = UITapGestureRecognizer(target: self, action:  #selector(self.btnCommentTapped(sender:)))
        cell.btnComment.tag = indexPath.row
        cell.btnComment.isUserInteractionEnabled = true
        cell.btnComment.addGestureRecognizer(gestureBtnComment)
        
        return cell
    }
    
    /*
    @objc func btnFollowFunc(sender : UIButton){
        print(sender.tag)
        
        let uid = UserDefaults.standard.string(forKey: "userID")
        if uid == "" || uid == nil{
          //  showToast(message: "Please Login..", font: .systemFont(ofSize: 12.0))
            loginScreenAppear()
        }else{
            followUserFunc(cellNo: sender.tag)
            print("sender.currentTitle: ",sender.currentTitle)
            
            if sender.currentTitle == "UnFollow"{
                sender.setTitle("Follow", for: .normal)
            }else{
                sender.setTitle("UnFollow", for: .normal)
            }
            
        }
    }
    */
    
    @objc func userImgTapped(sender : UITapGestureRecognizer) {
        // Do what you want
        
        print("user img : \(sender.view?.tag)")
        
        let obj = videosMainArr[sender.view!.tag]
        print("obj user id : ",obj.userID)
        
        let otherUserID = obj.userID
        let userID = UserDefaults.standard.string(forKey: "userID")
        
        if userID == nil || userID == ""{
//            showToast(message: "Login to Continue..", font: .systemFont(ofSize: 12))
            loginScreenAppear()
        }else{
            let vc = storyboard?.instantiateViewController(withIdentifier: "newProfileVC") as!  newProfileViewController
//            vc.isOtherUserVisting = true
            vc.hidesBottomBarWhenPushed = true
//            vc.otherUserID = otherUserID
            UserDefaults.standard.set(otherUserID, forKey: "otherUserID")
            navigationController?.pushViewController(vc, animated: true)
        }

    }
    @objc func btnLikeTapped(sender : UITapGestureRecognizer) {
        // Do what you want
        
        print("btn like : \(sender.view?.tag)")
        
        let cell = self.feedCV.cellForItem(at: IndexPath(row: sender.view!.tag, section: 0)) as? homeFeedCollectionViewCell
        
        let userID = UserDefaults.standard.string(forKey: "userID")
        
        if userID != "" && userID != nil{
            if cell?.isLiked == false{
                cell?.like()
                self.likeVideo(uid:userID!)
                self.getVideoDetails(ip: currentVidIP)
            }else{
                cell?.unlike()
                self.likeVideo(uid:userID!)
                self.getVideoDetails(ip: currentVidIP)
            }
        }else{

            loginScreenAppear()
        }
        
        
    }
    @objc func btnShareTapped(sender : UITapGestureRecognizer) {
        // Do what you want
        
        print("btn share : \(sender.view?.tag)")
        let vc = storyboard?.instantiateViewController(withIdentifier: "shareVC") as! shareViewController
        vc.videoID = videoID
        vc.objToShare.removeAll()
        vc.objToShare.append(videoURL)
        vc.currentVideoUrl = videoURL
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
        
    }
    @objc func btnCommentTapped(sender : UITapGestureRecognizer) {
        // Do what you want
        
        print("btn comment : \(sender.view?.tag)")
        
        print("user img : \(sender.view?.tag)")
        
        let obj = videosMainArr[sender.view!.tag]
        print("obj user id : ",obj.userID)
        
        let otherUserID = obj.userID
        let userID = UserDefaults.standard.string(forKey: "userID")
        
        if userID == nil || userID == ""{

            loginScreenAppear()
        }else{

            let vc = storyboard?.instantiateViewController(withIdentifier: "commentsNewVC") as! commentsNewViewController
            vc.video_id = videoID
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true, completion: nil)
        }
        
    }
    
    func followUserFunc(cellNo:Int){
        let videoObj = videosMainArr[cellNo]
        let rcvrID = videoObj.videoUserID
        let userID = UserDefaults.standard.string(forKey: "userID")
        
        followUser(rcvrID: rcvrID, userID: userID!)
    }
    
    //    MARK:- Follow user API
    func followUser(rcvrID:String,userID:String){
        
        AppUtility?.startLoader(view: view)
        ApiHandler.sharedInstance.followUser(sender_id: userID, receiver_id: rcvrID) { (isSuccess, response) in
            if isSuccess {
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    AppUtility?.stopLoader(view: self.view)
                    
                }else{
                    AppUtility?.stopLoader(view: self.view)
                    self.showToast(message: (response?.value(forKey: "msg") as? String)!, font: .systemFont(ofSize: 12))
                }
                
            }else{
                AppUtility?.stopLoader(view: self.view)
                self.showToast(message: (response?.value(forKey: "msg") as? String)!, font: .systemFont(ofSize: 12))
            }
        }
    }
    
//    MARK:- Login screen will appear func
    func loginScreenAppear(){
        let navController = UINavigationController.init(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "newLoginVC"))
        navController.navigationBar.isHidden = true
        navController.modalPresentationStyle = .overFullScreen

        self.present(navController, animated: true, completion: nil)
    }
    
    
}

//@available(iOS 13.0, *)
extension homeFeedViewController:UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? homeFeedCollectionViewCell {
            cell.pause()
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate { check() }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        check()
    }
    
    func check() {
        checkPreload()
        checkPlay()
    }
    
    func checkPreload() {
        guard let lastRow = feedCV.indexPathsForVisibleItems.last?.row else { return }
        
        let urls = items
            .suffix(from: min(lastRow + 1, items.count))
            .prefix(2)
        
        print("itrems url: ",urls)
        VideoPreloadManager.shared.set(waiting: Array(urls))
        
        //        VideoPlayer.preloadByteCount = 1024 * 1024 // = 1M
        
        
    }
    
    func checkPlay() {
        let visibleCells = feedCV.visibleCells.compactMap { $0 as? homeFeedCollectionViewCell }
        
        guard visibleCells.count > 0 else { return }
        
        let visibleFrame = CGRect(x: 0, y: feedCV.contentOffset.y, width: feedCV.bounds.width, height: feedCV.bounds.height)
        
        let visibleCell = visibleCells
            .filter { visibleFrame.intersection($0.frame).height >= $0.frame.height / 2 }
            .first
        
        visibleCell?.play()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width:collectionView.layer.bounds.width , height: collectionView.layer.bounds.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        let vidObj = videosMainArr[indexPath.row]
        videoID = vidObj.videoID
        videoURL = vidObj.videoURL
        
        currentVidIP = indexPath
        
        getVideoDetails(ip: indexPath)
        
        if let cell = cell as? homeFeedCollectionViewCell {
            cell.play()
//            cell.lblLike.text =
        }
        print("videoID: \(videoID), videoURL: \(videoURL)")
        
        print("index@row: ",indexPath.row)
        if indexPath.row == videosMainArr.count - 4{
            
            self.startPoint+=1
            print("StartPoint: ",startPoint)
            
            if isFollowing == true{
                self.getFollowingVideos(startPoint: "\(self.startPoint)")
            }else if userVideoArr.isEmpty == false || discoverVideoArr.isEmpty == false{
                
            }else{
                self.getAllVideos(startPoint: "\(self.startPoint)")
            }
            
            print("index@row: ",indexPath.row)
            
        }
        
        
    }
}
//@available(iOS 13.0, *)
extension homeFeedViewController: UIGestureRecognizerDelegate {
    @objc func handleSingleTap(_ gesture: UITapGestureRecognizer){
        print("singletapped")
        let visiblePaths = self.feedCV.indexPathsForVisibleItems
        for i in visiblePaths  {
            let cell = feedCV.cellForItem(at: i) as? homeFeedCollectionViewCell
            //                cell?.playerView.pause()
            //                cell?.pause()
            
            if cell!.playerView.state == .playing {
                cell!.playerView.pause(reason: .userInteraction)
                cell!.btnPlayImg.isHidden = false
            } else {
                cell!.btnPlayImg.isHidden = true
                cell!.playerView.resume()
            }
            
        }
    }
    
    @objc func handleDoubleTap(_ gesture: UITapGestureRecognizer){
        print("doubletapped")
    }
    
//    Mark:- On audio on mute button
    func setupAudio() {
      let audioSession = AVAudioSession.sharedInstance()
        _ = try? audioSession.setCategory(AVAudioSession.Category.playback)
      _ = try? audioSession.setActive(true)

    }
}

