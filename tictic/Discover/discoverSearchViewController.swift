//
//  discoverSearchViewController.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 07/11/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit
import SDWebImage
import AVKit

class discoverSearchViewController: UIViewController,UISearchBarDelegate {
    
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    
    @IBOutlet weak var objectsCV: UICollectionView!
    @IBOutlet weak var videosCV: UICollectionView!
    
    @IBOutlet weak var hashTagTV: UITableView!
    @IBOutlet weak var soundsTV: UITableView!
    @IBOutlet weak var userTV: UITableView!
    
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var videosView: UIView!
    @IBOutlet weak var hashTagView: UIView!
    @IBOutlet weak var soundsView: UIView!
    
    @IBOutlet weak var userWhoopsView: UIView!
    @IBOutlet weak var videosWhoopsView: UIView!
    @IBOutlet weak var hashTagWhoopsView: UIView!
    @IBOutlet weak var soundsWhoopsView: UIView!
    
    var userDataArr = [userMVC]()
    var videosDataArr = [videoMainMVC]()
    var hashTagDataArr = [hashTagMVC]()
    var soundsDataArr = [soundsMVC]()
    
    var userStartingPoint = "0"
    var videoStartingPoint = "0"
    var hashtagStartingPoint = "0"
    var soundStartingPoint = "0"
    var uid = ""
    
    var searchTxt = "  "
    var objIndex = 0
    
    var audioPlayer: AVPlayer?
    var isPlaying = false
    
    var objArr = [["title":"Users","isSelected":"true"],["title":"Videos","isSelected":"false"],["title":"Sounds","isSelected":"false"],["title":"HashTags","isSelected":"false"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        delegateSetup()
        
        let userid = UserDefaults.standard.string(forKey: "userID")!
        
        if userid != nil && userid != ""{
            uid = userid
        }
        
        if let cancelButton = searchBarOutlet.value(forKey: "cancelButton") as? UIButton{
            cancelButton.isEnabled = true
        }
        
        hiddenViews()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async {
            self.searchBarOutlet.becomeFirstResponder()
        }
    }
    
    func hiddenViews(){
        objectsCV.isHidden = true
        userWhoopsView.isHidden =  true
        videosWhoopsView.isHidden =  true
        hashTagWhoopsView.isHidden =  true
        soundsWhoopsView.isHidden =  true
    }
    
    func delegateSetup(){
        userTV.delegate = self
        userTV.dataSource = self
        userTV.tableFooterView = UIView()
        
        hashTagTV.delegate = self
        hashTagTV.dataSource = self
        hashTagTV.tableFooterView = UIView()
        
        soundsTV.delegate = self
        soundsTV.dataSource = self
        soundsTV.tableFooterView = UIView()
        
        videosCV.delegate = self
        videosCV.dataSource = self
        
        searchBarOutlet.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText: ",searchText)
        var txt = searchText
        if searchText.count == 0{
            txt = "  "
        }
        //        getUserData(keyword: txt)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarSearchButtonClicked")
        dismissKeyboard()
        
        var txt = searchBar.text
        
        if txt!.isEmpty{
            txt = "  "
        }
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton{
            cancelButton.isEnabled = true
        }
        
        print("objIndex: ",objIndex)
        self.searchTxt = txt!
        self.objSelectedIndex(index: objIndex)
        
        self.objectsCV.isHidden = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
                print("searchBarCancelButtonClicked")
        //
        //        let transition = CATransition()
        //        transition.duration = 0.5
        //        transition.type = CATransitionType.fade
        //        transition.subtype = CATransitionSubtype.fromLeft
        //        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        //        view.window!.layer.add(transition, forKey: kCATransition)
        navigationController?.popViewController(animated: false)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("end editing search")
    }
    //    MARK:- GET USER DATA
    func getUserData(keyword:String,sp:String){
        userDataArr.removeAll()
        
        AppUtility?.startLoader(view: self.view)
        ApiHandler.sharedInstance.Search(user_id: uid, type: "user", keyword: keyword, starting_point: sp) { (isSuccess, response) in
            if isSuccess{
                
                print("response: ",response?.allValues)
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    let userObjMsg = response?.value(forKey: "msg") as! NSArray
                    
                    for userObject in userObjMsg{
                        let userObj = userObject as! NSDictionary
                        
                        let user = userObj.value(forKey: "User") as! NSDictionary
                        
                        let userID = (user.value(forKey: "id") as? String)!
                        let userImage = (user.value(forKey: "profile_pic") as? String)!
                        let userName = (user.value(forKey: "username") as? String)!
                        let followers = "\(user.value(forKey: "followers_count") ?? "")"
                        let followings = "\(user.value(forKey: "following_count") ?? "")"
                        let likesCount = "\(user.value(forKey: "likes_count") ?? "")"
                        let videoCount = "\(user.value(forKey: "video_count") ?? "")"
                        let firstName = (user.value(forKey: "first_name") as? String)!
                        let lastName = (user.value(forKey: "last_name") as? String)!
                        let gender = (user.value(forKey: "gender") as? String)!
                        let bio = (user.value(forKey: "bio") as? String)!
                        let dob = (user.value(forKey: "dob") as? String)!
                        let website = (user.value(forKey: "website") as? String)!
                        
                        let obj = userMVC(userID: userID, first_name: firstName, last_name: lastName, gender: gender, bio: bio, website: website, dob: dob, social_id: "", userEmail: "", userPhone: "", password: "", userProfile_pic: userImage, role: "", username: userName, social: "", device_token: "", videoCount: videoCount, likesCount: likesCount, followers: followers, following: followings, followBtn: "")
                        
                        self.userDataArr.append(obj)
                    }
                    
                }
                
                AppUtility?.stopLoader(view: self.view)
                if self.userDataArr.isEmpty{
                    self.userWhoopsView.isHidden = false
                }else{
                    self.userWhoopsView.isHidden = true
                }
                self.userTV.reloadData()
            }
        }
    }
    
    
    //    MARK:- GET VIDEOS DATA
    func getVideosData(keyword:String,sp:String){
        videosDataArr.removeAll()
        AppUtility?.startLoader(view: self.view)
        ApiHandler.sharedInstance.Search(user_id: uid, type: "video", keyword: keyword, starting_point: sp) { (isSuccess, response) in
            if isSuccess{
                
                print("response: ",response?.allValues)
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    let vidObjMsg = response?.value(forKey: "msg") as! NSArray
                    
                    for vidObject in vidObjMsg{
                        let vidObj = vidObject as! NSDictionary
                        
                        let videoObj = vidObj.value(forKey: "Video") as! NSDictionary
                        let userObj = vidObj.value(forKey: "User") as! NSDictionary
                        let soundObj = vidObj.value(forKey: "Sound") as! NSDictionary
                        
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
                        
                        let video = videoMainMVC(videoID: videoID, videoUserID: "", fb_id: "", description: videoDesc, videoURL: videoUrl, videoTHUM: videoThum, videoGIF: videoGif, view: views, section: "", sound_id: "\(soundID ?? "")", privacy_type: "", allow_comments: allowComment, allow_duet: allowDuet, block: "", duet_video_id: "", old_video_id: "", created: created, like: like, favourite: "", comment_count: videoComments, like_count: videoLikes, followBtn: "", duetVideoID: "\(duetVidID!)", userID: userID, first_name: "", last_name: "", gender: "", bio: "", website: "", dob: "", social_id: "", userEmail: "", userPhone: "", password: "", userProfile_pic: userImg, role: "", username: username, social: "", device_token: "", videoCount: "", verified: "\(verified ?? "")", soundName: "\(soundName ?? "")")
                        
                        self.videosDataArr.append(video)
                    }
                    
                }
                
                AppUtility?.stopLoader(view: self.view)
                print("videoDataArr: ",self.videosDataArr)
                if self.videosDataArr.isEmpty{
                    self.videosWhoopsView.isHidden = false
                }else{
                    self.videosWhoopsView.isHidden = true
                }
                self.videosCV.reloadData()
            }
        }
    }
    
    //    MARK:- GET SOUNDS DATA
    func getSoundsData(keyword:String,sp:String){
        soundsDataArr.removeAll()
        AppUtility?.startLoader(view: self.view)
        ApiHandler.sharedInstance.Search(user_id: uid, type: "sound", keyword: keyword, starting_point: sp) { (isSuccess, response) in
            if isSuccess{
                
                print("response: ",response?.allValues)
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    let sndObjMsg = response?.value(forKey: "msg") as! NSArray
                    
                    for sndObject in sndObjMsg{
                        let sndObj = sndObject as! NSDictionary
                        
                        let soundObj = sndObj.value(forKey: "Sound") as! NSDictionary
                        
                        let id = soundObj.value(forKey: "id") as! String
                        let audioUrl = soundObj.value(forKey: "audio") as! String
                        let duration = soundObj.value(forKey: "duration") as! String
                        let name = soundObj.value(forKey: "name") as! String
                        let description = soundObj.value(forKey: "description") as! String
                        let thum = soundObj.value(forKey: "thum") as! String
                        let section = soundObj.value(forKey: "section") as! String
                        let uploaded_by = soundObj.value(forKey: "uploaded_by") as! String
                        let created = soundObj.value(forKey: "created") as! String
                        let favourite = soundObj.value(forKey: "favourite")
                        let publish = soundObj.value(forKey: "publish") as! String
                        
                        let obj = soundsMVC(id: id, audioURL: audioUrl, duration: duration, name: name, description: description, thum: thum, section: section, uploaded_by: uploaded_by, created: created, favourite: "\(favourite!)", publish: publish)
                        
                        self.soundsDataArr.append(obj)
                    }
                    
                }
                AppUtility?.stopLoader(view: self.view)
                print("videoDataArr: ",self.soundsDataArr)
                if self.soundsDataArr.isEmpty{
                    self.soundsWhoopsView.isHidden = false
                }else{
                    self.soundsWhoopsView.isHidden = true
                }
                self.soundsTV.reloadData()
            }
        }
    }
    
    //    MARK:- GET HASHTAGS DATA
    func getHashtagsData(keyword:String,sp:String){
        hashTagDataArr.removeAll()
        AppUtility?.startLoader(view: self.view)
        ApiHandler.sharedInstance.Search(user_id: uid, type: "hashtag", keyword: keyword, starting_point: sp) { (isSuccess, response) in
            if isSuccess{
                
                print("response: ",response?.allValues)
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    let hashObjMsg = response?.value(forKey: "msg") as! NSArray
                    
                    for hashObject in hashObjMsg{
                        let hashObj = hashObject as! NSDictionary
                        
                        let hashtag = hashObj.value(forKey: "Hashtag") as! NSDictionary
                        
                        let id = hashtag.value(forKey: "id") as! String
                        let name = hashtag.value(forKey: "name") as! String
                        let views = hashtag.value(forKey: "views") as? NSNumber
                        let favourite = hashtag.value(forKey: "favourite") as? NSNumber
                        
                        let obj = hashTagMVC(id: id, name: name, views: "\(views ?? 0)", favourite: "\(favourite ?? 0)")
                        
                        self.hashTagDataArr.append(obj)
                    }
                    
                }
                AppUtility?.stopLoader(view: self.view)
                print("hashTagDataArr: ",self.hashTagDataArr)
                if self.hashTagDataArr.isEmpty{
                    self.hashTagWhoopsView.isHidden = false
                }else{
                    self.hashTagWhoopsView.isHidden = true
                }
                self.hashTagTV.reloadData()
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
    //    MARK:- PLAY AUDIO SETUP
    func playSound(soundUrl: String,ip:IndexPath) {
        let cell = soundsTV.cellForRow(at: ip) as! searchSoundTableViewCell

        if isPlaying == true{
            self.isPlaying = false
            cell.selectBtn.isHidden = true
            cell.favBtn.isHidden = true
            cell.btnPlay.image = UIImage(named: "ic_play_icon")
            
            self.audioPlayer?.pause()
        }else{
            cell.btnPlay.isHidden = true
            DispatchQueue.main.async {
                cell.loadIndicator.startAnimating()
            }
            
            guard  let url = URL(string: soundUrl)
                else
            {
                print("error to get the mp3 file")
                return
            }
            do{
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
                audioPlayer = try AVPlayer(url: url as URL)
                guard let player = audioPlayer
                    else
                {
                    return
                }

                player.play()
                
                
                DispatchQueue.main.async {
                    cell.loadIndicator.stopAnimating()
                }
                print("player.reasonForWaitingToPlay: ",player.reasonForWaitingToPlay)
                
                self.isPlaying = true
                cell.selectBtn.isHidden = false
                cell.favBtn.isHidden = false
                cell.btnPlay.isHidden = false
                cell.btnPlay.image = UIImage(named: "ic_pause_icon")
                print("progress: ",player.playProgress)
            } catch let error {
                self.isPlaying = false
                print(error.localizedDescription)
            }
        }


    }

}

//MARK:- TABLE VIEWS SETUPS
extension discoverSearchViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == userTV{
            return userDataArr.count
        }else if tableView == soundsTV{
            return soundsDataArr.count
        }else{
            return hashTagDataArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == userTV{
            let userCell = tableView.dequeueReusableCell(withIdentifier: "searchUsersTVC") as! searchUsersTableViewCell
            let userObj = userDataArr[indexPath.row]
            
            let profilePic = AppUtility?.detectURL(ipString: userObj.userProfile_pic)
            let userImg = URL(string: profilePic!)
            
            userCell.userImg.sd_imageIndicator = SDWebImageActivityIndicator.gray
            userCell.userImg.sd_setImage(with: userImg, placeholderImage: UIImage(named: "noUserImg"))
            userCell.userName.text = userObj.username
            userCell.desc.text = userObj.first_name+" "+userObj.last_name
            userCell.userDetails.text = "\(userObj.followers) Followers \(userObj.videoCount) Videos"
            
            return userCell
        }
        else if tableView == hashTagTV
        {
            let hashCell = tableView.dequeueReusableCell(withIdentifier: "searchHashtagsTVC") as! searchHashtagsTableViewCell
            
            let hashObj = hashTagDataArr[indexPath.row]
            
            hashCell.titleLbl.text = hashObj.name
            hashCell.countLbl.text = hashObj.views
            
            if hashObj.favourite == "1"{
                hashCell.btnFav.setImage(UIImage(named: "btnFavFilled"), for: .normal)
            }else{
                hashCell.btnFav.setImage(UIImage(named:"btnFavEmpty"), for: .normal)
            }
            
            return hashCell
        }
        else
        {
            let soundCell = tableView.dequeueReusableCell(withIdentifier: "searchSoundTVC") as! searchSoundTableViewCell
            
            let obj = soundsDataArr[indexPath.row]
            let sndImg = AppUtility?.detectURL(ipString: obj.thum)
            
            soundCell.soundImg.sd_imageIndicator = SDWebImageActivityIndicator.gray
            soundCell.soundImg.sd_setImage(with: URL(string:sndImg!), placeholderImage: UIImage(named: "noMusicIcon"))
            
            soundCell.titleLbl.text = obj.name
            soundCell.descLbl.text = obj.description
            soundCell.durationLbl.text = obj.duration
            
            if obj.favourite == "1"{
                soundCell.favBtn.setImage(UIImage(named: "btnFavFilled"), for: .normal)
            }else{
                soundCell.favBtn.setImage(UIImage(named:"btnFavEmpty"), for: .normal)
            }
            
            soundCell.favBtn.addTarget(self, action: #selector(discoverSearchViewController.btnSoundFavAction(_:)), for:.touchUpInside)
            soundCell.selectBtn.addTarget(self, action: #selector(discoverSearchViewController.btnSelectAction(_:)), for:.touchUpInside)
            
            soundCell.selectBtn.isHidden = true
            soundCell.favBtn.isHidden = true
            soundCell.btnPlay.isHidden = false
            soundCell.btnPlay.image = UIImage(named: "ic_play_icon")
            
            return soundCell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == soundsTV{
            return 80
        }else if tableView == hashTagTV{
            return 50
        }else{
            return 80
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == userTV{
            let obj = userDataArr[indexPath.row]
            print("obj user id : ",obj.userID)
            
            let otherUserID = obj.userID
            let userID = UserDefaults.standard.string(forKey: "userID")
            
            if userID == nil || userID == ""{
                loginScreenAppear()
            }else{
                let vc = storyboard?.instantiateViewController(withIdentifier: "newProfileVC") as!  newProfileViewController
                vc.isOtherUserVisting = true
                vc.hidesBottomBarWhenPushed = true
                vc.otherUserID = otherUserID
                navigationController?.pushViewController(vc, animated: true)
            }
            
        }else if tableView == soundsTV{

            let obj = soundsDataArr[indexPath.row]
            playSound(soundUrl: (AppUtility?.detectURL(ipString: obj.audioURL))!,ip: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! searchSoundTableViewCell
        self.isPlaying = false
        cell.selectBtn.isHidden = true
        cell.favBtn.isHidden = true
        cell.btnPlay.image = UIImage(named: "ic_play_icon")
        audioPlayer?.pause()
    }
    
//    MAEK:- Btn fav sound Action
    @objc func btnSoundFavAction(_ sender : UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.soundsTV)
        let indexPath = self.soundsTV.indexPathForRow(at:buttonPosition)
        let cell = self.soundsTV.cellForRow(at: indexPath!) as! searchSoundTableViewCell
        
        let btnFavImg = cell.favBtn.currentImage
        
        if btnFavImg == UIImage(named: "btnFavEmpty"){
            cell.favBtn.setImage(UIImage(named: "btnFavFilled"), for: .normal)
        }else{
            cell.favBtn.setImage(UIImage(named: "btnFavEmpty"), for: .normal)
        }
        
        let obj = soundsDataArr[indexPath!.row]
        
        addFavSong(soundID: obj.id, btnFav: cell.favBtn)
    }
    
//    MARK:- SELECT SOUND ACTION
    @objc func btnSelectAction(_ sender : UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.soundsTV)
        let indexPath = self.soundsTV.indexPathForRow(at:buttonPosition)
        let obj = soundsDataArr[indexPath!.row]
        
        let uid = UserDefaults.standard.string(forKey: "userID")
        
        if uid == "" || uid == nil{
            loginScreenAppear()
        }else{
//            saveSondToLocal(soundObj: obj)
        }
        
    }
    
//    MARK:- SAVE SOUND TO LOCAL FUNC
    func saveSondToLocal(soundObj:soundsMVC){

        AppUtility?.startLoader(view: self.view)
        
        UserDefaults.standard.set(soundObj.audioURL, forKey: "url")
        UserDefaults.standard.set(soundObj.name, forKey: "selectedSongName")
        
        print("obj.audio_path:- ",soundObj.audioURL)
        
        //            UserDefaults.standard.set(obj.uid, forKey: "sid")
        
        if let audioUrl = URL(string: (AppUtility?.detectURL(ipString: soundObj.audioURL))!) {
            
            // then lets create your document folder url
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            print(destinationUrl)
            
            // to check if it exists before downloading it
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                print("The file already exists at path")
                //                    self.goBack()
                DispatchQueue.main.async {
                    //                        self.loaderView.stopAnimating()
                    //                        HomeViewController.removeSpinner(spinner: sv)
                    AppUtility?.stopLoader(view: self.view)
                    NotificationCenter.default.post(name: Notification.Name("loadAudio"), object: ["soundName":soundObj.name])
                    self.appearActionMainScreen()
                }
                
                // if the file doesn't exist
            } else {
                
                // you can use NSURLSession.sharedSession to download the data asynchronously
                URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) -> Void in
                    guard let location = location, error == nil else { return }
                    do {
                        // after downloading your file you need to move it to your destination url
                        try FileManager.default.moveItem(at: location, to: destinationUrl)
                        print("File moved to documents folder @ loc: ",location)
                        DispatchQueue.main.async {
                            //                                self.loaderView.stopAnimating()
                            //                                HomeViewController.removeSpinner(spinner: sv)
                            AppUtility?.stopLoader(view: self.view)
                            
                            NotificationCenter.default.post(name: Notification.Name("loadAudio"), object: ["soundName":soundObj.name])
                            self.appearActionMainScreen()
                        }
                        
                        
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                    
                    //                        self.loaderView.removeFromSuperview()
                    
                    DispatchQueue.main.async { // Correct
                       AppUtility?.stopLoader(view: self.view)
                    }
                }).resume()
            }
        }
        
    }
//    MARK:- APPEAR ACTION MAIN SCREEN
    
    func appearActionMainScreen(){
        
//        if isPlaying == true{
//            isPlaying = false
//            audioPlayer?.pause()
//        }
        let vc1 = storyboard?.instantiateViewController(withIdentifier: "actionMediaVC") as! actionMediaViewController
        UserDefaults.standard.set("", forKey: "url")
        vc1.modalPresentationStyle = .fullScreen
        self.present(vc1, animated: true, completion: nil)
    }
    
    
//    MARK:- ADD FAV SOUND FUNC
    func addFavSong(soundID:String,btnFav:UIButton){
        AppUtility?.startLoader(view: self.soundsView)
        ApiHandler.sharedInstance.addSoundFavourite(user_id: UserDefaults.standard.string(forKey: "userID")!, sound_id: soundID) { (isSuccess, response) in
            if isSuccess{
                AppUtility?.stopLoader(view: self.soundsView)
                if response?.value(forKey: "code") as! NSNumber == 200{
                    print("msg: ",response?.value(forKey: "msg")!)
                    
                    if btnFav.currentImage == UIImage(named: "btnFavEmpty"){
                        self.showToast(message: "Removed From Favorite", font: .systemFont(ofSize: 12))
                    }else{
                        self.showToast(message: "Added to Favorite", font: .systemFont(ofSize: 12))
                    }
                    
                }else{
                    AppUtility?.stopLoader(view: self.soundsView)
                    self.showToast(message: "!200", font: .systemFont(ofSize: 12))
                }
            }
        }
    }
    
}

//MARK:- COLLECTION VIEWS SETUPS
extension discoverSearchViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == objectsCV{
            return objArr.count
        }else if collectionView == videosCV{
            return videosDataArr.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == videosCV{
            let vidCell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchVideosCVC", for: indexPath) as! searchVideosCollectionViewCell
            
            let vidObj = videosDataArr[indexPath.row]
//            let vidImg = baseUrl+vidObj.userProfile_pic
            
            let userImg = AppUtility?.detectURL(ipString: vidObj.userProfile_pic)
            
            vidCell.vidImg.sd_imageIndicator = SDWebImageActivityIndicator.gray
            vidCell.vidImg.sd_setImage(with: URL(string: (AppUtility?.detectURL(ipString: vidObj.videoGIF))!), placeholderImage: UIImage(named: "videoPlaceholder"))
            
//            let gifURL : String = (AppUtility?.detectURL(ipString: vidObj.videoGIF))!
//            let imageURL = UIImage.gifImageWithURL(gifURL)
//            vidCell.vidImg.image = imageURL
            
            vidCell.userImg.sd_imageIndicator = SDWebImageActivityIndicator.gray
            vidCell.userImg.sd_setImage(with: URL(string: userImg!), placeholderImage: UIImage(named: "noUserImg"))
            
            vidCell.usernameLbl.text = vidObj.username
            vidCell.nameLbl.text = vidObj.first_name+" "+vidObj.last_name
            vidCell.likeCountLbl.text = vidObj.like_count
            vidCell.descLbl.text = vidObj.description
            
            return vidCell
        }
        
        //
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "objectsCVC", for: indexPath) as! objectsCollectionViewCell
        
        cell.titleLbl.text = objArr[indexPath.row]["title"]
        
        if indexPath.row == 0 {
            if self.objArr[indexPath.row]["isSelected"] == "false"{
                cell.bottomLineView.isHidden  = true
                cell.titleLbl.text = objArr[indexPath.row]["title"]
                cell.titleLbl.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            }else{
                cell.bottomLineView.isHidden  = false
                cell.titleLbl.text = objArr[indexPath.row]["title"]
                cell.titleLbl.textColor = #colorLiteral(red: 0.9568627451, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
            }
        }
        if indexPath.row == 1 {
            if self.objArr[indexPath.row]["isSelected"] == "false"{
                cell.bottomLineView.isHidden  = true
                cell.titleLbl.text = objArr[indexPath.row]["title"]
                cell.titleLbl.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            }else{
                cell.bottomLineView.isHidden  = false
                cell.titleLbl.text = objArr[indexPath.row]["title"]
                cell.titleLbl.textColor = #colorLiteral(red: 0.9568627451, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
            }
        }
        if indexPath.row == 2{
            if self.objArr[indexPath.row]["isSelected"] == "false"{
                cell.bottomLineView.isHidden  = true
                cell.titleLbl.text = objArr[indexPath.row]["title"]
                cell.titleLbl.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            }else{
                cell.bottomLineView.isHidden  = false
                cell.titleLbl.text = objArr[indexPath.row]["title"]
                cell.titleLbl.textColor = #colorLiteral(red: 0.9568627451, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
            }
        }
        if indexPath.row == 3{
            if self.objArr[indexPath.row]["isSelected"] == "false"{
                cell.bottomLineView.isHidden  = true
                cell.titleLbl.text = objArr[indexPath.row]["title"]
                cell.titleLbl.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            }else{
                cell.bottomLineView.isHidden  = false
                cell.titleLbl.text = objArr[indexPath.row]["title"]
                cell.titleLbl.textColor = #colorLiteral(red: 0.9568627451, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
            }
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == objectsCV{
            for i in 0..<self.objArr.count {
                var obj  = self.objArr[i]
                obj.updateValue("false", forKey: "isSelected")
                self.objArr.remove(at: i)
                self.objArr.insert(obj, at: i)
                
            }
            
            self.objSelectedIndex(index: indexPath.row)
            self.objIndex = indexPath.row
        }else if collectionView == videosCV{
            if #available(iOS 13.0, *) {
                let vc = storyboard?.instantiateViewController(withIdentifier: "homeFeedVC") as! homeFeedViewController
                vc.userVideoArr = videosDataArr
                vc.indexAt = indexPath
                vc.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc, animated: true)
            } else {
                // Fallback on earlier versions
            }
            
        }
        
        
    }
    
    @objc func objSelectedIndex(index:Int){
        var obj  =  self.objArr[index]
        obj.updateValue("true", forKey: "isSelected")
        self.objArr.remove(at: index)
        self.objArr.insert(obj, at: index)
        
        if index == 0{
            userView.isHidden = false
            
            videosView.isHidden = true
            hashTagView.isHidden = true
            soundsView.isHidden = true
            
            getUserData(keyword: searchTxt, sp: userStartingPoint)
            
            if isPlaying == true{
                audioPlayer?.pause()
                self.isPlaying = false
            }
            
        }
        else if index == 1
        {
            videosView.isHidden = false
            
            
            userView.isHidden = true
            hashTagView.isHidden = true
            soundsView.isHidden = true
            
            getVideosData(keyword: searchTxt, sp: videoStartingPoint)
            
            if isPlaying == true{
                audioPlayer?.pause()
                self.isPlaying = false
            }
        }
        else if index == 2
        {
            soundsView.isHidden = false
            
            userView.isHidden = true
            hashTagView.isHidden = true
            videosView.isHidden = true
            
            getSoundsData(keyword: searchTxt, sp: soundStartingPoint)

        }
        else
        {
            hashTagView.isHidden = false
            
            userView.isHidden = true
            soundsView.isHidden = true
            videosView.isHidden = true
            
            getHashtagsData(keyword: searchTxt, sp: soundStartingPoint)
            
            if isPlaying == true{
                audioPlayer?.pause()
                self.isPlaying = false
            }
        }
        self.objectsCV.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if collectionView == self.videosCV{
            let noOfCellsInRow = 2
            
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            
            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
            
            let size = Int((objectsCV.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
            
            return CGSize(width: size, height: 300)
        }else{
            let noOfCellsInRow = objArr.count
            
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            
            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
            
            let size = Int((objectsCV.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
            
            return CGSize(width: size, height: 28)
            
        }
    }
    
    
}
