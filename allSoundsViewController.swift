//
//  allSoundsViewController.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 17/11/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit
import SDWebImage

class allSoundsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var allSoundsTV : UITableView!
    var soundsDataArr = [soundsMVC]()
    
    var sectionID = ""
    var startingPoint = 0
    var dataEnd = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("section id: ",sectionID)
        allSoundsTV.tableFooterView = UIView()
        getSounds()
        // Do any additional setup after loading the view.
    }
    
    //MARK: TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("sectionSoundsDataArr.count: ",soundsDataArr.count)
        return soundsDataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let soundCell =  tableView.dequeueReusableCell(withIdentifier: "allSoundsTVC") as! allSoundsTableViewCell
        let obj = soundsDataArr[indexPath.row]
        soundCell.soundName.text = obj.name
        soundCell.soundDesc.text = obj.description
        soundCell.duration.text = obj.duration
        
        soundCell.soundImg.sd_imageIndicator = SDWebImageActivityIndicator.gray
        soundCell.soundImg.sd_setImage(with: URL(string:(AppUtility?.detectURL(ipString: obj.thum))!), placeholderImage: UIImage(named:"noMusicIcon"))
        
        soundCell.btnFav.addTarget(self, action: #selector(allSoundsViewController.btnSoundFavAction(_:)), for:.touchUpInside)
        soundCell.btnSelect.tag = indexPath.row
        soundCell.btnSelect.addTarget(self, action: #selector(allSoundsViewController.btnSelectAction(_:)), for:.touchUpInside)
        
        if obj.favourite == "1"{
               soundCell.btnFav.setImage(UIImage(named: "btnFavFilled"), for: .normal)
           }else{
               soundCell.btnFav.setImage(UIImage(named:"btnFavEmpty"), for: .normal)
           }
        
        soundCell.btnSelect.isHidden = true
        
        
        return soundCell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = soundsDataArr[indexPath.row]
        loadAudio(audioURL: (AppUtility?.detectURL(ipString: obj.audioURL))!, ip: indexPath)
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let visiblePaths = allSoundsTV.indexPathsForVisibleRows
        
        for i in visiblePaths!  {
            let cell = allSoundsTV.cellForRow(at: i) as? allSoundsTableViewCell
            //            cell.playImg.image = UIImage(named: "ic_play_icon")
            cell?.playImg.image = UIImage(named: "ic_play_icon")
            cell?.btnSelect.isHidden = true
            
        }
    }
    
    func loadAudio(audioURL: String,ip:IndexPath) {
        
        let cell = allSoundsTV.cellForRow(at: ip) as! allSoundsTableViewCell
        
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
        
        let cell = allSoundsTV.cellForRow(at: ip) as! allSoundsTableViewCell
        
        let playPauseImage = (TPGAudioPlayer.sharedInstance().isPlaying ? UIImage(named: "ic_pause_icon") : UIImage(named: "ic_play_icon"))
        
        cell.btnSelect.isHidden = TPGAudioPlayer.sharedInstance().isPlaying ? false : true
        //        self.playButton.setImage(playPauseImage, for: UIControlState())
        cell.playImg.image = playPauseImage
    }
    
    //    MARK:- BTN FAV SOUND ACTION
    @objc func btnSoundFavAction(_ sender : UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.allSoundsTV)
        let indexPath = self.allSoundsTV.indexPathForRow(at:buttonPosition)
        let cell = self.allSoundsTV.cellForRow(at: indexPath!) as! allSoundsTableViewCell
        
        let btnFavImg = cell.btnFav.currentImage
        
        if btnFavImg == UIImage(named: "btnFavEmpty"){
            cell.btnFav.setImage(UIImage(named: "btnFavFilled"), for: .normal)
        }else{
            cell.btnSelect.setImage(UIImage(named: "btnFavEmpty"), for: .normal)
        }
        
        let obj = soundsDataArr[indexPath!.row]
        
        //            addFavSong(soundID: obj.id, btnFav: cell.favBtn)
    }
        
    //    MARK:- SELECT SOUND ACTION
    @objc func btnSelectAction(_ sender : UIButton) {
        
        TPGAudioPlayer.sharedInstance().player.pause()
        AppUtility?.startLoader(view: self.view)
        print("btnSelect Tapped")
        let newObj = soundsDataArr[sender.tag]
        
        UserDefaults.standard.set(newObj.audioURL, forKey: "url")
        UserDefaults.standard.set(newObj.name, forKey: "selectedSongName")
        
        print("newObj.audioURL,: ",newObj.audioURL)
        
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
                    NotificationCenter.default.post(name: Notification.Name("dismissController"), object: nil)
                    //                        NotificationCenter.default.post(name: Notification.Name("loadAudio"), object: nil)
                    //                        self.dismiss(animated: true, completion: nil)
                    
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
                            NotificationCenter.default.post(name: Notification.Name("dismissController"), object: nil)
                            //                                NotificationCenter.default.post(name: Notification.Name("loadAudio"), object: nil)
                            //                                self.dismiss(animated: true, completion: nil)
                        }
                        
                        
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        AppUtility?.stopLoader(view: self.view)
                    }
                    
                }).resume()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == soundsDataArr.count - 1{
            
            if dataEnd == false{
                self.startingPoint += 1
                getSounds()
            }
            
        }
    }
    @IBAction func btnBack(_ sender: Any) {
//        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    func getSounds(){
        
        AppUtility?.startLoader(view: self.view)
        ApiHandler.sharedInstance.showSoundsAgainstSection(user_id: "0", starting_point: "\(self.startingPoint)", sectionID: self.sectionID) { (isSuccess, response) in
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200{
                    let msgDic = response?.value(forKey: "msg") as! NSArray
                    
                    if msgDic.count <= 0{
                        self.dataEnd = true
                    }else{
                        self.dataEnd = false
                    }
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
                        
                        
                        self.soundsDataArr.append(obj)
                    }
                    
                    AppUtility?.stopLoader(view: self.view)
                    self.allSoundsTV.reloadData()
                }else{
                    
                    AppUtility?.stopLoader(view: self.view)
                    print("!200: ",response as! Any)
                }
            }
        }
        
    }
}
