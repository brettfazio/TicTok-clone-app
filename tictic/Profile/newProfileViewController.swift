//
//  newProfileViewController.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 13/10/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
import DropDown
import Lottie

//@available(iOS 13.0, *)
class newProfileViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    
    var myUser: [User]? {didSet {}}
    var userID = ""
    var otherUserID = ""
    
    
    @IBOutlet var scrollViewOutlet: UIScrollView!
    @IBOutlet var whoopsView: UIView!
    
    @IBOutlet var userImageOutlet: [UIImageView]!
    
    @IBOutlet weak var userHeaderName: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var vidContainerView: UIView!
    @IBOutlet weak var likedContainerView: UIView!
    @IBOutlet weak var privateContainerView: UIView!
    
    @IBOutlet weak var profileDropDownBtn: UIButton!
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var btnChatOutlet: UIButton!
    @IBOutlet weak var btnFollow: UIButton!
    
    //MARK: - DropDown's
    let profileDropDown = DropDown()
    
    var videosMainArr = [videoMainMVC]()
    
    var likeVidArr = [videoMainMVC]()
    var privateVidArr = [videoMainMVC]()
    var userVidArr = [videoMainMVC]()
    var userData = [userMVC]()
    
    var privacySettingData = [privacySettingMVC]()
    var pushNotiSettingData = [pushNotiSettingMVC]()
    
    var isOtherUserVisting = false
    
    var storeSelectedIP = IndexPath(item: 0, section: 0)
    
    var userInfo = [["type":"Following","count":"170"],["type":"Followers","count":"60.1K"],["type":"Likes","count":"5.7M"],["type":"Videos","count":"320"]]
    
    
    var userItem = [["Image":"music tok icon-2","ImageSelected":"music tok icon-5","isSelected":"true"],["Image":"likeVideo","ImageSelected":"music tok icon-6","isSelected":"false"],["Image":"music tok icon-1","ImageSelected":"music tok icon-4","isSelected":"false"]]
    
    //MARK:- Outlets
    
    @IBOutlet weak var userInfoCollectionView: UICollectionView!
    @IBOutlet weak var userItemsCollectionView: UICollectionView!
    @IBOutlet weak var videosCV: UICollectionView!
    
    //    @IBOutlet weak var heightOfLikedCVconst: NSLayoutConstraint!
    @IBOutlet weak var uperViewHeightConst: NSLayoutConstraint!
//    var arrImage = [["image":"v1"],["image":"v3"],["image":"v1"],["image":"v3"],["image":"v1"],["image":"v3"],["image":"v3"],["image":"v3"],["image":"v3"],["image":"v3"],["image":"v3"],["image":"v3"],["image":"v3"],["image":"v3"],["image":"v3"],["image":"v3"],["image":"v1"],["image":"v3"]]
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        setupDropDowns()
        /*
        let height = videosCV.collectionViewLayout.collectionViewContentSize.height
        uperViewHeightConst.constant = height
        print("height: ",height)
        //        self.heightOfLikedCVconst.constant =  CGFloat(200 * arrImage.count/3)
        self.view.layoutIfNeeded()
        videosCV.reloadData()
         */
        if #available(iOS 10.0, *) {
            scrollViewOutlet.refreshControl = refresher
        } else {
            scrollViewOutlet.addSubview(refresher)
        }
    }
    
    @objc
    func requestData() {
        print("requesting data")
//        getVideosData()
//        getSliderData()
        
        for i in 0..<self.userItem.count {
            var obj  = self.userItem[i]
            obj.updateValue("false", forKey: "isSelected")
            self.userItem.remove(at: i)
            self.userItem.insert(obj, at: i)
            
        }

        self.StoreSelectedIndex(index: storeSelectedIP.row)
        let deadline = DispatchTime.now() + .milliseconds(700)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.refresher.endRefreshing()
        }
    }
    //    MARK:- WILL APPEAR
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchingUserDataFunc()
    }
    
    func fetchingUserDataFunc(){
        self.userID = UserDefaults.standard.string(forKey: "userID")!
        /*
        if isOtherUserVisting == true{
            UserDefaults.standard.set(otherUserID, forKey: "otherUserID")
            print("otherUsrID: ",otherUserID)
            self.getOtherUserDetails()
            btnChatOutlet.isHidden = false
            btnFollow.isHidden = false
        
        }else{
            UserDefaults.standard.set("", forKey: "otherUserID")
            self.otherUserID = ""
            self.getUserDetails()
            btnChatOutlet.isHidden = true
            btnFollow.isHidden = true
        }
        
        
        */
        self.otherUserID = UserDefaults.standard.string(forKey: "otherUserID")!
        //        self.userID = UserDefaults.standard.string(forKey: "userID")!
        
        print("otherUid: ",self.otherUserID)
        if self.otherUserID != "" && self.otherUserID != nil {
            self.getOtherUserDetails()
            btnChatOutlet.isHidden = false
            btnFollow.isHidden = false
            btnBackOutlet.isHidden = false
//            self.otherUserID = otherUid!
            getUserVideos()
            //            self.StoreSelectedIndex(index: storeSelectedIP.row)
        }else{
            UserDefaults.standard.set("", forKey: "otherUserID")
            self.getUserDetails()
            btnChatOutlet.isHidden = true
            btnFollow.isHidden = true
            btnBackOutlet.isHidden = true
            self.otherUserID = ""
            //            self.StoreSelectedIndex(index: storeSelectedIP.row)
            getUserVideos()
        }
        print("videosArr.count: ",videosMainArr.count)
    }
    
    //MARK:- SetupView
    

    //MARK:- Switch Action
    
    //MARK:- Button Action
    @IBAction func btnChat(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "newChatVC") as! newChatViewController
        vc.receiverData = userData
        vc.otherVisiting = true
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func profileDropDownAction(_ sender: AnyObject) {
        profileDropDown.show()
    }
    //MARK:- DELEGATE METHODS
    
    //MARK: TableView
    
    //MARK: CollectionView.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView ==  userInfoCollectionView{
            return self.userInfo.count
        }else if collectionView ==  videosCV{
            return videosMainArr.count
        }else{
            return self.userInfo.count
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "newProfileItemsCVC", for:indexPath) as! newProfileItemsCollectionViewCell
        
        if collectionView ==  userInfoCollectionView{
            
            cell.lblCount.text =  self.userInfo[indexPath.row]["count"]
            cell.typeFollowing.text = self.userInfo[indexPath.row]["type"]
            
            if indexPath.row ==  self.userInfo.count - 1 {
                cell.verticalView.isHidden = true
            }
            else
            {
                cell.verticalView.isHidden = false
            }
            
            
        }
        else if collectionView == videosCV{
            let videoObj = videosMainArr[indexPath.row]
//            cell.imgVideoTrimer.sd_setImage(with: URL(string:videoObj.videoGIF), placeholderImage: UIImage(named: "videoPlaceholder"))
            
            let gifURL = AppUtility?.detectURL(ipString: videoObj.videoGIF)
            
            cell.imgVideoTrimer.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgVideoTrimer.sd_setImage(with: URL(string:(gifURL!)), placeholderImage: UIImage(named:"videoPlaceholder"))
            
            cell.lblViewerCount.text(videoObj.view)
        }
        else
        {
            if indexPath.row == 0 {
                if self.userItem[indexPath.row]["isSelected"] == "false"{
                    cell.horizontalView.isHidden  = true
                    cell.imgItems.image = UIImage(named: self.userItem[indexPath.row]["Image"]!)
                }else{
                    cell.horizontalView.isHidden  = false
                    cell.imgItems.image = UIImage(named: self.userItem[indexPath.row]["ImageSelected"]!)
                }
            }
            if indexPath.row == 1 {
                if self.userItem[indexPath.row]["isSelected"] == "false"{
                    cell.horizontalView.isHidden  = true
                    cell.imgItems.image = UIImage(named: self.userItem[indexPath.row]["Image"]!)
                }else{
                    cell.horizontalView.isHidden  = false
                    cell.imgItems.image = UIImage(named: self.userItem[indexPath.row]["ImageSelected"]!)
                }
            }
            if indexPath.row == 2{
                if self.userItem[indexPath.row]["isSelected"] == "false"{
                    cell.horizontalView.isHidden  = true
                    cell.imgItems.image = UIImage(named: self.userItem[indexPath.row]["Image"]!)
                }else{
                    cell.horizontalView.isHidden  = false
                    cell.imgItems.image = UIImage(named: self.userItem[indexPath.row]["ImageSelected"]!)
                }
            }
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == userItemsCollectionView{
            
            for i in 0..<self.userItem.count {
                var obj  = self.userItem[i]
                obj.updateValue("false", forKey: "isSelected")
                self.userItem.remove(at: i)
                self.userItem.insert(obj, at: i)
                
            }
            
            self.StoreSelectedIndex(index: indexPath.row)
            self.storeSelectedIP = indexPath
        }
        else if collectionView == userInfoCollectionView
        {
        }
        else
        {
            let vc = storyboard?.instantiateViewController(withIdentifier: "homeFeedVC") as! homeFeedViewController
            vc.userVideoArr = videosMainArr
            vc.indexAt = indexPath
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @objc func StoreSelectedIndex(index:Int){
        var obj  =  self.userItem[index]
        obj.updateValue("true", forKey: "isSelected")
        self.userItem.remove(at: index)
        self.userItem.insert(obj, at: index)
        
        if index == 0{
            print("my vid")
            getUserVideos()
            AppUtility?.startLoader(view: self.videosCV)
//            self.vidContainerView.isHidden = false

//            self.privateContainerView.isHidden = true
//            self.likedContainerView.isHidden = true
            
        }else if index == 1{
            print("liked")
            getLikedVideos()
            AppUtility?.startLoader(view: self.videosCV)
//            self.likedContainerView.isHidden = false

//            self.vidContainerView.isHidden = true
//            self.privateContainerView.isHidden = true
            
        }else{
            print("private")
            getPrivateVideos()
            AppUtility?.startLoader(view: self.videosCV)
//            self.privateContainerView.isHidden = false

//            self.likedContainerView.isHidden = true
//            self.vidContainerView.isHidden = true
            
        }
        self.userItemsCollectionView.reloadData()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let index = Int(self.userItemsCollectionView.contentOffset.x) / Int(self.userItemsCollectionView.frame.width)
        
        
        print("index: ",index)
        if index == 0{
            
        }else{
            
        }
        
        let y: CGFloat = scrollView.contentOffset.y
        print(y)
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == userInfoCollectionView{
            return CGSize(width: self.userInfoCollectionView.frame.size.width/4, height: 50)
            
        }else if collectionView == userItemsCollectionView{
            return CGSize(width: self.userItemsCollectionView.frame.size.width/3, height: 50)
            
        }else{
            return CGSize(width: self.videosCV.frame.size.width/3-1, height: 204)
        }
    }
    //MARK: Segment Control
    
    //MARK: Alert View
    
    //MARK: TextField
    
    //MARK: Location
    
    //MARK: Google Maps
    
    //MARK:- View Life Cycle End here...
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBack(_ sender: Any) {
        UserDefaults.standard.set("", forKey: "otherUserID")
        navigationController?.popViewController(animated: true)
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        print("toppppppp")
    }
    
    //MARK:- GET USER OWN DETAILS
    func getUserDetails(){
        self.userData.removeAll()
        
        AppUtility?.startLoader(view: view)
        ApiHandler.sharedInstance.showOwnDetail(user_id: self.userID) { (isSuccess, response) in
            if isSuccess{
                
                print("response: ",response?.allValues)
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    let userObjMsg = response?.value(forKey: "msg") as! NSDictionary
                    let userObj = userObjMsg.value(forKey: "User") as! NSDictionary
                    
                    let privSettingObj = userObjMsg.value(forKey: "PrivacySetting") as! NSDictionary
                    let pushNotiSettingObj = userObjMsg.value(forKey: "PushNotification") as! NSDictionary
                    
                    //                    MARK:- PRIVACY SETTING DATA
                    let direct_message = privSettingObj.value(forKey: "direct_message") as! String
                    let duet = privSettingObj.value(forKey: "duet") as! String
                    let liked_videos = privSettingObj.value(forKey: "liked_videos") as! String
                    let video_comment = privSettingObj.value(forKey: "video_comment") as! String
                    let videos_download = privSettingObj.value(forKey: "videos_download")
                    let privID = privSettingObj.value(forKey: "id")
                    
                    let privObj = privacySettingMVC(direct_message: direct_message, duet: duet, liked_videos: liked_videos, video_comment: video_comment, videos_download: "\(videos_download!)", id: "\(privID!)")
                    self.privacySettingData.append(privObj)
                    
                    //                    MARK:- PUSH NOTIFICATION SETTING DATA
                    let cmnt = pushNotiSettingObj.value(forKey: "comments")
                    let direct_messages = pushNotiSettingObj.value(forKey: "direct_messages")
                    let likes = pushNotiSettingObj.value(forKey: "likes")
                    let pushID = pushNotiSettingObj.value(forKey: "id")
                    let new_followers = pushNotiSettingObj.value(forKey: "new_followers")
                    let video_updates = pushNotiSettingObj.value(forKey: "video_updates")
                    let mentions = pushNotiSettingObj.value(forKey: "mentions")
                    
                    let pushObj = pushNotiSettingMVC(comments: "\(cmnt!)", direct_messages: "\(direct_messages!)", likes: "\(likes!)", mentions: "\(mentions!)", new_followers: "\(new_followers!)", video_updates: "\(video_updates!)", id: "\(pushID!)")
                    
                    self.pushNotiSettingData.append(pushObj)
                    
                    let userImage = (userObj.value(forKey: "profile_pic") as? String)!
                    let userName = (userObj.value(forKey: "username") as? String)!
                    let followers = "\(userObj.value(forKey: "followers_count") ?? "")"
                    let followings = "\(userObj.value(forKey: "following_count") ?? "")"
                    let likesCount = "\(userObj.value(forKey: "likes_count") ?? "")"
                    let videoCount = "\(userObj.value(forKey: "video_count") ?? "")"
                    let firstName = (userObj.value(forKey: "first_name") as? String)!
                    let lastName = (userObj.value(forKey: "last_name") as? String)!
                    let gender = (userObj.value(forKey: "gender") as? String)!
                    let bio = (userObj.value(forKey: "bio") as? String)!
                    let dob = (userObj.value(forKey: "dob") as? String)!
                    let website = (userObj.value(forKey: "website") as? String)!
                    
                    let userId = (userObj.value(forKey: "id") as? String)!
                    
                    let user = userMVC(userID: userId, first_name: firstName, last_name: lastName, gender: gender, bio: bio, website: website, dob: dob, social_id: "", userEmail: "", userPhone: "", password: "", userProfile_pic: userImage, role: "", username: userName, social: "", device_token: "", videoCount: videoCount, likesCount: likesCount, followers: followers, following: followings, followBtn: "")
                    
                    self.userData.append(user)
                    
                    AppUtility?.stopLoader(view: self.view)
//                    self.getUserVideos()
                    self.setProfileData()
                }else{
                    AppUtility?.stopLoader(view: self.view)
                    //                    self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                    print("showOwnDetail API:",response?.value(forKey: "msg") as Any)
                }
                
            }else{
                AppUtility?.stopLoader(view: self.view)
                //                self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                print("showOwnDetail API:",response?.value(forKey: "msg") as Any)
            }
        }
    }
    
    //MARK:- GET other USER DETAILS
    func getOtherUserDetails(){
        self.userData.removeAll()
        
        print("otheruser: ",self.otherUserID)
        print("userID: ",self.userID)
        AppUtility?.startLoader(view: view)
        ApiHandler.sharedInstance.showOtherUserDetail(user_id: self.userID, other_user_id: self.otherUserID) { (isSuccess, response) in
            if isSuccess{
                
                print("response: ",response?.allValues)
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    let userObjMsg = response?.value(forKey: "msg") as! NSDictionary
                    let userObj = userObjMsg.value(forKey: "User") as! NSDictionary
                    
                    let userImage = (userObj.value(forKey: "profile_pic") as? String)!
                    let userName = (userObj.value(forKey: "username") as? String)!
                    let followers = "\(userObj.value(forKey: "followers_count") ?? "")"
                    let followings = "\(userObj.value(forKey: "following_count") ?? "")"
                    let likesCount = "\(userObj.value(forKey: "likes_count") ?? "")"
                    let videoCount = "\(userObj.value(forKey: "video_count") ?? "")"
                    let firstName = (userObj.value(forKey: "first_name") as? String)!
                    let lastName = (userObj.value(forKey: "last_name") as? String)!
                    let gender = (userObj.value(forKey: "gender") as? String)!
                    let bio = (userObj.value(forKey: "bio") as? String)!
                    let dob = (userObj.value(forKey: "dob") as? String)!
                    let website = (userObj.value(forKey: "website") as? String)!
                    let followBtn = (userObj.value(forKey: "button") as? String)!
                    
                    let userId = (userObj.value(forKey: "id") as? String)!
                    
                    let user = userMVC(userID: userId, first_name: firstName, last_name: lastName, gender: gender, bio: bio, website: website, dob: dob, social_id: "", userEmail: "", userPhone: "", password: "", userProfile_pic: userImage, role: "", username: userName, social: "", device_token: "", videoCount: videoCount, likesCount: likesCount, followers: followers, following: followings, followBtn: followBtn)
                    
                    self.userData.append(user)
                    
                    AppUtility?.stopLoader(view: self.view)
                    //                    self.getVideos()
                    self.setProfileData()
                }else{
                    AppUtility?.stopLoader(view: self.view)
                    //                    self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                    print("showOtherUserDetail API:",response?.value(forKey: "msg") as Any)
                }
                
            }else{
                AppUtility?.stopLoader(view: self.view)
                //                self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                print("showOtherUserDetail API:",response?.value(forKey: "msg") as Any)
            }
        }
    }
    
    //    MARK:- GET USERS VIDEOS
    func getUserVideos(){
        
        
        //        AppUtility?.stopLoader(view: view)
        
        print("userID test: ",userID)
        self.userVidArr.removeAll()
        self.videosMainArr.removeAll()
        
        var uid = ""
        if otherUserID != ""{
            uid = self.otherUserID
        }else{
            uid = self.userID
        }
        print("uid: ",uid)
        
        //        AppUtility?.startLoader(view: self.view)
        ApiHandler.sharedInstance.showVideosAgainstUserID(user_id: uid) { (isSuccess, response) in
            AppUtility?.stopLoader(view: self.view)
            if isSuccess{
                print("response: ",response?.allValues)
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    let userObjMsg = response?.value(forKey: "msg") as! NSDictionary
                    let userPublicObj = userObjMsg.value(forKey: "public") as! NSArray
                    
                    for i in 0..<userPublicObj.count{
                        let publicObj  = userPublicObj.object(at: i) as! NSDictionary
                        
                        let videoObj = publicObj.value(forKey: "Video") as! NSDictionary
                        let userObj = publicObj.value(forKey: "User") as! NSDictionary
                        let soundObj = publicObj.value(forKey: "Sound") as! NSDictionary
                        
                        let videoUrl = videoObj.value(forKey: "video") as! String
                        
                        let videoThum = videoObj.value(forKey: "thum") as! String
                        let videoGif = videoObj.value(forKey: "gif") as! String
                        
                        let videoLikes = "\(videoObj.value(forKey: "like_count") ?? "")"
                        let videoComments = "\(videoObj.value(forKey: "comment_count") ?? "")"
                        let like = "\(videoObj.value(forKey: "like") ?? "")"
                        let allowComment = videoObj.value(forKey: "allow_comments") as! String
                        let videoID = videoObj.value(forKey: "id") as! String
                        let videoDesc = videoObj.value(forKey: "description") as! String
                        let allowDuet = videoObj.value(forKey: "allow_duet") as! String
                        let created = videoObj.value(forKey: "created") as! String
                        let views = "\(videoObj.value(forKey: "view") ?? "")"
                        let duetVidID = videoObj.value(forKey: "duet_video_id")
                        
                        let userID = userObj.value(forKey: "id") as! String
                        let username = userObj.value(forKey: "username") as! String
                        let userOnline = userObj.value(forKey: "online") as! String
                        let userImg = userObj.value(forKey: "profile_pic") as! String
                        //                        let followBtn = userObj.value(forKey: "button") as! String
                        let verified = userObj.value(forKey: "verified")
                        
                        let soundID = soundObj.value(forKey: "id") as? String
                        let soundName = soundObj.value(forKey: "name") as? String
                        
                        
                        let video = videoMainMVC(videoID: videoID, videoUserID: "", fb_id: "", description: videoDesc, videoURL: videoUrl, videoTHUM: videoThum, videoGIF: videoGif, view: views, section: "", sound_id: "\(soundID ?? "")", privacy_type: "", allow_comments: allowComment, allow_duet: allowDuet, block: "", duet_video_id: "", old_video_id: "", created: created, like: like, favourite: "", comment_count: videoComments, like_count: videoLikes, followBtn: "", duetVideoID: "\(duetVidID!)", userID: userID, first_name: "", last_name: "", gender: "", bio: "", website: "", dob: "", social_id: "", userEmail: "", userPhone: "", password: "", userProfile_pic: "", role: "", username: username, social: "", device_token: "", videoCount: "", verified: "\(verified ?? "")", soundName: "\(soundName ?? "")")
                        
                        self.userVidArr.append(video)
                    }
                    
                }else{
                    AppUtility?.stopLoader(view: self.view)
                    //  self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                }
                
                self.videosMainArr = self.userVidArr
                if self.videosMainArr.isEmpty == true{
                    self.whoopsView.isHidden = false
                }else{
                    self.whoopsView.isHidden = true
                }
                
                print("videosMainArr.count: ",self.videosMainArr.count)

                self.videosCV.reloadData()
                
                let height = self.videosCV.collectionViewLayout.collectionViewContentSize.height
                self.uperViewHeightConst.constant = height
                print("height: ",height)
                //        self.heightOfLikedCVconst.constant =  CGFloat(200 * arrImage.count/3)
                self.view.layoutIfNeeded()
                self.videosCV.reloadData()
                
            }else{
                AppUtility?.stopLoader(view: self.view)
                //                self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                print("showVideosAgainstUserID API:",response?.value(forKey: "msg") as Any)
            }
        }
    }
    
    //    MARK:- GET LIKED VIDEOS
    func getLikedVideos(){
        
        
        //        AppUtility?.stopLoader(view: view)
        
        print("userID test: ",userID)
        self.likeVidArr.removeAll()
        self.videosMainArr.removeAll()
        
        var uid = ""
        if otherUserID != ""{
            uid = self.otherUserID
        }else{
            uid = self.userID
        }
        
        //        AppUtility?.startLoader(view: self.view)
        ApiHandler.sharedInstance.showUserLikedVideos(user_id: uid) { (isSuccess, response) in
            AppUtility?.stopLoader(view: self.view)
            if isSuccess{
                print("response: ",response?.allValues)
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    let likeObjMsg = response?.value(forKey: "msg") as! NSArray
                    //                    let userPublicObj = userObjMsg.value(forKey: "public") as! NSArray
                    
                    for i in 0..<likeObjMsg.count{
                        let likeObj  = likeObjMsg.object(at: i) as! NSDictionary
                        
                        let videoObj = likeObj.value(forKey: "Video") as! NSDictionary
                        
                        //                        let soundObj = videoObj.value(forKey: "Sound") as! NSDictionary
                        let userObj = videoObj.value(forKey: "User") as! NSDictionary
                        
                        
                        let videoUrl = videoObj.value(forKey: "video") as! String
                        let videoThum = videoObj.value(forKey: "thum") as! String
                        let videoGif = videoObj.value(forKey: "gif") as! String
                        let videoLikes = "\(videoObj.value(forKey: "like_count") ?? "")"
                        let videoComments = "\(videoObj.value(forKey: "comment_count") ?? "")"
                        let like = "\(videoObj.value(forKey: "like") ?? "")"
                        let allowComment = videoObj.value(forKey: "allow_comments") as! String
                        let videoID = videoObj.value(forKey: "id") as! String
                        let videoDesc = videoObj.value(forKey: "description") as! String
                        let allowDuet = videoObj.value(forKey: "allow_duet") as! String
                        let created = videoObj.value(forKey: "created") as! String
                        let views = "\(videoObj.value(forKey: "view") ?? "")"
                        let duetVidID = videoObj.value(forKey: "duet_video_id")
                        
                        let userID = userObj.value(forKey: "id") as! String
                        let username = userObj.value(forKey: "username") as! String
                        let userOnline = userObj.value(forKey: "online") as! String
                        let userImg = userObj.value(forKey: "profile_pic") as! String
                        let verified = userObj.value(forKey: "verified")
                        //                        let followBtn = userObj.value(forKey: "button") as! String
                        
                        //                        let soundID = soundObj.value(forKey: "id") as? String
                        //                        let soundName = soundObj.value(forKey: "name") as? String
                        
                        let video = videoMainMVC(videoID: videoID, videoUserID: "", fb_id: "", description: videoDesc, videoURL: videoUrl, videoTHUM: videoThum, videoGIF: videoGif, view: views, section: "", sound_id: "", privacy_type: "", allow_comments: allowComment, allow_duet: allowDuet, block: "", duet_video_id: "", old_video_id: "", created: created, like: like, favourite: "", comment_count: videoComments, like_count: videoLikes, followBtn: "", duetVideoID: "\(duetVidID!)", userID: userID, first_name: "", last_name: "", gender: "", bio: "", website: "", dob: "", social_id: "", userEmail: "", userPhone: "", password: "", userProfile_pic: "", role: "", username: username, social: "", device_token: "", videoCount: "", verified: "\(verified ?? "")", soundName:  "")
                        
                        self.likeVidArr.append(video)
                    }
                    
                }else{
                    AppUtility?.stopLoader(view: self.view)
                    //  self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                }
                self.videosMainArr = self.likeVidArr
                if self.videosMainArr.isEmpty == true{
                    self.whoopsView.isHidden = false
                }else{
                    self.whoopsView.isHidden = true
                }
                self.videosCV.reloadData()
                let height = self.videosCV.collectionViewLayout.collectionViewContentSize.height
                self.uperViewHeightConst.constant = height
                print("height: ",height)
                //        self.heightOfLikedCVconst.constant =  CGFloat(200 * arrImage.count/3)
                self.view.layoutIfNeeded()
                self.videosCV.reloadData()
                
            }else{
                AppUtility?.stopLoader(view: self.view)
                //                self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                print("showVideosAgainstUserID API:",response?.value(forKey: "msg") as Any)
            }
        }
    }
    
    //    MARK:- GET PRIVATE VIDEOS
    func getPrivateVideos(){
        
        //        AppUtility?.stopLoader(view: view)
        
        print("userID test: ",userID)
        self.likeVidArr.removeAll()
        self.videosMainArr.removeAll()
        
        var uid = ""
        if otherUserID != ""{
            uid = self.otherUserID
        }else{
            uid = self.userID
        }
        
        //        AppUtility?.startLoader(view: self.view)
        ApiHandler.sharedInstance.showVideosAgainstUserID(user_id: uid) { (isSuccess, response) in
            AppUtility?.stopLoader(view: self.view)
            if isSuccess{
                print("response: ",response?.allValues)
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    let userObjMsg = response?.value(forKey: "msg") as! NSDictionary
                    let userPrivateObj = userObjMsg.value(forKey: "private") as! NSArray
                    
                    for i in 0..<userPrivateObj.count{
                        let privateObj  = userPrivateObj.object(at: i) as! NSDictionary
                        
                        let videoObj = privateObj.value(forKey: "Video") as! NSDictionary
                        let userObj = privateObj.value(forKey: "User") as! NSDictionary
                        let soundObj = privateObj.value(forKey: "Sound") as! NSDictionary
                        
                        let videoUrl = videoObj.value(forKey: "video") as! String
                        let videoThum = videoObj.value(forKey: "thum") as! String
                        let videoGif = videoObj.value(forKey: "gif") as! String
                        
                        let videoLikes = "\(videoObj.value(forKey: "like_count") ?? "")"
                        let videoComments = "\(videoObj.value(forKey: "comment_count") ?? "")"
                        let like = "\(videoObj.value(forKey: "like") ?? "")"
                        let allowComment = videoObj.value(forKey: "allow_comments") as! String
                        let videoID = videoObj.value(forKey: "id") as! String
                        let videoDesc = videoObj.value(forKey: "description") as! String
                        let allowDuet = videoObj.value(forKey: "allow_duet") as! String
                        let created = videoObj.value(forKey: "created") as! String
                        let views = "\(videoObj.value(forKey: "view") ?? "")"
                        let duetVidID = videoObj.value(forKey: "duet_video_id")
                        
                        let userID = userObj.value(forKey: "id") as! String
                        let username = userObj.value(forKey: "username") as! String
                        let userOnline = userObj.value(forKey: "online") as! String
                        let userImg = userObj.value(forKey: "profile_pic") as! String
                        //                        let followBtn = userObj.value(forKey: "button") as! String
                        let verified = userObj.value(forKey: "verified")
                        
                        let soundID = soundObj.value(forKey: "id") as? String
                        let soundName = soundObj.value(forKey: "name") as? String
                        
                        let video = videoMainMVC(videoID: videoID, videoUserID: "", fb_id: "", description: videoDesc, videoURL: videoUrl, videoTHUM: videoThum, videoGIF: videoGif, view: views, section: "", sound_id: "\(soundID ?? "")", privacy_type: "", allow_comments: allowComment, allow_duet: allowDuet, block: "", duet_video_id: "", old_video_id: "", created: created, like: like, favourite: "", comment_count: videoComments, like_count: videoLikes, followBtn: "", duetVideoID: "\(duetVidID!)", userID: userID, first_name: "", last_name: "", gender: "", bio: "", website: "", dob: "", social_id: "", userEmail: "", userPhone: "", password: "", userProfile_pic: "", role: "", username: username, social: "", device_token: "", videoCount: "", verified: "\(verified ?? "")", soundName: "\(soundName ?? "")")
                        
                        self.privateVidArr.append(video)
                    }
                    
                }else{
                    AppUtility?.stopLoader(view: self.view)
                    //  self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                }
                
                self.videosMainArr = self.privateVidArr
                if self.videosMainArr.isEmpty == true{
                    self.whoopsView.isHidden = false
                }else{
                    self.whoopsView.isHidden = true
                }
                self.videosCV.reloadData()

                let height = self.videosCV.collectionViewLayout.collectionViewContentSize.height
                self.uperViewHeightConst.constant = height
                print("height: ",height)
                self.view.layoutIfNeeded()
                self.videosCV.reloadData()
                
            }else{
                AppUtility?.stopLoader(view: self.view)
                //                self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                print("showVideosAgainstUserID API:",response?.value(forKey: "msg") as Any)
            }
        }
    }
    func setProfileData(){
        
        let user = userData[0]
//        let user = userData[0]
        self.userInfo = [["type":"Following","count":user.following],["type":"Followers","count":user.followers],["type":"Likes","count":user.likesCount],["type":"Videos","count":"\(user.videoCount)"]]
        userInfoCollectionView.reloadData()
        
        let profilePic = AppUtility?.detectURL(ipString: user.userProfile_pic)
        
        self.userName.text = "@\(user.username)"
        self.userHeaderName.text = user.first_name+" "+user.last_name
        for img in userImageOutlet{
            img.sd_imageIndicator = SDWebImageActivityIndicator.gray
            img.sd_setImage(with: URL(string:profilePic!), placeholderImage: UIImage(named: "noUserImg"))
        }
    }
    
    func setupDropDowns(){
        profileDropDown.width = 150
        profileDropDown.anchorView = profileDropDownBtn
        profileDropDown.backgroundColor = .white
        profileDropDown.bottomOffset = CGPoint(x: 0, y: profileDropDownBtn.bounds.height)
        
        if isOtherUserVisting == true{
            btnBackOutlet.isHidden = false
            profileDropDown.dataSource = [
                "Report",
                "Block"
            ]
        }else{
            btnBackOutlet.isHidden = true
            profileDropDown.dataSource = [
              "Edit Profile",
                //                "Favourite",
                "Setting",
                "Logout"
            ]
        }
        
        // Action triggered on selection
        profileDropDown.selectionAction = { [weak self] (index, item) in
            
            switch item {
            case "Report":
                print("selected item: ",item)
                
                let alertController = UIAlertController(title: "REPORT", message: "Enter the details of Report", preferredStyle: .alert)
                
                alertController.addTextField { (textField : UITextField!) -> Void in
                    textField.placeholder = "Report Title"
                }
                
                let reportAction = UIAlertAction(title: "Report", style: .default, handler: { alert -> Void in
                    let firstTextField = alertController.textFields![0] as UITextField
                    let secondTextField = alertController.textFields![1] as UITextField
                    
                    print("fst txt: ",firstTextField)
                    print("scnd txt: ",secondTextField.text)
                    
                    guard let text = secondTextField.text, !text.isEmpty else {
                        self?.showToast(message: "Fill All Fields", font: .systemFont(ofSize: 12))
                        return
                    }
                    self!.reportUser(reportReason: text)
                })
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil )
                
                alertController.addTextField { (textField : UITextField!) -> Void in
                    textField.placeholder = "Reason"
                }
                
                alertController.addAction(cancelAction)
                alertController.addAction(reportAction)
                
                self!.present(alertController, animated: true, completion: nil)
                
                
            case "Block":
                print("selected item: ",item)
                self!.blockUser()
                
            case "Edit Profile":
                print("selected item: ",item)
                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "editProfileVC") as! editProfileViewController
                vc.userData = self!.userData
                vc.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(vc, animated: true)
            case "Favourite":
                print("selected item: ",item)
            case "Setting":
                print("selected item: ",item)
                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "privacyAndSettingVC") as! privacyAndSettingViewController
//                  vc.userData = self!.userData
                  vc.hidesBottomBarWhenPushed = true
                  self?.navigationController?.pushViewController(vc, animated: true)
            case "Logout":
                print("select item: ",item)
                
                self?.tabBarController?.selectedIndex = 0

                self?.tabBarController?.tabBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                self?.tabBarController?.tabBar.unselectedItemTintColor = UIColor.white
                var myUser: [User]? {didSet {}}
                myUser = User.readUserFromArchive()
                myUser?.removeAll()
                self!.logoutUserApi()
                
            default:
                print("select item: ",item)
            }
        }
    }
    
    func blockUser(){
        AppUtility?.startLoader(view: self.view)
        let uid = UserDefaults.standard.string(forKey: "userID")
        let otherUid = UserDefaults.standard.string(forKey: "otherUserID")
        
        print("block uid: \(uid) blockUid: \(otherUid)")
        ApiHandler.sharedInstance.blockUser(user_id: uid!, block_user_id: otherUid!) { (isSuccess, response) in
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    AppUtility?.stopLoader(view: self.view)
                    self.showToast(message: "Blocked", font: .systemFont(ofSize: 12))
                    self.navigationController?.popToRootViewController(animated: true)
                    
                }else{
                    AppUtility?.stopLoader(view: self.view)
                    //                    self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                    print("blockUser API:",response?.value(forKey: "msg") as! String)
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
            AppUtility?.stopLoader(view: self.view)
        }
        
    }
    func logoutUserApi(){
        
        let userID = UserDefaults.standard.string(forKey: "userID")
        print("user id: ",userID as Any)
        AppUtility?.startLoader(view: view)
        ApiHandler.sharedInstance.logout(user_id: userID! ) { (isSuccess, response) in
            AppUtility?.stopLoader(view: self.view)
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    //  self.showToast(message: (response?.value(forKey: "msg") as? String)!, font: .systemFont(ofSize: 12))
                    print(response?.value(forKey: "msg") as Any)
                    UserDefaults.standard.set("", forKey: "userID")
                }else{
                    //                    self.showToast(message: (response?.value(forKey: "msg") as? String)!, font: .systemFont(ofSize: 12))
                    print("logout API:",response?.value(forKey: "msg") as! String)
                }
            }else{
                
                //                self.showToast(message: (response?.value(forKey: "msg") as? String)!, font: .systemFont(ofSize: 12))
                print("logout API:",response?.value(forKey: "msg") as Any)
            }
        }
    }
    
    //    MARK:- Report user func
    func reportUser(reportReason: String){
        AppUtility?.startLoader(view: self.view)
        
        print("report user id: \(otherUserID) userID: \(UserDefaults.standard.string(forKey: "userID")!)")
        
        ApiHandler.sharedInstance.reportUser(user_id: UserDefaults.standard.string(forKey: "userID")!, report_user_id: otherUserID, report_reason_id: "1", description: reportReason) { (isSuccess, response) in
            if isSuccess{
                AppUtility?.stopLoader(view: self.view)
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    self.showToast(message: "Report Under Review", font: .systemFont(ofSize: 12))
                }else{
                    AppUtility?.stopLoader(view: self.view)
                    //                    self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                    print("reportUser API:",response?.value(forKey: "msg") as Any)
                }
            }else{
                print("reportUser API:",response?.value(forKey: "msg") as Any)
                AppUtility?.stopLoader(view: self.view)
            }
        }
    }
    func alertModule(title:String,msg:String){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}
