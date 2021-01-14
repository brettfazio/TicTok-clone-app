//
//  soundsViewController.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 16/11/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit
import SDWebImage

class soundsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    //MARK:- Outlets
    
    //    @IBOutlet weak var scrollViewOutlet: UIScrollView!
    @IBOutlet weak var soundsTblView: UITableView!
    @IBOutlet weak var favSoundsTblView: UITableView!
    
    @IBOutlet var tblheight: NSLayoutConstraint!
    @IBOutlet var favTblheight: NSLayoutConstraint!
    
    var soundsDataArr = [[String:Any]]()
    
    var favSoundDataArr = [soundsMVC]()
    
    struct soundSectionsStruct {
        let secID:String
        let secName:String
    }
    var soundSecArr = [soundSectionsStruct]()
    
    var startingPoint = "0"
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
        
        return refreshControl
    }()
    
    
    @IBOutlet weak var btnDiscover: UIButton!
    @IBOutlet weak var btnFav: UIButton!
    
    @IBOutlet weak var btnDiscoverBottomView: UIView!
    @IBOutlet weak var btnFavBottomView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favSoundsTblView.delegate = self
        favSoundsTblView.dataSource = self
        
        soundsTblView.isHidden = false
        favSoundsTblView.isHidden = true
        
        btnFavBottomView.backgroundColor = .lightGray
        btnFav.setTitleColor(.lightGray, for: .normal)
        
        soundsTblView.delegate = self
        soundsTblView.dataSource = self
        //        soundsTblView.reloadData()
        
        setupView()
        GetAllSounds()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.dissmissControllerNoti(notification:)), name: Notification.Name("dismissController"), object: nil)
    }
    
    @objc
    func requestData() {
        print("requesting data")
        
        
        let deadline = DispatchTime.now() + .milliseconds(700)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.refresher.endRefreshing()
        }
    }
    
    @objc func dissmissControllerNoti(notification: Notification) {
        
        print("dissmissControllerNoti received")
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 10.0, *) {
            soundsTblView.refreshControl = refresher
        } else {
            soundsTblView.addSubview(refresher)
        }
        
    }
    
    @IBAction func btnDiscoverAction(_ sender: Any) {
        
        TPGAudioPlayer.sharedInstance().player.pause()
        
        btnFavBottomView.backgroundColor = .lightGray
        btnFav.setTitleColor(.lightGray, for: .normal)
        
        
        btnDiscover.setTitleColor(.black, for: .normal)
        btnDiscoverBottomView.backgroundColor = .black
        
        soundsTblView.isHidden = false
        favSoundsTblView.isHidden = true
        
        GetAllSounds()
    }
    
    @IBAction func btnFavAction(_ sender: Any) {
        
        TPGAudioPlayer.sharedInstance().player.pause()
        
        btnFavBottomView.backgroundColor = .black
        btnFav.setTitleColor(.black, for: .normal)
        
        
        btnDiscover.setTitleColor(.lightGray, for: .normal)
        btnDiscoverBottomView.backgroundColor = .lightGray
        
        getFavSounds()
        soundsTblView.isHidden = true
        favSoundsTblView.isHidden = false
    }
    
    //MARK:- SetupView
    
    func setupView(){
        //   favTblheight.constant = CGFloat(favSoundDataArr.count * 80)
        //   tblheight.constant = CGFloat(soundsDataArr.count * 300 + 500)
        // self.view.layoutIfNeeded()
        print("soundsDataArr.count * 300: ",soundsDataArr.count * 300)
        
    }
    
    //MARK: TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("soundsDataArr.count: ",soundsDataArr.count)
        if tableView == favSoundsTblView{
            return favSoundDataArr.count
        }else{
            return soundsDataArr.count
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView == favSoundsTblView{
        let visiblePaths = favSoundsTblView.indexPathsForVisibleRows
        for i in visiblePaths!  {
            let visiblePaths = favSoundsTblView.indexPathsForVisibleRows
            for i in visiblePaths!  {
                let cell = favSoundsTblView.cellForRow(at: i) as? favSoundsTableViewCell
                //            cell.playImg.image = UIImage(named: "ic_play_icon")
                cell?.playImg.image = UIImage(named: "ic_play_icon")
                cell?.btnSelect.isHidden = true
            }
            
        }
    }
    
}
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == favSoundsTblView{
            let obj = favSoundDataArr[indexPath.row]
            loadAudio(audioURL: (AppUtility?.detectURL(ipString: obj.audioURL))!, ip: indexPath)
        }
        
    }
    
    func loadAudio(audioURL: String,ip:IndexPath) {
        
        let cell = favSoundsTblView.cellForRow(at: ip) as! favSoundsTableViewCell
        
        let kTestImage = "26"
        
        let dictionary: Dictionary <String, AnyObject> = SpringboardData.springboardDictionary(title: "audioP", artist: "audioP Artist", duration: Int (300.0), listScreenTitle: "audioP Screen Title", imagePath: Bundle.main.path(forResource: "Spinner-1s-200px", ofType: "gif")!)
        
        cell.playImg.isHidden = true
        cell.loadIndicator.startAnimating()

        TPGAudioPlayer.sharedInstance().playPauseMediaFile(audioUrl: URL(string: audioURL)! as NSURL, springboardInfo: dictionary, startTime: 0.0, completion: {(_ , stopTime) -> () in
            //
            cell.playImg.isHidden = false
            cell.loadIndicator.stopAnimating()
            //            self.hideLoadingIndicator()
            //            self.setupSlider()
            self.updatePlayButton(ip: ip)
            
            print("there",stopTime)
        } )
        
        
    }
 
 
    
    func updatePlayButton(ip:IndexPath) {
        
        let cell = favSoundsTblView.cellForRow(at: ip) as! favSoundsTableViewCell
        
        let playPauseImage = (TPGAudioPlayer.sharedInstance().isPlaying ? UIImage(named: "ic_pause_icon") : UIImage(named: "ic_play_icon"))
        
        cell.btnSelect.isHidden = TPGAudioPlayer.sharedInstance().isPlaying ? false : true
        //        self.playButton.setImage(playPauseImage, for: UIControlState())
        cell.playImg.image = playPauseImage
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == favSoundsTblView{
            let favSoundCell =  tableView.dequeueReusableCell(withIdentifier: "favSoundsTVC") as! favSoundsTableViewCell
            
            let favObj = favSoundDataArr[indexPath.row]
            favSoundCell.soundName.text = favObj.name
            favSoundCell.soundDesc.text = favObj.description
            favSoundCell.duration.text = favObj.duration
            
            favSoundCell.soundImg.sd_imageIndicator = SDWebImageActivityIndicator.gray
            favSoundCell.soundImg.sd_setImage(with: URL(string:(AppUtility?.detectURL(ipString: favObj.thum))!), placeholderImage: UIImage(named:"noMusicIcon"))
            if favObj.favourite == "1"{
                favSoundCell.btnFav.setImage(UIImage(named: "btnFavFilled"), for: .normal)
            }else{
                favSoundCell.btnFav.setImage(UIImage(named:"btnFavEmpty"), for: .normal)
            }
            
            favSoundCell.btnFav.addTarget(self, action: #selector(soundsViewController.btnSoundFavAction(_:)), for:.touchUpInside)
            favSoundCell.btnSelect.addTarget(self, action: #selector(soundsViewController.btnSelectAction(_:)), for:.touchUpInside)
            
            favSoundCell.btnSelect.isHidden = true
            return favSoundCell
        }else{
            let soundCell =  tableView.dequeueReusableCell(withIdentifier: "soundsTVC") as! soundsTableViewCell
            soundCell.soundsCollectionView.reloadData()
            
            let obj = soundsDataArr[indexPath.row]["soundSection"] as! [soundSectionsStruct]
            let secObj = obj[indexPath.row]
            soundCell.sectionTitle.text = secObj.secName
            soundCell.soundsObj = soundsDataArr[indexPath.row]["soundObj"] as! [soundsMVC]
            
            soundCell.btnAll.addTarget(self, action: #selector(soundsViewController.btnAllAction(_:)), for:.touchUpInside)

            
            return soundCell
        }
        
    }
    
    //    MARK:- Btn fav sound Action
        @objc func btnSoundFavAction(_ sender : UIButton) {
            let buttonPosition = sender.convert(CGPoint.zero, to: self.favSoundsTblView)
            let indexPath = self.favSoundsTblView.indexPathForRow(at: buttonPosition)
            let cell = self.favSoundsTblView.cellForRow(at: indexPath!) as! favSoundsTableViewCell
            
            let btnFavImg = cell.btnFav.currentImage
            
            if btnFavImg == UIImage(named: "btnFavEmpty"){
                cell.btnFav.setImage(UIImage(named: "btnFavFilled"), for: .normal)
            }else{
                cell.btnFav.setImage(UIImage(named: "btnFavEmpty"), for: .normal)
            }
            
            let obj = favSoundDataArr[indexPath!.row]
            
            addFavSong(soundID: obj.id, btnFav: cell.btnFav)

        }
        
    //    MARK:- Btn select Action
    @objc func btnSelectAction(_ sender : UIButton) {
        
        TPGAudioPlayer.sharedInstance().player.pause()
        AppUtility?.startLoader(view: self.view)
        print("btnSelect Tapped")
        let newObj = favSoundDataArr[sender.tag]
        
        UserDefaults.standard.set(newObj.audioURL, forKey: "url")
        UserDefaults.standard.set(newObj.name, forKey: "selectedSongName")
        
        if let audioUrl = URL(string: newObj.audioURL) {
            
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
                    
                    AppUtility?.stopLoader(view: self.view!)
//                    NotificationCenter.default.post(name: Notification.Name("dismissController"), object: nil)
                    NotificationCenter.default.post(name: Notification.Name("loadAudio"), object: nil)
                    self.dismiss(animated: true, completion: nil)
                    
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
                            
                            AppUtility?.stopLoader(view: self.view)
//                            NotificationCenter.default.post(name: Notification.Name("dismissController"), object: nil)
                            NotificationCenter.default.post(name: Notification.Name("loadAudio"), object: nil)
                            self.dismiss(animated: true, completion: nil)
                        }
                        
                        
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        AppUtility?.stopLoader(view: self.view)
                    }
                    
                }).resume()
            }
        }
        
    }
    
//    MARK:- BTN ALL ACTION
    @objc func btnAllAction(_ sender : UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.soundsTblView)
        let indexPath = self.soundsTblView.indexPathForRow(at:buttonPosition)
        let cell = self.soundsTblView.cellForRow(at: indexPath!) as! soundsTableViewCell

        let obj = soundSecArr[indexPath!.row]
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "allSoundsVC") as! allSoundsViewController
        vc.sectionID = obj.secID
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("soundsDataArr.count: ",soundsDataArr.count*100)
        
        if tableView == favSoundsTblView{
            return 80.0
        }
        
        if tableView == soundsTblView{
            let soundObj = soundsDataArr[indexPath.row]["soundObj"] as! [soundsMVC]
            for i in 0 ..< soundsDataArr.count{
                if indexPath.row == i{
                    if soundObj.count >= 3{
                        return 320
                    }else{
                        print("soundObj.count*108: ",soundObj.count*130)
                        return (CGFloat(soundObj.count*130))
                    }
                }
            }
        }
        return 180.0
    }
    //    Mark:- Favorite sounds API
    func getFavSounds(){
        
        favSoundDataArr.removeAll()
        
        AppUtility?.startLoader(view: self.view)
        ApiHandler.sharedInstance.showFavouriteSounds(user_id: UserDefaults.standard.string(forKey: "userID")!) { (isSuccess, response) in
            if isSuccess{
                if (response?.value(forKey: "code") as! NSNumber) == 200{
                    let msgDic = response?.value(forKey: "msg") as! NSArray
                    
                    for dic in msgDic{
                        let soundDic = dic as! NSDictionary
                        let soundObj = soundDic.value(forKey: "Sound") as! NSDictionary
                        
                        let id = soundObj.value(forKey: "id") as! String
                        let audioUrl = soundObj.value(forKey: "audio") as! String
                        let duration = soundObj.value(forKey: "duration") as! String
                        let name = soundObj.value(forKey: "name") as! String
                        let description = soundObj.value(forKey: "description") as! String
                        let thum = soundObj.value(forKey: "thum") as! String
                        let section = soundObj.value(forKey: "sound_section_id") as! String
                        let uploaded_by = soundObj.value(forKey: "uploaded_by") as! String
                        let created = soundObj.value(forKey: "created") as! String
                        //                        let favourite = soundObj.value(forKey: "favourite")
                        let publish = soundObj.value(forKey: "publish") as! String
                        
                        let obj = soundsMVC(id: id, audioURL: audioUrl, duration: duration, name: name, description: description, thum: thum, section: section, uploaded_by: uploaded_by, created: created, favourite: "", publish: publish)
                        
                        self.favSoundDataArr.append(obj)
                    }
                    AppUtility?.stopLoader(view: self.view)
                    
                }else{
                    AppUtility?.stopLoader(view: self.view)
                    self.showToast(message: "Empty", font: .systemFont(ofSize: 12))
                    print("!200: ",response?.value(forKey: "msg")!)
                }
                
                
                self.favSoundsTblView.reloadData()
                self.setupView()
                self.favSoundsTblView.reloadData()
            }else{
                AppUtility?.stopLoader(view: self.view)
            }
        }
        
        //        AppUtility?.stopLoader(view: self.view)
    }
    
    func GetAllSounds(){
        soundsDataArr.removeAll()
        AppUtility?.startLoader(view: self.view)
        ApiHandler.sharedInstance.showSounds(user_id: UserDefaults.standard.string(forKey: "userID")!, starting_point: startingPoint) { (isSuccess, response) in
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200{
                    let soundMsg = response?.value(forKey: "msg") as! NSArray
                    
                    //                    videos hashtags extract
                    
                    print("soundMsg.count: ",soundMsg.count)
                    for i in 0 ..< soundMsg.count{
                        let dic = soundMsg[i] as! NSDictionary
                        let soundSecDict = dic.value(forKey: "SoundSection") as! NSDictionary
                        
                        let sectionID = soundSecDict.value(forKey: "id") as! String
                        let sectionName = soundSecDict.value(forKey: "name") as! String
                        
                        let secObj = soundSectionsStruct(secID: sectionID, secName: sectionName)
                        
                        self.soundSecArr.append(secObj)
                        
                        
                        let soundsObj = dic.value(forKey: "Sound") as! NSArray
                        
                        var soundsArr = [soundsMVC]()
                        soundsArr.removeAll()
                        
                        for j in 0 ..< soundsObj.count{
                            let soundsData = soundsObj[j] as! NSDictionary
                            
                            let id = soundsData.value(forKey: "id") as! String
                            let audioUrl = soundsData.value(forKey: "audio") as! String
                            let duration = soundsData.value(forKey: "duration") as! String
                            let name = soundsData.value(forKey: "name") as! String
                            let description = soundsData.value(forKey: "description") as! String
                            let thum = soundsData.value(forKey: "thum") as! String
                            let section = soundsData.value(forKey: "sound_section_id") as! String
                            let uploaded_by = soundsData.value(forKey: "uploaded_by") as! String
                            let created = soundsData.value(forKey: "created") as! String
                            let favourite = soundsData.value(forKey: "favourite")
                            let publish = soundsData.value(forKey: "publish")  as! String
                            
                            let soundObj = soundsMVC(id: id, audioURL: audioUrl, duration: duration, name: name, description: description, thum: thum, section: section, uploaded_by: uploaded_by, created: created, favourite: "\(favourite!)", publish: publish)
                            
                            soundsArr.append(soundObj)
                        }
                        self.soundsDataArr.append(["soundObj":soundsArr,"soundSection":self.soundSecArr])
                        print("soundsDataArr: ",self.soundsDataArr[i])
                    }
                    AppUtility?.stopLoader(view: self.view)
                }else{
                    print("!200: ",response as! Any)
                    AppUtility?.stopLoader(view: self.view)
                }
            }
            
            self.soundsTblView.reloadData()
            self.setupView()
            self.soundsTblView.reloadData()
        }
    }
    
    //    MARK:- ADD FAV SOUND FUNC API
    func addFavSong(soundID:String,btnFav:UIButton){
        AppUtility?.startLoader(view: self.view)
        ApiHandler.sharedInstance.addSoundFavourite(user_id: UserDefaults.standard.string(forKey: "userID")!, sound_id: soundID) { (isSuccess, response) in
            if isSuccess{
                AppUtility?.stopLoader(view: self.view)
                if response?.value(forKey: "code") as! NSNumber == 200{
                    print("msg: ",response?.value(forKey: "msg")!)
                    
                    if btnFav.currentImage == UIImage(named: "btnFavEmpty"){
                        //                        self.showToast(message: "Removed From Favorite", font: .systemFont(ofSize: 12))
                    }else{
                        //                        self.showToast(message: "Added to Favorite", font: .systemFont(ofSize: 12))
                    }
                    
                }else{
                    AppUtility?.stopLoader(view: self.view)
                    //                    self.showToast(message: "!200", font: .systemFont(ofSize: 12))
                    print("!200: ",response)
                }
            }
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

