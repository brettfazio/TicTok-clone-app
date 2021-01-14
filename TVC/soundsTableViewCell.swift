//
//  soundsTableViewCell.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 16/11/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation

class soundsTableViewCell: UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    var bombSoundEffect : AVAudioPlayer?
    var played = false
    
    var arrData = ["night3","night2","night3","night3","night2","night3"]
    @IBOutlet weak var soundsCollectionView: UICollectionView!
    
    @IBOutlet weak var sectionTitle : UILabel!
    @IBOutlet weak var btnAll : UIButton!
    
    
    var soundsObj = [soundsMVC]()
//    var secMainArr = [[String:Any]]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        soundsCollectionView.delegate = self
        soundsCollectionView.dataSource = self
        // soundsCollectionView.reloadData()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    //MARK: CollectionView.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return soundsObj.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier:"soundsCVC" , for: indexPath) as! soundsCollectionViewCell
        
        let obj = soundsObj[indexPath.row]
        
        cell.soundName.text = obj.name
        cell.soundDesc.text = obj.description
        cell.duration.text = obj.duration
        
        cell.soundImg.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.soundImg.sd_setImage(with: URL(string:(AppUtility?.detectURL(ipString: obj.thum))!), placeholderImage: UIImage(named:"noMusicIcon"))
        
        if obj.favourite == "1"{
            cell.btnFav.setImage(UIImage(named: "btnFavFilled"), for: .normal)
        }else{
            cell.btnFav.setImage(UIImage(named:"btnFavEmpty"), for: .normal)
        }
        
        cell.btnSelect.tag = indexPath.row
        
        cell.btnFav.addTarget(self, action: #selector(discoverSearchViewController.btnSoundFavAction(_:)), for:.touchUpInside)
        cell.btnSelect.addTarget(self, action: #selector(discoverSearchViewController.btnSelectAction(_:)), for:.touchUpInside)
        
        cell.btnSelect.isHidden = true
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.soundsCollectionView.frame.size.width-20, height: 80)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier:"soundsCVC" , for: indexPath) as! soundsCollectionViewCell
        
        let obj = soundsObj[indexPath.row]

        print("indexPath: ",indexPath.row)
        
        
        
        loadAudio(audioURL: (AppUtility?.detectURL(ipString: obj.audioURL))!, ip: indexPath)
    }
    
    //    MARK:- Btn fav sound Action
    @objc func btnSoundFavAction(_ sender : UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.soundsCollectionView)
        let indexPath = self.soundsCollectionView.indexPathForItem(at: buttonPosition)
        let cell = self.soundsCollectionView.cellForItem(at: indexPath!) as! soundsCollectionViewCell
        
        let btnFavImg = cell.btnFav.currentImage
        
        if btnFavImg == UIImage(named: "btnFavEmpty"){
            cell.btnFav.setImage(UIImage(named: "btnFavFilled"), for: .normal)
        }else{
            cell.btnFav.setImage(UIImage(named: "btnFavEmpty"), for: .normal)
        }
        
        let obj = soundsObj[indexPath!.row]
        
        addFavSong(soundID: obj.id, btnFav: cell.btnFav)

    }
    
    //    MARK:- Btn select Action
    @objc func btnSelectAction(_ sender : UIButton) {
        
        TPGAudioPlayer.sharedInstance().player.pause()
        AppUtility?.startLoader(view: self.superview!)
        print("btnSelect Tapped")
        let newObj = soundsObj[sender.tag]
        
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

                    AppUtility?.stopLoader(view: self.superview!)
                    NotificationCenter.default.post(name: Notification.Name("dismissController"), object: nil)
                    NotificationCenter.default.post(name: Notification.Name("loadAudio"), object: nil)
//                    self.dismiss(animated: true, completion: nil)
                    
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
   
                            AppUtility?.stopLoader(view: self.superview!)
                            NotificationCenter.default.post(name: Notification.Name("dismissController"), object: nil)
                            NotificationCenter.default.post(name: Notification.Name("loadAudio"), object: nil)
//                            self.dismiss(animated: true, completion: nil)
                        }
                        
                        
                    } catch let error as NSError {
                        print(error.localizedDescription)
                         AppUtility?.stopLoader(view: self.superview!)
                    }
                    
//                    AppUtility?.stopLoader(view: self.superview!)

                }).resume()
            }
        }
        
    }
    func loadAudio(audioURL: String,ip:IndexPath) {
        
        let cell = soundsCollectionView.cellForItem(at: ip) as! soundsCollectionViewCell
        
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
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {


        let visiblePaths = collectionView.indexPathsForVisibleItems

            for i in visiblePaths  {
                let cell = collectionView.cellForItem(at: i) as? soundsCollectionViewCell
                //            cell.playImg.image = UIImage(named: "ic_play_icon")
                cell?.playImg.image = UIImage(named: "ic_play_icon")
                cell?.btnSelect.isHidden = true

            }

    }
    
    func updatePlayButton(ip:IndexPath) {
        
        let cell = soundsCollectionView.cellForItem(at: ip) as! soundsCollectionViewCell
        
        let playPauseImage = (TPGAudioPlayer.sharedInstance().isPlaying ? UIImage(named: "ic_pause_icon") : UIImage(named: "ic_play_icon"))
        
        cell.btnSelect.isHidden = TPGAudioPlayer.sharedInstance().isPlaying ? false : true
        //        self.playButton.setImage(playPauseImage, for: UIControlState())
        cell.playImg.image = playPauseImage
    }
    
    //    MARK:- ADD FAV SOUND FUNC API
    func addFavSong(soundID:String,btnFav:UIButton){
        AppUtility?.startLoader(view: self.superview!)
        ApiHandler.sharedInstance.addSoundFavourite(user_id: UserDefaults.standard.string(forKey: "userID")!, sound_id: soundID) { (isSuccess, response) in
            if isSuccess{
                AppUtility?.stopLoader(view: self.superview!)
                if response?.value(forKey: "code") as! NSNumber == 200{
                    print("msg: ",response?.value(forKey: "msg")!)
                    
                    if btnFav.currentImage == UIImage(named: "btnFavEmpty"){
//                        self.showToast(message: "Removed From Favorite", font: .systemFont(ofSize: 12))
                    }else{
//                        self.showToast(message: "Added to Favorite", font: .systemFont(ofSize: 12))
                    }
                    
                }else{
                    AppUtility?.stopLoader(view: self.superview!)
//                    self.showToast(message: "!200", font: .systemFont(ofSize: 12))
                    print("!200: ",response)
                }
            }
        }
    }
}

extension soundsTableViewCell{
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        soundsCollectionView.delegate = dataSourceDelegate
        soundsCollectionView.dataSource = dataSourceDelegate
        soundsCollectionView.tag = row
        soundsCollectionView.setContentOffset(soundsCollectionView.contentOffset, animated:false) // Stops collection view if it was scrolling.
        soundsCollectionView.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        set { soundsCollectionView.contentOffset.x = newValue }
        get { return soundsCollectionView.contentOffset.x }
    }
}
