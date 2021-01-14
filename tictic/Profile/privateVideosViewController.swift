//
//  privateVideosViewController.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 31/10/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class privateVideosViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var userID = ""
    var otherUserID = ""
    //MARK:- Outlets
    var arrImage = [["image":"v1"],["image":"v3"],["image":"v1"],["image":"v3"],["image":"v1"],["image":"v3"],["image":"v3"],["image":"v3"],["image":"v3"],["image":"v3"],["image":"v3"],["image":"v3"],["image":"v3"],["image":"v3"],["image":"v3"],["image":"v3"]]
    var videosArr = [videoMainMVC]()
    
    @IBOutlet weak var videoCollection: UICollectionView!
    @IBOutlet weak var whoopsView: UIView!
    @IBOutlet weak var btnFollow: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        self.setupView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /*
        let uid = UserDefaults.standard.string(forKey: "userID")
        
        if uid != "" && uid != nil{
            let otherUserID = UserDefaults.standard.string(forKey: "otherUserID")
            
            if(otherUserID != "" || otherUserID != nil){
                print("otheruserid: ",otherUserID!)
                self.userID = otherUserID!
                getVideos()
            }else{
                getVideos()
            }
        }else{
            showToast(message: "Login to continue..", font: .systemFont(ofSize: 12))
        }
        */
        
        let otherUid = UserDefaults.standard.string(forKey: "otherUserID")
        self.userID = UserDefaults.standard.string(forKey: "userID")!
        
        if otherUid != "" && otherUid != nil {
            self.otherUserID = otherUid!
            getVideos()
        }else{
            self.otherUserID = ""
            
            getVideos()
        }
        print("videosArr.count: ",videosArr.count)
    }
    
    //MARK:- SetupView
    
    func setupView(){
        
        let screenWidth = UIScreen.main.bounds.width
        
        // Do any additional setup after loading the view, typically from a nib.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        videoCollection!.collectionViewLayout = layout
    }
    
    //MARK:- Switch Action
    
    //MARK:- Button Action
    
    //MARK:- DELEGATE METHODS
    
    //MARK: TableView
    
    //MARK: CollectionView.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.videosArr.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "newProfileItemsCVC", for:indexPath) as! newProfileItemsCollectionViewCell
        
        let videoObj = videosArr[indexPath.row]
        cell.imgVideoTrimer.sd_setImage(with: URL(string:videoObj.videoGIF), placeholderImage: UIImage(named: "videoPlaceholder"))
        cell.lblViewerCount.text(videoObj.view)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.videoCollection.frame.size.width/3-1, height: 204)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "homeFeedVC") as! homeFeedViewController
        vc.userVideoArr = videosArr
        vc.indexAt = indexPath
        navigationController?.pushViewController(vc, animated: true)
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
    func getVideos(){
        
        //        AppUtility?.stopLoader(view: view)
        
        print("userID test: ",userID)
        self.videosArr.removeAll()
        
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
                        
                        self.videosArr.append(video)
                    }
                    
                }else{
                    AppUtility?.stopLoader(view: self.view)
                    //  self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                }
                
                if self.videosArr.isEmpty == true{
                    self.whoopsView.isHidden = false
                }else{
                    self.whoopsView.isHidden = true
                }
                self.videoCollection.reloadData()
                
            }else{
                AppUtility?.stopLoader(view: self.view)
//                self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                print("showVideosAgainstUserID API:",response?.value(forKey: "msg") as Any)
            }
        }
    }
}
