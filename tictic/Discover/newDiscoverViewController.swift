//
//  newDiscoverViewController.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 26/10/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class newDiscoverViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegateFlowLayout {
    
    
    //MARK:- Outlets
    @IBOutlet weak var scrollViewOutlet: UIScrollView!
    @IBOutlet weak var discoverBannerCollectionView: UICollectionView!
    @IBOutlet weak var discoverTblView: UITableView!
    
    @IBOutlet var tblheight: NSLayoutConstraint!
    @IBOutlet weak var bannerPageController: UIPageControl!
    
    
    var hashtagDataArr = [[String:Any]]()
    
    var sliderArr = [sliderMVC]()
    //    var videosArr = [videoMainMVC]()
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSliderData()
        getVideosData()
        self.setupView()
        
        AppUtility?.startLoader(view: self.view)
    }
    
    @objc
    func requestData() {
        print("requesting data")
        
        self.hashtagDataArr.removeAll()
        self.sliderArr.removeAll()
        getVideosData()
        getSliderData()
        let deadline = DispatchTime.now() + .milliseconds(700)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.refresher.endRefreshing()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 10.0, *) {
            scrollViewOutlet.refreshControl = refresher
        } else {
            scrollViewOutlet.addSubview(refresher)
        }

    }
    
    //MARK:- SetupView
    
    func setupView(){
        tblheight.constant = CGFloat(hashtagDataArr.count * 190)
    }
    
    //MARK:- Switch Action
    
    //MARK:- Button Action
    
    //MARK:- DELEGATE METHODS
    
    //MARK: TableView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.bannerPageController.currentPage = Int(self.discoverBannerCollectionView.contentOffset.x) / Int(self.discoverBannerCollectionView.frame.width)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("hashtagDataArr.count: ",hashtagDataArr.count)
        return hashtagDataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("hashtagNamesArr.count: ",hashtagDataArr.count)
        let cell =  tableView.dequeueReusableCell(withIdentifier: "newDiscoverTVC") as! newDiscoverTableViewCell
        
        cell.discoverCollectionView.reloadData()
        let hashObj = hashtagDataArr[indexPath.row]
        let hashName = hashObj["hashName"] as! String
        cell.hashName.text = hashName
        cell.hashNameSub.text = "Trending Hashtags"
        
        cell.videosObj = hashObj["videosObj"] as! [videoMainMVC]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
    //MARK: CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sliderArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "newDiscoverBannerCVC", for: indexPath) as! newDiscoverBannerCollectionViewCell
        
        let obj = sliderArr[indexPath.row]
        let sliderUrl = AppUtility?.detectURL(ipString: obj.img)
        print("sliderUrl: ",sliderUrl)
        cell.img.sd_setImage(with: URL(string:sliderUrl!), placeholderImage: UIImage(named:"bannerPlaceholder"))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.discoverBannerCollectionView.frame.size.width, height: 192)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("hashtagNamesArr.coun: ",hashtagDataArr[indexPath.row])
        
        if collectionView == discoverBannerCollectionView{
            let obj = sliderArr[indexPath.row]
            let sliderUrl = obj.url
            guard let url = URL(string: sliderUrl) else { return }
            UIApplication.shared.open(url)
        }
        
    }
    
//    MARK:- SEARCH BTN ACTION
    
    @IBAction func searchBtnAction(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "discoverSearchVC") as! discoverSearchViewController
//        let transition = CATransition()
//        transition.duration = 0.5
//        transition.type = CATransitionType.fade
//        transition.subtype = CATransitionSubtype.fromLeft
//        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
//        view.window!.layer.add(transition, forKey: kCATransition)
        vc.modalPresentationStyle = .overFullScreen
//        present(vc, animated: false, completion: nil)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: false)
//        present(vc, animated: false, completion: nil)
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
    
    
    
    //    MARK:- VIDEOS DATA API
    func getSliderData(){
        
        sliderArr.removeAll()
        ApiHandler.sharedInstance.showAppSlider{ (isSuccess, response) in
            if isSuccess{
                print("response: ",response?.allValues)
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    
                    let sliderDataArr = response?.value(forKey: "msg") as! NSArray
                    
                    for i in 0..<sliderDataArr.count{
                        let sliderObj = sliderDataArr[i] as! NSDictionary
                        let appSlider = sliderObj.value(forKey: "AppSlider") as! NSDictionary
                        
                        let id = appSlider.value(forKey: "id") as! String
                        let img = appSlider.value(forKey: "image") as! String
                        let url = appSlider.value(forKey: "url") as! String
                        
                        let obj = sliderMVC(id: id, img: img, url: url)
                        
                        self.sliderArr.append(obj)
                    }
                }
                
                self.discoverBannerCollectionView.reloadData()
                self.bannerPageController.numberOfPages = self.sliderArr.count
                
            }
        }
    }
    //    MARK:- VIDEOS DATA API
    func getVideosData(){

        hashtagDataArr.removeAll()
        //        videosArr.removeAll()
        
        ApiHandler.sharedInstance.showDiscoverySections { (isSuccess, response) in
            if isSuccess{
                print("response: ",response?.allValues)
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    let videosHashtags = response?.value(forKey: "msg") as! NSArray
                    
                    //                    videos hashtags extract
                    
                    print("videosHashtags.count: ",videosHashtags.count)
                    for i in 0 ..< videosHashtags.count{
                        
                        let dic = videosHashtags[i] as! NSDictionary
                        let hashtagsDic = dic.value(forKey: "Hashtag") as! NSDictionary
                        
                        let hashName =  hashtagsDic.value(forKey: "name") as! String
                        let views = hashtagsDic.value(forKey: "views") as! String
                        
                        let videosObj = hashtagsDic.value(forKey: "Videos") as! NSArray
                        
                        //                        extract videos data against hashtag
                        
                        var videosArr = [videoMainMVC]()
                        videosArr.removeAll()
                        
                        for j in 0 ..< videosObj.count{
                            
                            let videosData = videosObj[j] as! NSDictionary
                            
                            let videoObj = videosData.value(forKey: "Video") as! NSDictionary
                            let userObj = videoObj.value(forKey: "User") as! NSDictionary
//                            let soundObj = videoObj.value(forKey: "Sound") as! NSDictionary
                            
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
                            
//                            let soundID = soundObj.value(forKey: "id") as? String
//                            let soundName = soundObj.value(forKey: "name") as? String
                            
                            
                            let video = videoMainMVC(videoID: videoID, videoUserID: "", fb_id: "", description: videoDesc, videoURL: videoUrl, videoTHUM: videoThum, videoGIF: videoGif, view: views, section: "", sound_id: "", privacy_type: "", allow_comments: allowComment, allow_duet: allowDuet, block: "", duet_video_id: "", old_video_id: "", created: created, like: like, favourite: "", comment_count: videoComments, like_count: videoLikes, followBtn: "", duetVideoID: "\(duetVidID!)", userID: userID, first_name: "", last_name: "", gender: "", bio: "", website: "", dob: "", social_id: "", userEmail: "", userPhone: "", password: "", userProfile_pic: "", role: "", username: username, social: "", device_token: "", videoCount: "", verified: "\(verified!)", soundName: "")
                            
                            videosArr.append(video)
                            
                            print("videoLikes: ",videoLikes)
                        }
                        
                        self.hashtagDataArr.append(["videosObj":videosArr,"hashName":hashName,"views":views])
                        print("hastag: ",videosHashtags[i])
                    }
                    AppUtility?.stopLoader(view: self.view)
                }else{
                    self.showToast(message: "not200", font: .systemFont(ofSize: 12))
                    AppUtility?.stopLoader(view: self.view)
                }
                
            }
            
//            self.discoverTblView.reloadData()
            self.setupView()
            self.discoverTblView.reloadData()
            
        }
    }
}
