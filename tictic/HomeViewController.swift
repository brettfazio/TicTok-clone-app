//
//  HomeViewController.swift
//  TIK TIK
//
//  Created by Junaid Kamoka on 24/04/2019.
//  Copyright © 2019 Junaid Kamoka. All rights reserved.
//

import UIKit
import Alamofire
import AVKit
import DSGradientProgressView
import SDWebImage
import MarqueeLabel
import Photos


class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSourcePrefetching,UIGestureRecognizerDelegate{
    
    @IBOutlet weak var collectionview: UICollectionView!
    
    @IBOutlet weak var menu: UILabel!
    
    @IBOutlet weak var texe_view: UIView!
    
    
    @IBOutlet weak var tableview: UITableView!
    
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var observer:Any?
    
    @IBOutlet weak var out_view: UIView!
    
    @IBOutlet weak var btn_following: UIButton!
    
    @IBOutlet weak var btn_foryou: UIButton!
    
    
    @IBOutlet weak var txt_comment: UITextField!
    
    
    var index:Int! = 0
    var video_id:String! = "0"
    var video_type:String! = "for you"
    
    var avplayer:AVPlayer?
    
    
    
    var friends_array:NSMutableArray = []
    
    var comments_array:NSMutableArray = []
    
    var sound_array:NSMutableArray = []
    
    private var indexOfCellBeforeDragging = 0
    

    @IBOutlet weak var testView: UIView!
    
    var currentVideoUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionview.isPagingEnabled = true
        
        UserDefaults.standard.set("0", forKey: "sid")
        
        if(UserDefaults.standard.string(forKey: "uid") == nil){
        
        UserDefaults.standard.set("", forKey: "uid")
        }
        

        self.showAllVideos()
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.videoDidEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        
        
       
        let layout = UICollectionViewFlowLayout()
       // let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionview.showsVerticalScrollIndicator = false
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top:0, left: 0, bottom: 0, right: 0)
        self.collectionview.contentInset = UIEdgeInsets(top:-20, left: 0, bottom:0, right: 0)
        
        self.collectionview.collectionViewLayout = layout
        
        self.tableview.tableFooterView = UIView()
        
       // self.out_view.roundCorners([.topLeft, .topRight], radius: 10)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.keyboardWillShow), name: NSNotification.Name.UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.keyboardWillHide), name: NSNotification.Name.UIResponder.keyboardWillHideNotification, object: nil)
        
        self.menu.layer.masksToBounds = false
        self.menu.layer.cornerRadius = self.menu.frame.height/2
        self.menu.clipsToBounds = true
        
       // menu.layer.
  
    }
    
    @objc func videoDidEnd(notification: NSNotification) {
        
   
        let visiblePaths = self.collectionview.indexPathsForVisibleItems
        for i in visiblePaths  {
            let cell = collectionview.cellForItem(at: i) as? homecollCell
            cell!.player!.seek(to: CMTime.zero)
            cell!.player?.play()
            
        }
       
     
        
    }
    
    override var prefersStatusBarHidden: Bool {
      return true
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//         UIApplication.shared.isStatusBarHidden = true
//    }
//
//
//    override func viewWillDisappear(_ animated: Bool) {
//
//        UIApplication.shared.isStatusBarHidden = false
//
//        let visiblePaths = self.collectionview.indexPathsForVisibleItems
//        for i in visiblePaths  {
//            let cell = collectionview.cellForItem(at: i) as? homecollCell
//            cell!.player!.pause()
//
//            cell!.playBtn.setBackgroundImage(UIImage(named:"ic_play_icon"), for: .normal)
//            cell!.playBtn.isHidden = false
//
//
//
//        }
//    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.texe_view.frame.origin.y == 0 {
                self.texe_view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.texe_view.frame.origin.y != 0 {
            self.texe_view.frame.origin.y = 0
        }
    }
    
    // Show All Videos Api
    
    func showAllVideos(){
        
        if(UserDefaults.standard.string(forKey:"DeviceToken" ) == nil){
            UserDefaults.standard.set("NULL", forKey:"DeviceToken")
        }
    
        let url : String = self.appDelegate.baseUrl!+self.appDelegate.showAllVideos!
        
        let parameter :[String:Any]? = ["fb_id":UserDefaults.standard.string(forKey: "uid")!,"token":UserDefaults.standard.string(forKey:"DeviceToken")!,"type":self.video_type!]
        
        let headers: HTTPHeaders = [
            "api-key": "4444-3333-2222-1111"
            
        ]
        
        print(url)
        print(parameter!)
        
        AF.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:headers).validate().responseJSON(completionHandler: {
            
            respones in
            
            switch respones.result {
            case .success( let value):
               
                let json  = value
                
                self.friends_array = []
                self.sound_array = []
                
                print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! NSString
                if(code == "200"){
                    let myCountry = (dic["msg"] as? [[String:Any]])!
                    for Dict in myCountry {
                    
                        let myRestaurant = Dict as NSDictionary
                        
                        let count = myRestaurant["count"] as! NSDictionary
                        let Username = myRestaurant["user_info"] as! NSDictionary
                        let sound = myRestaurant["sound"] as! NSDictionary
                        let audio_patha = sound["audio_path"] as! NSDictionary
                        let audio_path:String! =   audio_patha["acc"] as? String
                        self.sound_array.add(audio_path!)
                        let like_count = count["like_count"] as? String
                        let video_comment_count = count["video_comment_count"] as? String
                        let sound_name = sound["sound_name"] as? String
                        let video_url:String! =   myRestaurant["video"] as? String
                        let u_id:String! =   myRestaurant["fb_id"] as? String
                        let v_id:String! =   myRestaurant["id"] as? String
                        let thum:String! =   myRestaurant["thum"] as? String
                        let first_name:String! =   Username["username"] as? String
                        let last_name:String! =   Username["last_name"] as? String
                        let profile_pic:String! =   Username["profile_pic"] as? String
                        let like:String! =   myRestaurant["liked"] as? String
                        let desc:String! =   myRestaurant["description"] as? String
                        
                        let obj = Home(like_count: like_count, video_comment_count: video_comment_count, sound_name: sound_name,thum: thum, first_name: first_name, last_name: last_name,profile_pic: profile_pic, video_url: video_url, v_id: v_id, u_id: u_id, like: like, desc: desc)
                     
                        
                        self.friends_array.add(obj) 
                        
                    }
                    
                DispatchQueue.main.async {
                   self.collectionview.delegate = self
                   self.collectionview.dataSource = self
                self.collectionview.prefetchDataSource = self
                   self.collectionview.reloadData()
                    }
                    
                    
                }else{
                    
                   
                    
                }
                
                
                
            case .failure(let error):
               print(error)
            }
        })
        
        
        
    }
    
    // Collection View Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.friends_array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:homecollCell = self.collectionview.dequeueReusableCell(withReuseIdentifier: "homecollCell", for: indexPath) as! homecollCell
        //cell.player?.pause()
     
        let obj = self.friends_array[indexPath.row] as! Home
       
        let url = URL.init(string: obj.video_url)
//        MARK:- JK
        self.currentVideoUrl = obj.video_url
        
        let screenSize: CGRect = UIScreen.main.bounds
        cell.playerItem = AVPlayerItem(url: url!)
        //cell.player!.replaceCurrentItem(with: cell.playerItem)
        cell.player = AVPlayer(playerItem: cell.playerItem!)
        cell.playerLayer = AVPlayerLayer(player: cell.player!)
        cell.playerLayer!.frame = CGRect(x:0,y:0,width:screenSize.width,height: screenSize.height)
        cell.playerLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cell.playerView.layer.addSublayer(cell.playerLayer!)
      
        cell.playerView.layer.backgroundColor = UIColor.black.cgColor
        cell.playBtn.tag = indexPath.item
         cell.btnshare.tag = indexPath.item
        cell.playBtn.addTarget(self, action: #selector(HomeViewController.connected(_:)), for:.touchUpInside)
        
        cell.btn_like.tag = indexPath.item
        cell.btn_like.addTarget(self, action: #selector(HomeViewController.connected2(_:)), for:.touchUpInside)
        
        cell.btn_comments.tag = indexPath.item
        cell.btn_comments.addTarget(self, action: #selector(HomeViewController.connected3(_:)), for:.touchUpInside)
        
        cell.btnshare.addTarget(self, action: #selector(HomeViewController.connected1(_:)), for:.touchUpInside)
   
        cell.other_profile.tag = indexPath.item
        cell.other_profile.addTarget(self, action: #selector(HomeViewController.connected4(_:)), for:.touchUpInside)
        cell.txt_desc.text = obj.desc
        
//        cell.btn_foryou.tag = indexPath.item
//         cell.btn_foryou.addTarget(self, action: #selector(HomeViewController.connected5(_:)), for:.touchUpInside)
//
//        cell.btn_following.tag = indexPath.item
//        cell.btn_following.addTarget(self, action: #selector(HomeViewController.connected6(_:)), for:.touchUpInside)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        cell.inner_view.addGestureRecognizer(tap)
        
        cell.inner_view.isUserInteractionEnabled = true
        
        cell.inner_view.tag = indexPath.item
        
//        if(self.video_type == "following"){
//
//            cell.btn_foryou.setTitleColor(UIColor.lightGray, for: .normal)
//            cell.btn_following.setTitleColor(UIColor.white, for: .normal)
//        }else{
//
//            cell.btn_foryou.setTitleColor(UIColor.white, for: .normal)
//           cell.btn_following.setTitleColor(UIColor.lightGray, for: .normal)
//        }
        
        
       
       // cell.user_view.layer.cornerRadius = 5.0
        //cell.user_view.clipsToBounds = true
        
        if(obj.first_name != nil || obj.last_name != nil){
        
        cell.user_name.text = obj.first_name
        }
        cell.user_name.textDropShadow()
        if(obj.profile_pic != nil){
        cell.user_img.sd_setImage(with: URL(string:obj.profile_pic), placeholderImage: UIImage(named: "nobody_m.1024x1024"))
        }
        cell.user_img.layer.masksToBounds = false
        cell.user_img.layer.cornerRadius = cell.user_img.frame.height/2
        cell.user_img.clipsToBounds = true
        
        if(obj.sound_name != nil){
            
            cell.music_name.text = obj.sound_name
            cell.music_name.type = .continuous
        }
        cell.btn_like.setTitle(obj.like_count, for: .normal)
        cell.btn_comments.setTitle(obj.video_comment_count, for: .normal)
        
       // cell.img.sd_setImage(with: URL(string:self.appDelegate.imgbaseUrl!+obj.thum), placeholderImage: UIImage(named: ""))
        
        if(obj.like == "0"){
            
            cell.btn_like.setBackgroundImage(UIImage(named:"ic_like"), for: .normal)
        }else{
            cell.btn_like.setBackgroundImage(UIImage(named:"ic_like_fill"), for: .normal)
        }
        
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
           
           longPressedGesture.delegate = self
           cell.addGestureRecognizer(longPressedGesture)
        
        //self.applyCurvedPath(givenView:cell.playerView,curvedPercent: 0.1)

        return cell
        
    }
    
    @objc func handleLongPress(gesture : UILongPressGestureRecognizer!) {
        
        let p = gesture.location(in: self.collectionview)

        if let indexPath : NSIndexPath = self.collectionview.indexPathForItem(at:p) as NSIndexPath?{
            //do whatever you need to do
        
        if (gesture.state == .began) {
            
            
             let actionSheet =  UIAlertController(title: nil, message:nil, preferredStyle: .actionSheet)
                   let camera = UIAlertAction(title: "Save Video", style: .default, handler: {
                       (_:UIAlertAction)in
                    
                    let url : String = self.appDelegate.baseUrl!+self.appDelegate.downloadFile!
                    
                    let obj = self.friends_array[indexPath.row] as! Home
                          
                    let  sv = HomeViewController.displaySpinner(onView: self.view)
                    let parameter :[String:Any]? = ["video_id":obj.v_id!]
                            
                            print(url)
                            //print(parameter!)
                            
                            let headers: HTTPHeaders = [
                                "api-key": "4444-3333-2222-1111"
                                
                            ]
                            
                            AF.request(url, method: .post, parameters:parameter, encoding:JSONEncoding.default, headers:headers).validate().responseJSON(completionHandler: {
                                
                                respones in
                                
                                
                                
                                switch respones.result {
                                case .success( let value):
                                    
                                    let json  = value
                                    
                                    
                                    
                                   // self.Follow_Array = []
                             print(json)
                                    let dic = json as! NSDictionary
                                    let code = dic["code"] as! NSString
                                    if(code == "200"){
                                        
                                      if let myCountry = dic["msg"] as? [[String:Any]]{
                                        
                                        for Dict in myCountry {
                                            if  let my_id =   Dict["download_url"] as? String{
                                               
                                                     let url = URL.init(string: my_id)
                                                let date = Date()
                                                let formatter = DateFormatter()
                                                formatter.dateFormat = "dd.MM.yyyy"
                                                let result = formatter.string(from: date)
                                             
                                                DispatchQueue.global(qos: .background).async {
                                                  if let url = URL(string: my_id), let urlData = NSData(contentsOf: url) {
                                                     let galleryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
                                                     let filePath = "\(galleryPath)/tictic.mp4"
                                                    DispatchQueue.main.async {
                                                        urlData.write(toFile: filePath, atomically: true)
                                                           PHPhotoLibrary.shared().performChanges({
                                                           PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL:
                                                           URL(fileURLWithPath: filePath))
                                                        }) {
                                                           success, error in
                                                           if success {
                                                            HomeViewController.removeSpinner(spinner: sv)
                                                              print("Succesfully Saved")
                                                           } else {
                                                            HomeViewController.removeSpinner(spinner: sv)
                                                            self.alertModule(title:"Error", msg: error!.localizedDescription)
                                                           }
                                                        }
                                                     }
                                                  }
                                               }
                                        }
                                        
                                    }
                            }
                                        
                                    }else{
                                        
                                        self.alertModule(title:"Error", msg:dic["msg"] as! String)
                                        
                                    }
                          
                                    
                                    
                                case .failure(let error):
                                    print(error)
                                    HomeViewController.removeSpinner(spinner: sv)
                                    self.alertModule(title:"Error",msg:error.localizedDescription)
                                }
                            })
                       
                       
                   })
            
                let camera1 = UIAlertAction(title: "Use Sound", style: .default, handler: {
                                 (_:UIAlertAction)in
                    
                    let obj = self.sound_array[indexPath.row] as! String
                    
                    if let audioUrl = URL(string:obj) {
                                   let  sv = HomeViewController.displaySpinner(onView: self.view)
                                   // then lets create your document folder url
                                   let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                                   
                                   // lets create your destination file url
                                   let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
                                   print(destinationUrl)
                                   
                                   // to check if it exists before downloading it
                                   if FileManager.default.fileExists(atPath: destinationUrl.path) {
                                       print("The file already exists at path")
                                       HomeViewController.removeSpinner(spinner: sv)
                                       // if the file doesn't exist
                                   } else {
                                       
                                       // you can use NSURLSession.sharedSession to download the data asynchronously
                                       URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) -> Void in
                                           guard let location = location, error == nil else { return }
                                           do {
                                               // after downloading your file you need to move it to your destination url
                                            HomeViewController.removeSpinner(spinner: sv)
                                               try FileManager.default.moveItem(at: location, to: destinationUrl)
                                               print("File moved to documents folder")
                                           } catch let error as NSError {
                                            HomeViewController.removeSpinner(spinner: sv)
                                               print(error.localizedDescription)
                                           }
                                       }).resume()
                                   }
                               }
                    
                    if(UserDefaults.standard.string(forKey: "uid") == ""){
                               
                               self.alertModule(title:"TIK TIK", msg: "Please login from profile to upload video!")
                               
                               
                           }else{
                               
                             
                               let vc = ActionViewContoller()
                               vc.modalPresentationStyle = .fullScreen
                               self.present(vc, animated: true, completion: nil)
                           }
                           
              
                   })
                   let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                       (_:UIAlertAction)in
                    
                    
                       
                   })
                   
                   actionSheet.addAction(camera)
                   actionSheet.addAction(camera1)
                   //actionSheet.addAction(Giphy)
                   actionSheet.addAction(cancel)
                 
                   self.present(actionSheet, animated: true, completion: nil)
        }
            
        }

        
    }
    
  
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let obj = friends_array[indexPath.item] as! Home
        if let comedyCell = cell as? homecollCell {

            index = indexPath.row
            
            
            comedyCell.playBtn.isHidden = true
            
            comedyCell.player?.play()
        
            comedyCell.player!.addObserver(self, forKeyPath:"timeControlStatus", options: [.old, .new], context: nil)
            
            print(obj.video_url!)
            
           // comedyCell.music_name = MarqueeLabel.init(frame: comedyCell.music_name.frame, duration: 8.0, fadeLength: 10.0)
            

//            let url : String = self.appDelegate.baseUrl!+self.appDelegate.updateVideoView!
//
//            let parameter :[String:Any]? = ["fb_id":UserDefaults.standard.string(forKey: "uid")!,"id":obj.v_id!]
//
//            print(url)
//            print(parameter!)
//
//            AF.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:nil).validate().responseJSON(completionHandler: {
//
//                respones in
//
//
//
//                switch respones.result {
//                case .success( let value):
//
//                    let json  = value
//
//                    print(json)
//                    let dic = json as! NSDictionary
//                    let code = dic["code"] as! NSString
//                    if(code == "200"){
//
//
//
//                    }
//
//
//
//
//                case .failure(let error):
//                    print(error)
//
//                }
//            })
//
        }

    }
    
 
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let visiblePaths = self.collectionview.indexPathsForVisibleItems
        for i in visiblePaths  {
            let cell = collectionview.cellForItem(at: i) as? homecollCell
        if keyPath == "timeControlStatus", let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
            let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
            let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
            if newStatus != oldStatus {
                DispatchQueue.main.async {[weak self] in
                    if newStatus == .playing || oldStatus == .paused  {
                        cell?.progressView.signal()
                        cell?.progressView.isHidden = true
                       
                    } else {
                        
                         cell?.progressView.wait()
                        cell?.progressView.isHidden = false
                        
                    }
                }
            }
        }
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let comedyCell = cell as? homecollCell {
            index = indexPath.row
            comedyCell.player?.pause()
        }
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        let screenSize: CGRect = UIScreen.main.bounds
        let screenSize: CGRect = view.frame
        let collectionSize:CGRect = collectionView.frame
        return CGSize(width: collectionSize.width, height: collectionSize.height)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]){
        
        for indexPath in indexPaths {
            /*
             Updating upcoming CollectionView's data source. Not assiging any direct value
             */
            
            let tempObj = self.friends_array[indexPath.row] as! Home
            self.friends_array[indexPath.row] = tempObj
           
        }
    }
    
    // indexPaths that previously were considered as candidates for pre-fetching, but were not actually used; may be a subset of the previous call to -collectionView:prefetchItemsAtIndexPaths:
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]){
      
        
        for indexPath in indexPaths {
            self.friends_array.remove(indexPath.row)
        }
    }
    
    
    
    @objc func connected1(_ sender : UIButton) {
        print(sender.tag)
        
        let buttonTag = sender.tag
        
        let obj = self.friends_array[buttonTag] as! Home
        
        let text = self.appDelegate.sharURl!+obj.v_id!
        
        // set up activity view controller
        let textToShare = [ text ]
//    MARK:- OLD
   /*
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook,UIActivity.ActivityType.saveToCameraRoll]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
       
        */
//        MARK:- JK SHARE
        let vc = storyboard?.instantiateViewController(withIdentifier: "shareVC") as! shareViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.objToShare = textToShare
        vc.currentVideoUrl = self.currentVideoUrl
        present(vc, animated: true, completion: nil)
        
        
    }
    
    @objc func connected(_ sender : UIButton) {
        print(sender.tag)
        
        let buttonTag = sender.tag
        
        let indexPath = IndexPath(row: buttonTag, section: 0)
        let cell = collectionview.cellForItem(at: indexPath) as! homecollCell
        if(cell.playBtn.backgroundImage(for: .normal) == UIImage(named: "ic_play_icon")){
            cell.playBtn.setBackgroundImage(UIImage(named:"ic_pause_icon"), for: .normal)
            cell.player?.play()
            cell.playBtn.isHidden = true
            
        }
        
    }
    
    @objc func connected3(_ sender : UIButton) {
        
        if(UserDefaults.standard.string(forKey: "uid") == ""){
            
             self.alertModule(title:"TIK TIK", msg: "Please login from profile to comment on video!")
            
        }else{
//        print(sender.tag)
//
//        self.out_view.alpha = 1
//
//        UIView.animate(withDuration: 0.5, animations: {
//            print(self.out_view.frame.origin.y)
//
//
//
//
//            self.out_view.frame = CGRect(x: 0, y:UIScreen.main.bounds.height-340 , width: self.view.frame.width, height: self.view.frame.height)

//
//        },  completion: { (finished: Bool) in
//
//        let buttonTag = sender.tag
//
//
//
//        let obj = self.friends_array[buttonTag] as! Home
//        self.video_id = obj.v_id
//
//            self.getComents()
//        })
                    let buttonTag = sender.tag
                    let obj = self.friends_array[buttonTag] as! Home
                    self.video_id = obj.v_id
            
            print("videoID: ",video_id)
            
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "commentsNewVC") as! commentsNewViewController
            vc.video_id = video_id!
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true, completion: nil)
        
        }
    }
    
    @objc func connected4(_ sender : UIButton) {
        print(sender.tag)
        
        let buttonTag = sender.tag
        let obj = self.friends_array[buttonTag] as! Home
     
        
        let actionSheet =  UIAlertController(title: nil, message:nil, preferredStyle: .actionSheet)
        let camera1 = UIAlertAction(title: "View Profile", style: .default, handler: {
                          (_:UIAlertAction)in
            
            
                 if(obj.u_id != UserDefaults.standard.string(forKey: "uid")!){
                 
                 StaticData.obj.other_id = obj.u_id
                     
                     let storyboard = UIStoryboard(name: "Main", bundle: nil)
                     let yourVC: Profile1ViewController = storyboard.instantiateViewController(withIdentifier: "Profile1ViewController") as! Profile1ViewController
                     
                    self.present(yourVC , animated: true, completion: nil)
                 }else{
                     
                     self.tabBarController?.selectedIndex = 3
                 }
            
                          
                      })
        let camera = UIAlertAction(title: "Report "+obj.first_name, style: .default, handler: {
                     (_:UIAlertAction)in
                     
                 })
                 
                 let gallery = UIAlertAction(title: "Block", style: .destructive, handler: {
                     (_:UIAlertAction)in
                     
                 })
                 
                 let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                     (_:UIAlertAction)in
                     
                 })
                actionSheet.addAction(camera1)
                 actionSheet.addAction(camera)
                 
                 actionSheet.addAction(gallery)
                 //actionSheet.addAction(Giphy)
                 actionSheet.addAction(cancel)
                 self.present(actionSheet, animated: true, completion: nil)
        
        
        
        
    }
    
    @objc func connected2(_ sender : UIButton) {
        print(sender.tag)
        
        var action:String! = ""
        
        
        if(UserDefaults.standard.string(forKey: "uid") == ""){
                  
                   self.alertModule(title:"TIK TIK", msg: "Please login from profile to like the video!")
                  
              }else{       
        let buttonTag = sender.tag
        let indexPath = IndexPath(row: buttonTag, section: 0)
        let cell = collectionview.cellForItem(at: indexPath) as! homecollCell
        let obj = self.friends_array[buttonTag] as! Home
        
        if(obj.like == "0"){
            
            action = "1"
            
            cell.btn_like.setBackgroundImage(UIImage(named:"ic_like"), for: .normal)
         
        }else{
            
          
            cell.btn_like.setBackgroundImage(UIImage(named:"ic_like_fill"), for: .normal)
            action = "0"
        }
        
        let url : String = self.appDelegate.baseUrl!+self.appDelegate.likeDislikeVideo!
        
        let parameter :[String:Any]? = ["fb_id":UserDefaults.standard.string(forKey: "uid")!,"video_id":obj.v_id!,"action":action!]
        
        print(url)
        print(parameter!)
            
            let headers: HTTPHeaders = [
                "api-key": "4444-3333-2222-1111"
                
            ]
        
        AF.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:headers).validate().responseJSON(completionHandler: {
            
            respones in
            
            switch respones.result {
            case .success( let value):
                
                let json  = value
               
                
                print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! NSString
                if(code == "200"){
             
                   obj.like = action
                   
                    
                    if(obj.like == "0"){
                        
                        
                        cell.btn_like.setBackgroundImage(UIImage(named:"ic_like"), for: .normal)
                        
                        if(Int(obj.like_count)! > 0){
                            
                            let str:Int! = Int(obj.like_count)!-1
                            obj.like_count = String(str)
                            
                            cell.btn_like.setTitle(obj.like_count, for: .normal)
                            
                        }
                        
                    }else{
                        
                        let str:Int! = Int(obj.like_count)!+1
                        obj.like_count = String(str)
                        
                        cell.btn_like.setTitle(obj.like_count, for: .normal)
                            cell.btn_like.setBackgroundImage(UIImage(named:"ic_like_fill"), for: .normal)
                    }
                    
                    
                }else{
                    
                    
                    
                }
                
                
                
            case .failure(let error):
                print(error)
            }
        })
        }
        
    }
    
//    @objc func connected5(_ sender : UIButton) {
//        
//        let buttonTag = sender.tag
//        let indexPath = IndexPath(row: buttonTag, section: 0)
//        let cell = collectionview.cellForItem(at: indexPath) as! homecollCell
//        cell.btn_following.setTitleColor(UIColor.lightGray, for: .normal)
//        cell.btn_foryou.setTitleColor(UIColor.white, for: .normal)
//        self.video_type = "for you"
//        self.showAllVideos()
//    }
//    
//    @objc func connected6(_ sender : UIButton) {
//          
//          let buttonTag = sender.tag
//          let indexPath = IndexPath(row: buttonTag, section: 0)
//          let cell = collectionview.cellForItem(at: indexPath) as! homecollCell
//          cell.btn_foryou.setTitleColor(UIColor.lightGray, for: .normal)
//          cell.btn_following.setTitleColor(UIColor.white, for: .normal)
//        self.video_type = "following"
//        
//        self.showAllVideos()
//          
//      }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
    
        
        let myview = sender.view
        let buttonTag = myview?.tag
        let indexPath = IndexPath(row: buttonTag!, section: 0)
        let cell = collectionview.cellForItem(at: indexPath) as! homecollCell
        if(cell.playBtn.backgroundImage(for: .normal) == UIImage(named: "ic_play_icon")){
  
            cell.playBtn.isHidden = true
            cell.playBtn.setBackgroundImage(UIImage(named:"ic_pause_icon"), for: .normal)
           
            cell.player?.play()
        }else{
            cell.playBtn.isHidden = false
            cell.playBtn.setBackgroundImage(UIImage(named:"ic_play_icon"), for: .normal)
            
            cell.player?.pause()
        }
    }
    
  
    
    
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//
//        let visiblePaths = self.collectionview.indexPathsForVisibleItems
//        for i in visiblePaths  {
//            let cell = collectionview.cellForItem(at: i) as? homecollCell
//
//            if keyPath == "timeControlStatus", let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
//                let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
//                let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
//                if newStatus != oldStatus {
//                    DispatchQueue.main.async {[weak self] in
//                        if newStatus == .playing || newStatus == .paused {
//
//                            cell?.progressView.signal()
//                            cell?.progressView.alpha = 0
//                        } else {
//                            cell?.progressView.alpha = 1
//                           cell?.progressView.wait()
//                        }
//                    }
//                }
//            }
//        }
//
//    }
    
   
    
    @IBAction func cross(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, animations: {
            print(self.out_view.frame.origin.y)
            
            self.out_view.frame = CGRect(x: 0, y:1000 , width: self.view.frame.width, height: self.view.frame.height)
            
            self.out_view.alpha = 0
            
            
            
        },  completion: nil)
        
       
    }
    
    // Get All comments Api
    
    func getComents() {
        
        
        let url : String = self.appDelegate.baseUrl!+self.appDelegate.showVideoComments!
        let  sv = HomeViewController.displaySpinner(onView: self.out_view)
        
        
        
        let parameter :[String:Any]? = ["video_id":self.video_id!]
        
        print(url)
        print(parameter!)
        
        let headers: HTTPHeaders = [
            "api-key": "4444-3333-2222-1111"
            
        ]
        
        AF.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:headers).validate().responseJSON(completionHandler: {
            
            respones in
            
            
            
            switch respones.result {
            case .success( let value):
                
                let json  = value
                
                HomeViewController.removeSpinner(spinner: sv)
                
                self.comments_array = []
                print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! NSString
                if(code == "200"){
                    let myCountry = (dic["msg"] as? [[String:Any]])!
                    for Dict in myCountry {
                        
                        let myRestaurant = Dict as NSDictionary
                        var comments:String! = ""
                        var v_id:String! = ""
                        var first_name:String! = ""
                        var last_name:String! = ""
                        var profile_pic:String! = ""
                        var c_time:String! = ""
                        if let comm =  myRestaurant["comments"] as? String{
                            
                            comments = comm
                        }
                        if let created =  myRestaurant["created"] as? String{
                                                                              
                                                                              c_time = created
                                                                          }
                        if let myID =  myRestaurant["video_id"] as? String{
                            
                            v_id = myID
                        }
                        if let u_info = myRestaurant["user_info"] as? NSDictionary{
                        if let myFirest =  u_info["first_name"] as? String{
                            
                            first_name = myFirest
                        }
                        if let myLast =  u_info["last_name"] as? String{
                            
                            last_name = myLast
                        }
                        if let myPic =  u_info["profile_pic"] as? String{
                            
                            profile_pic = myPic
                        }
                           
                        }
                      
                        
                        
                        let obj = Comment(comments: comments, first_name: first_name, last_name: last_name,profile_pic: profile_pic, v_id: v_id, c_time: c_time)
                        
                        self.comments_array.add(obj)
                        
                        
                        
                    }
                    
                    self.comments_array = NSMutableArray(array: self.comments_array.reversed())
                
                    
                    self.tableview.delegate = self
                    self.tableview.dataSource = self
                    self.tableview.reloadData()
                    if(self.comments_array.count > 0){
                    DispatchQueue.main.async {
                        let indexPath = IndexPath(row: self.comments_array.count-1, section: 0)
                        self.tableview.scrollToRow(at: indexPath, at: .bottom, animated: true)
                    }
                    }
                    
                }else{
                    
                    self.alertModule(title:"Error", msg:dic["msg"] as! String)
                    
                }
                
                
                
            case .failure(let error):
                print(error)
                HomeViewController.removeSpinner(spinner: sv)
                self.alertModule(title:"Error",msg:error.localizedDescription)
            }
        })
    }
    
    
    
    // Send Comment Api
    
    @IBAction func sendComment(_ sender: Any) {
        
       
        
        if(txt_comment.text != ""){
            
            
             let obj = friends_array[index] as! Home
            
            let url : String = self.appDelegate.baseUrl!+self.appDelegate.postComment!
            
             let  sv = HomeViewController.displaySpinner(onView: self.out_view)
            
            let parameter :[String:Any]? = ["fb_id":UserDefaults.standard.string(forKey: "uid")!,"video_id":self.video_id!,"comment":self.txt_comment.text!]
            
            print(url)
            print(parameter!)
            
            let headers: HTTPHeaders = [
                "api-key": "4444-3333-2222-1111"
                
            ]
            
            AF.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:headers).validate().responseJSON(completionHandler: {
                
                respones in
                
                switch respones.result {
                case .success( let value):
                    
                    let json  = value
                    HomeViewController.removeSpinner(spinner: sv)
                    
                    print(json)
                    let dic = json as! NSDictionary
                    let code = dic["code"] as! NSString
                    if(code == "200"){
                      self.txt_comment.text = ""
                        
//                        var str:Int! = Int(obj.video_comment_count)
//                        str = str+1
//                        obj.video_comment_count = String(str)
//                        cell.btn_comments.setTitle(obj.video_comment_count, for: .normal)
                        
                        self.getComents()
                        
                        
                        }else{
                       
                        self.alertModule(title:"Error", msg:dic["msg"] as! String)
                        
                    }
                    
                    
                    
                case .failure(let error):
                    print(error)
                    HomeViewController.removeSpinner(spinner: sv)
                    self.alertModule(title:"Error",msg:error.localizedDescription)
                }
            })
            
        }
        
        
    }
    
    // Tableview Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CommentTableViewCell = self.tableview.dequeueReusableCell(withIdentifier: "cell01", for: indexPath) as! CommentTableViewCell
        
        let obj = self.comments_array[indexPath.row] as! Comment
        
        cell.comment_title.text = obj.first_name+" "+obj.last_name
        
        cell.comment_name.text = obj.comments
        
        cell.comment_img.sd_setImage(with: URL(string:obj.profile_pic), placeholderImage: UIImage(named: "nobody_m.1024x1024"))
        
        
//        let date = Date()
//               let formatter = DateFormatter()
//               formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//               let result = formatter.string(from: date)
//        let str = self.timeCalculate(dateString:result , dateString1: obj.c_time)
//        print(str)
//        cell.comment_time.text = str
        
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67
    }
    
    func alertModule(title:String,msg:String){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    @IBAction func Following(_ sender: Any) {
        
                  btn_foryou.setTitleColor(UIColor.lightGray, for: .normal)
                  btn_following.setTitleColor(UIColor.white, for: .normal)
                self.video_type = "following"
        
        self.menu.alpha = 0
        
                self.showAllVideos()
        
    }
    
    @IBAction func Related(_ sender: Any) {
        
                btn_following.setTitleColor(UIColor.lightGray, for: .normal)
                btn_foryou.setTitleColor(UIColor.white, for: .normal)
                self.video_type = "for you"
                self.showAllVideos()
    }
    
    func timeCalculate(dateString:String,dateString1:String) -> String{
           
           let calendar = Calendar.current
           
           // Get input(date) from textfield
           
           let isoDate = dateString
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
           let date = dateFormatter.date(from:isoDate)!
           
           let isoDate1 = dateString1
           let dateFormatter1 = DateFormatter()
           dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
           let date1 = dateFormatter1.date(from:isoDate1)!
           
           let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
           let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date, to: date1);
           
           let seconds = "\(difference.second ?? 0)s"
           let minutes = "\(difference.minute ?? 0)m"
           let hours = "\(difference.hour ?? 0)h" + " " + minutes
           let days = "\(difference.day ?? 0)d" + " " + hours
           
           if let day = difference.day, day          > 0 { return days }
           if let hour = difference.hour, hour       > 0 { return hours }
           if let minute = difference.minute, minute > 0 { return minutes }
           if let second = difference.second, second > 0 { return seconds }
           return ""
           
       }
    func pathCurvedForView(givenView: UIView, curvedPercent:CGFloat) ->UIBezierPath
           {
               let arrowPath = UIBezierPath()
               arrowPath.move(to: CGPoint(x:0, y:0))
               arrowPath.addLine(to: CGPoint(x:givenView.bounds.size.width, y:0))
               arrowPath.addLine(to: CGPoint(x:givenView.bounds.size.width, y:givenView.bounds.size.height))
               arrowPath.addQuadCurve(to: CGPoint(x:0, y:givenView.bounds.size.height), controlPoint: CGPoint(x:givenView.bounds.size.width/2, y:givenView.bounds.size.height-givenView.bounds.size.height*curvedPercent))
               arrowPath.addLine(to: CGPoint(x:0, y:0))
               arrowPath.close()
               
               return arrowPath
           }

       func applyCurvedPath(givenView: UIView,curvedPercent:CGFloat) {
           guard curvedPercent <= 1 && curvedPercent >= 0 else{
               return
           }
           
           let shapeLayer = CAShapeLayer(layer: givenView.layer)
           shapeLayer.path = self.pathCurvedForView(givenView: givenView,curvedPercent: curvedPercent).cgPath
           shapeLayer.frame = givenView.bounds
           shapeLayer.masksToBounds = true
           givenView.layer.mask = shapeLayer
       }
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.isStatusBarHidden = true
        devicesChecks()
        collectionview.reloadData()
        
    }
        override func viewWillDisappear(_ animated: Bool) {
            
            UIApplication.shared.isStatusBarHidden = false
            

    //        let visiblePaths = self.collectionview.indexPathsForVisibleItems
    //        for i in visiblePaths  {
    //            let cell = collectionview.cellForItem(at: i) as? homecollCell
    //            cell!.player!.pause()
    //            cell!.playBtn.setBackgroundImage(UIImage(named:"ic_play_icon"), for: .normal)
    //            cell!.playBtn.isHidden = false
    //        }
            
    //        MARK:- jk satrt { to }
            

                    let visiblePaths = self.collectionview.indexPathsForVisibleItems
                    for i in visiblePaths  {
                        let cell = collectionview.cellForItem(at: i) as? homecollCell
                        cell!.player?.pause()
            
                        cell!.playBtn.setBackgroundImage(UIImage(named:"ic_play_icon"), for: .normal)
                        cell!.playBtn.isHidden = false
            
                        if cell!.player != nil{
                            cell!.player?.replaceCurrentItem(with: nil)
                            cell!.player = nil
                        }
                   }
          
            

            
             NotificationCenter.default.removeObserver(self)
        }
    
    //    MARK:- DEVICE CHECKS
    func devicesChecks(){
        if DeviceType.iPhoneWithHomeButton{
            
            print("view height ",view.frame.height)

            
                     let visiblePaths = self.collectionview.indexPathsForVisibleItems
                    for i in visiblePaths  {
                        let cell = collectionview.cellForItem(at: i) as? homecollCell
                        cell?.bottomConstraint?.constant = 500
                        
            }

        }
        
    
    }
    
//    MARK:- JK
    @IBAction func btnTest(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "shareVC") as! shareViewController
        
//        vc.modalPresentationStyle = UIModalPresentationStyle.custom
//        vc.transitioningDelegate = self as? UIViewControllerTransitioningDelegate

        present(vc, animated: true, completion: nil)
//        self.navigationController!.pushViewController(vc, animated: true)
    }

}
extension HomeViewController {
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView(frame: UIScreen.main.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            
            UIApplication.shared.keyWindow!.addSubview(spinnerView)
            UIApplication.shared.keyWindow!.bringSubviewToFront(spinnerView)
            onView.bringSubviewToFront(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
    
    
    
    
    
}
extension UILabel {
    func textDropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 1, height: 2)
    }
    
    static func createCustomLabel() -> UILabel {
        let label = UILabel()
        label.textDropShadow()
        return label
    }
    
   
}


//extension UIView {
//
//    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
//         let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//         let mask = CAShapeLayer()
//         mask.path = path.cgPath
//         self.layer.mask = mask
//    }
//
//}
