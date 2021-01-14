

import UIKit
import Alamofire
import SDWebImage
import AVKit
import EFInternetIndicator
import NVActivityIndicatorView

class AddSoundViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,InternetStatusIndicable {
    var internetConnectionIndicator: InternetViewIndicator?
    
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var whoopsView: UIView!
    
    @IBOutlet weak var soud_view: UIView!
    
    @IBOutlet weak var fav_view: UIView!
    
    @IBOutlet weak var btn_discover: UIButton!
    
    @IBOutlet weak var btn_favourite: UIButton!
    
    @IBOutlet weak var tablview: UITableView!
    
    
    var sound_array =  [Sound]()
    
    var Fav_Array:NSMutableArray = []
    
    var player:AVPlayer!
    
    var loadingToggle:String? = "yes"
    var refreshControl = UIRefreshControl()
    
    var isDisCover:String! = "yes"
    
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    
    var startingPoint = "0"
    
    var soundsMainArr = [[soundsMVC]]()
    var favSoundsArr = [soundsMVC]()
    var sectionsNamesArr = [String]()
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
        
        return refreshControl
    }()
    
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.startMonitoringInternet()
        tablview.tableFooterView = UIView()
        
        self.getFavSounds()
        self.getSounds()
        loaderView.type = .ballBeat
        loaderView.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 0.7509364298)
        loaderView.color = .white
        
        if #available(iOS 10.0, *) {
            tablview.refreshControl = refresher
        } else {
            tablview.addSubview(refresher)
        }
        newGetAllSounds(start: startingPoint)
//        AppUtility?.startLoader(view: self.view)
        whoopsView.isHidden = true
        


        
    }
    
    @objc
    func requestData() {
        print("requesting data")
        
        self.startingPoint = "0"
        newGetAllSounds(start: startingPoint)
        let deadline = DispatchTime.now() + .milliseconds(700)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.refresher.endRefreshing()
        }
    }
    
    @objc func refresh(sender:AnyObject) {
        loadingToggle = "no"
        self.getSounds()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
        self.startMonitoringInternet()
    }
    
    // Get All Sounds Api
    
    func getSounds(){
        
        let url : String = self.appDelegate.baseUrl!+self.appDelegate.allSounds!
        //        let  sv = HomeViewController.displaySpinner(onView: self.view)
        AppUtility?.startLoader(view: self.view)
        
        
        print(url)
        //print(parameter!)
        
        let headers: HTTPHeaders = [
            "api-key": "4444-3333-2222-1111"
            
        ]
        
        AF.request(url, method: .post, parameters:nil, encoding:JSONEncoding.default, headers:headers).validate().responseJSON(completionHandler: {
            
            respones in
            
            
            
            switch respones.result {
            case .success( let value):
                
                let json  = value
                
                //                HomeViewController.removeSpinner(spinner: sv)
                AppUtility?.stopLoader(view: self.view)
                
                self.sound_array = []
                print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! NSString
                if(code == "200"){
                    
                    if let myCountry = dic["msg"] as? NSArray{
                        for i in 0...myCountry.count-1{
                            
                            if  let sectionData = myCountry[i] as? NSDictionary{
                                let tempMenuObj = Sound()
                                tempMenuObj.name = sectionData["section_name"] as? String
                                if let extraData = sectionData["sections_sounds"] as? NSArray{
                                    
                                    for j in 0...extraData.count-1{
                                        let dic2 = extraData[j] as! [String:Any]
                                        
                                        var tempProductList = Itemlist()
                                        
                                        if let audio_path = dic2["audio_path"] as? NSDictionary{
                                            
                                            tempProductList.audio_path = audio_path["acc"] as? String
                                            
                                            tempProductList.uid = dic2["id"] as? String
                                            tempProductList.sound_name = dic2["sound_name"] as? String
                                            tempProductList.thum = dic2["thum"] as? String
                                            tempProductList.description = dic2["description"] as? String
                                            tempMenuObj.listOfProducts.append(tempProductList)
                                            
                                        }
                                        
                                    }
                                    self.sound_array.append(tempMenuObj)
                                }
                            }
                            
                        }
                        
                    }
                    
                    self.tablview.delegate = self
                    self.tablview.dataSource = self
                    self.tablview.reloadData()
                    
                    
                }else{
                    
                    self.alertModule(title:"Error", msg:dic["msg"] as! String)
                    
                }
                
                
                
            case .failure(let error):
                print(error)
                //                HomeViewController.removeSpinner(spinner: sv)
                AppUtility?.stopLoader(view: self.view)
                self.alertModule(title:"Error",msg:error.localizedDescription)
            }
        })
        AppUtility?.stopLoader(view: self.view)
        
    }
    
    // Get All Favourite Api
    
    func getFavSounds(){
        
        let url : String = self.appDelegate.baseUrl!+self.appDelegate.my_FavSound!
        //        let  sv = HomeViewController.displaySpinner(onView: self.view)
        AppUtility?.startLoader(view: self.view)
        
        let parameter :[String:Any]? = ["fb_id":UserDefaults.standard.string(forKey: "uid")!]
        print(url)
        print(parameter!)
        
        let headers: HTTPHeaders = [
            "api-key": "4444-3333-2222-1111"
            
        ]
        
        AF.request(url, method: .post, parameters:parameter, encoding:JSONEncoding.default, headers:headers).validate().responseJSON(completionHandler: {
            
            respones in
            
            switch respones.result {
            case .success( let value):
                
                let json  = value
                
                //                HomeViewController.removeSpinner(spinner: sv)
                AppUtility?.stopLoader(view: self.view)
                
                self.Fav_Array = []
                print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! NSString
                if(code == "200"){
                    
                    let myCountry = (dic["msg"] as? [[String:Any]])!
                    for Dict in myCountry {
                        
                        let myRestaurant = Dict as NSDictionary
                        
                        let sid = myRestaurant["id"] as! String
                        let audio_patha = myRestaurant["audio_path"] as! NSDictionary
                        let thum = myRestaurant["thum"] as! String
                        
                        let descri = myRestaurant["description"] as! String
                        
                        let sound_name = myRestaurant["sound_name"] as? String
                        let audio_path:String! =   audio_patha["acc"] as? String
                        
                        
                        let obj = FavSound(sid: sid, thum: thum, sound_name: sound_name,audio_path: audio_path, descri: descri)
                        
                        self.Fav_Array.add(obj)
                    }
                    
                    self.tablview.delegate = self
                    self.tablview.dataSource = self
                    self.tablview.reloadData()
                    
                }else{
                    
                    self.alertModule(title:"Error", msg:dic["msg"] as! String)
                    
                }
                
            case .failure(let error):
                print(error)
                //                HomeViewController.removeSpinner(spinner: sv)
                AppUtility?.stopLoader(view: self.view)
                self.alertModule(title:"Error",msg:error.localizedDescription)
            }
        })
        
        AppUtility?.stopLoader(view: self.view)
        
    }
    
    // Tableview Delegate methods
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(self.isDisCover == "yes"){
            
            // MARK:- Old section title
            /*
             if section < sound_array.count {
             let obj = sound_array[section]
             return obj.name
             }*/
            
            return sectionsNamesArr[section]
        }
        return ""
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(self.isDisCover == "yes"){
            return sectionsNamesArr.count
        }else{
            
            return 1
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(self.isDisCover == "yes") {
            //            var cnt = 0
            //            if section < soundsMainArr.count {
            //
            //                cnt = soundsMainArr[section].count
            //            }
            //
            //
            print("soundsMainArr[section]: ",soundsMainArr[section])
            print("cnt: ",soundsMainArr[section].count)
            return soundsMainArr[section].count
        }
        //        return self.Fav_Array.count
        return self.favSoundsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        //        if favSoundsArr.isEmpty || soundsMainArr.isEmpty{
        //            whoopsView.isHidden = false
        //        }else{
        //            whoopsView.isHidden = true
        //        }
        let cell:SoundTableViewCell = self.tablview.dequeueReusableCell(withIdentifier: "cell02") as! SoundTableViewCell
        
        cell.select_view.alpha = 0
        cell.select_btn.alpha = 0
        cell.btn_play.image = UIImage(named: "ic_play_icon.png")
        
        if(self.isDisCover == "yes"){
            //            let obj:Itemlist = sound_array[indexPath.section].listOfProducts[indexPath.row]
            
            let newObj = soundsMainArr[indexPath.section][indexPath.row]
            
            if newObj.favourite == "1"{
                cell.btnFav.setImage(UIImage(named: "btnFavFilled"), for: .normal)
            }else{
                cell.btnFav.setImage(UIImage(named:"btnFavEmpty"), for: .normal)
            }
            
            cell.sound_name.text = newObj.name
            cell.sound_type.text = newObj.description
            
            let imgThum = AppUtility?.detectURL(ipString: newObj.thum)
            cell.sound_img.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.sound_img.sd_setImage(with: URL(string:imgThum!), placeholderImage: UIImage(named:"noMusicIcon"))
            
            cell.btnFav.addTarget(self, action: #selector(AddSoundViewController.btnFavAction(_:)), for:.touchUpInside)
            
            //cell.btn_favourites.tag = [indexPath
            cell.btn_favourites.addTarget(self, action: #selector(AddSoundViewController.connected(_:)), for:.touchUpInside)
            
            
            cell.select_btn.addTarget(self, action: #selector(AddSoundViewController.connected1(_:)), for:.touchUpInside)
            
            cell.select_btn.tag = indexPath.row
            
            cell.btn_favourites.alpha = 1
            
            cell.innerview.layer.masksToBounds = false
            
            cell.innerview.layer.cornerRadius = 4
            cell.innerview.clipsToBounds = true
            
            cell.outerview.layer.masksToBounds = false
            
            cell.outerview.layer.cornerRadius = 4
            cell.outerview.clipsToBounds = true
            
            cell.select_view.layer.masksToBounds = false
            
            cell.select_view.layer.cornerRadius = 4
            cell.select_view.clipsToBounds = true
            
            
            
            return cell
        }else{
            
            //            let obj = self.Fav_Array[indexPath.row] as! FavSound
            let newObj = self.favSoundsArr[indexPath.row]
            cell.btnFav.setImage(UIImage(named: "btnFavFilled"), for: .normal)
            cell.sound_name.text = newObj.name
            cell.sound_type.text = newObj.description
            let imgThum = AppUtility?.detectURL(ipString: newObj.thum)
            cell.sound_img.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.sound_img.sd_setImage(with: URL(string:imgThum!), placeholderImage: UIImage(named:"noMusicIcon"))
            
            cell.btn_favourites.alpha = 0
            
            cell.innerview.layer.masksToBounds = false
            
            cell.innerview.layer.cornerRadius = 4
            cell.innerview.clipsToBounds = true
            
            cell.outerview.layer.masksToBounds = false
            
            cell.outerview.layer.cornerRadius = 4
            cell.outerview.clipsToBounds = true
            
            cell.select_view.layer.masksToBounds = false
            
            cell.select_view.layer.cornerRadius = 4
            cell.select_view.clipsToBounds = true
            
            cell.btnFav.addTarget(self, action: #selector(AddSoundViewController.btnFavAction(_:)), for:.touchUpInside)
            
            cell.select_btn.addTarget(self, action: #selector(AddSoundViewController.connected1(_:)), for:.touchUpInside)
            
            cell.select_btn.tag = indexPath.row
            
            
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.groupTableViewBackground
        
        let headerLabel = UILabel(frame: CGRect(x: 25, y: 5, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.font = UIFont(name: "Verdana", size: 14)
        headerLabel.textColor = UIColor.black
        headerLabel.text = self.tableView(self.tablview, titleForHeaderInSection: section)
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(self.isDisCover == "yes"){
            return 30
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = self.tablview.cellForRow(at: indexPath) as? SoundTableViewCell
        
        
        if(self.isDisCover == "yes"){
            
            
            //            let obj:Itemlist = sound_array[indexPath.section].listOfProducts[indexPath.row]
            
            let newObj = soundsMainArr[indexPath.section][indexPath.row]
            print("tag: ",cell?.btn_play.tag)
            
            if cell?.btn_play.tag == 1001 {
                
                
                cell?.btn_play.isHidden =  true
                cell?.loaderView.startAnimating()
                
                cell?.btn_play.image = UIImage(named: "ic_pause_icon.png")
                // cell!.btn_play.setBackgroundImage(UIImage(named: "ic_pause_icon"), for: .normal)
                
                cell?.btn_play.tag = 1002
                let url = newObj.audioURL
                let playerItem = AVPlayerItem( url:NSURL( string:url )! as URL )
                player = AVPlayer(playerItem:playerItem)
                
                player!.rate = 1.0;
                
                player!.play()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    print("done")
                    print("player.status: ",self.player.status)
                    cell?.loaderView.stopAnimating()
                    cell?.btn_play.isHidden =  false
                    cell?.select_view.alpha = 1
                    cell?.select_btn.alpha = 1
                })
                //                cell?.loaderView.stopAnimating()
                
                //                if player.isPlaying{
                //                    cell?.select_view.alpha = 1
                //                    cell?.select_btn.alpha = 1
                //                }else{
                //                    cell?.select_view.alpha = 0
                //                    cell?.select_btn.alpha = 0
                //                }
            }else{
                // cell!.btn_play.setBackgroundImage(UIImage(named: "ic_play_icon"), for: .normal)
                cell?.btn_play.tag = 1001
                cell?.btn_play.image = UIImage(named: "ic_play_icon.png")
                cell?.select_view.alpha = 0
                cell?.select_btn.alpha = 0
                
                player.pause()
            }
            
        }else{
            
            //            let obj = self.Fav_Array[indexPath.row] as! FavSound
            let newObj = self.favSoundsArr[indexPath.row]
            cell?.btnFav.setImage(UIImage(named: "btnFavFilled"), for: .normal)
            if cell?.btn_play.tag == 1001 {
                
                cell?.btn_play.image = UIImage(named: "ic_pause_icon")
                cell?.btn_play.tag = 1002
                let url = newObj.audioURL
                let playerItem = AVPlayerItem( url:NSURL( string:url )! as URL )
                player = AVPlayer(playerItem:playerItem)
                player!.rate = 1.0;
                
                print("player.status: ",player.status)
                
                
                //                cell?.select_view.alpha = 1
                //                cell?.select_btn.alpha = 1
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    print("done")
                    
                    cell?.loaderView.stopAnimating()
                    cell?.btn_play.isHidden =  false
                    cell?.select_view.alpha = 1
                    cell?.select_btn.alpha = 1
                })
                
                player!.play()
            }else{
                cell?.btn_play.image = UIImage(named: "ic_play_icon")
                cell?.btn_play.tag = 1001
                cell?.select_view.alpha = 0
                cell?.select_btn.alpha = 0
                player.pause()
            }
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = self.tablview.cellForRow(at: indexPath) as? SoundTableViewCell
        
        cell?.btn_play.image = UIImage(named: "ic_play_icon")
        cell?.btn_play.tag = 1001
        cell?.select_view.alpha = 0
        cell?.select_btn.alpha = 0
        cell?.loaderView.stopAnimating()
        
        player.pause()
        
        
        
    }
//    MARK:- PLAY AUDIO SETUP
    func playSound(soundUrl: String) {
        let sound = URL(fileURLWithPath: soundUrl)
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: sound)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        }catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    
    
    @objc func connected1(_ sender : UIButton) {
        print(sender.tag)
        
        //       self.loaderView.startAnimating()
        //        HomeViewController.displaySpinner(onView: self.view)
        //        let  sv = HomeViewController.displaySpinner(onView: self.view)
        AppUtility?.startLoader(view: self.view)
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tablview)
        let indexPath = self.tablview.indexPathForRow(at:buttonPosition)
        
        var moved = false
        
        if(self.isDisCover == "yes"){
            //            let obj:Itemlist = self.sound_array[indexPath!.section].listOfProducts[indexPath!.row]
            
            let newObj = soundsMainArr[indexPath!.section][indexPath!.row]
            
            UserDefaults.standard.set(newObj.audioURL, forKey: "url")
            UserDefaults.standard.set(newObj.name, forKey: "selectedSongName")
            
            print("obj.audio_path:- ",newObj.audioURL)
            
            //            UserDefaults.standard.set(obj.uid, forKey: "sid")
            
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
                        //                        self.loaderView.stopAnimating()
                        //                        HomeViewController.removeSpinner(spinner: sv)
                        AppUtility?.stopLoader(view: self.view)
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
                                //                                self.loaderView.stopAnimating()
                                //                                HomeViewController.removeSpinner(spinner: sv)
                                AppUtility?.stopLoader(view: self.view)
                                NotificationCenter.default.post(name: Notification.Name("loadAudio"), object: nil)
                                self.dismiss(animated: true, completion: nil)
                            }
                            
                            
                        } catch let error as NSError {
                            print(error.localizedDescription)
                        }
                        
                        //                        self.loaderView.removeFromSuperview()
                        AppUtility?.stopLoader(view: self.view)
                    }).resume()
                }
            }
        }else{
            
            //            let obj = self.Fav_Array[indexPath!.row] as! FavSound
            
            let newObj = self.favSoundsArr[indexPath!.row]
            
            UserDefaults.standard.set(newObj.audioURL, forKey: "url")
            //            UserDefaults.standard.set(newObj.sid, forKey: "sid")
            
            if let audioUrl = URL(string: newObj.audioURL) {
                
                // then lets create your document folder url
                let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                
                // lets create your destination file url
                let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
                print(destinationUrl)
                
                // to check if it exists before downloading it
                if FileManager.default.fileExists(atPath: destinationUrl.path) {
                    print("The file already exists at path")
                    //                    self.dismiss(animated:true, completion: nil)
                    // if the file doesn't exist
                } else {
                    
                    // you can use NSURLSession.sharedSession to download the data asynchronously
                    URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) -> Void in
                        guard let location = location, error == nil else { return }
                        do {
                            // after downloading your file you need to move it to your destination url
                            try FileManager.default.moveItem(at: location, to: destinationUrl)
                            print("File moved to documents folder")
                            
                            DispatchQueue.main.async {
                                //                                self.loaderView.stopAnimating()
                                //                                HomeViewController.removeSpinner(spinner: sv)
                                AppUtility?.stopLoader(view: self.view)
                                NotificationCenter.default.post(name: Notification.Name("loadAudio"), object: nil)
                                self.dismiss(animated: true, completion: nil)
                            }
                            
                            //                            self.dismiss(animated:true, completion: nil)
                        } catch let error as NSError {
                            print(error.localizedDescription)
                        }
                        
                        //                        self.loaderView.removeFromSuperview()
                        AppUtility?.stopLoader(view: self.view)
                    }).resume()
                }
            }
            
            
            AppUtility?.stopLoader(view: self.view)
        }
        
        
        // completionHandler(true)\
        //        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
        //            self.dismiss(animated:true, completion: nil)
        //            self.loaderView.stopAnimating()
        //        })
        //
        
        
        
    }
    
    func goBack(){
        self.dismiss(animated:true, completion: nil)
        self.loaderView.stopAnimating()
    }
    @objc func connected(_ sender : UIButton) {
        print(sender.tag)
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tablview)
        let indexPath = self.tablview.indexPathForRow(at:buttonPosition)
        let cell = self.tablview.cellForRow(at: indexPath!) as! SoundTableViewCell
        let obj:Itemlist = sound_array[indexPath!.section].listOfProducts[indexPath!.row]
        
        
        
        let url : String = self.appDelegate.baseUrl!+self.appDelegate.fav_sound!
        
        let parameter :[String:Any]? = ["fb_id":UserDefaults.standard.string(forKey: "uid")!,"sound_id":obj.uid!]
        
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
                
                
                print("Json:- ",json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! NSString
                if(code == "200"){
                    cell.btn_favourites.setBackgroundImage(UIImage(named:"7"), for: .normal)
                    
                }else{
                    
                    
                    
                }
                
                
                
            case .failure(let error):
                print(error)
            }
        })
    }
    
    @objc func btnFavAction(_ sender : UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tablview)
        let indexPath = self.tablview.indexPathForRow(at:buttonPosition)
        let cell = self.tablview.cellForRow(at: indexPath!) as! SoundTableViewCell
        
        
        if(self.isDisCover == "yes"){
            
            let newObj = soundsMainArr[indexPath!.section][indexPath!.row]
            
            let btnFavImg = cell.btnFav.currentImage
            
            if btnFavImg == UIImage(named: "btnFavEmpty"){
                cell.btnFav.setImage(UIImage(named: "btnFavFilled"), for: .normal)
            }else{
                cell.btnFav.setImage(UIImage(named: "btnFavEmpty"), for: .normal)
            }
            
            
            addFavSong(soundID: newObj.id, btnFav: cell.btnFav)
            print("btnFavImg: ",btnFavImg!)
        }else{
            
            if favSoundsArr.isEmpty == false{
                let newFavObj = favSoundsArr[indexPath!.row]
                let btnFavImg = cell.btnFav.currentImage
                
                if btnFavImg == UIImage(named: "btnFavEmpty"){
                    cell.btnFav.setImage(UIImage(named: "btnFavFilled"), for: .normal)
                }else{
                    cell.btnFav.setImage(UIImage(named: "btnFavEmpty"), for: .normal)
                }
                addFavSong(soundID: newFavObj.id, btnFav: cell.btnFav)
                newGetFavSounds()
            }
        }
    }
    //    @objc func connected1(_ sender : UIButton) {
    //        print(sender.tag)
    //
    //        let buttonPosition = sender.convert(CGPoint.zero, to: self.tablview)
    //        let indexPath = self.tablview.indexPathForRow(at:buttonPosition)
    //        let cell = self.tablview.cellForRow(at: indexPath!) as! SoundTableViewCell
    //        let obj:Itemlist = sound_array[indexPath!.section].listOfProducts[indexPath!.row]
    //
    //
    //        if cell.btn_play.currentBackgroundImage!.isEqual(UIImage(named: "ic_play_icon")) {
    //
    //     cell.btn_play.setBackgroundImage(UIImage(named: "ic_pause_icon"), for: .normal)
    //        let url = obj.audio_path!
    //        let playerItem = AVPlayerItem( url:NSURL( string:url )! as URL )
    //        player = AVPlayer(playerItem:playerItem)
    //        player!.rate = 1.0;
    //
    //        player!.play()
    //        }else{
    //            cell.btn_play.setBackgroundImage(UIImage(named: "ic_play_icon"), for: .normal)
    //            player.pause()
    //        }
    //
    //
    //    }
    
    @IBAction func cross(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func discover(_ sender: Any) {
        
        self.isDisCover = "yes"
        self.fav_view.alpha = 0
        self.soud_view.alpha = 1
        self.btn_discover.setTitleColor(UIColor.black, for: .normal)
        self.btn_favourite.setTitleColor(UIColor.lightGray, for: .normal)
        //        self.getSounds()
        self.newGetAllSounds(start: startingPoint)
        
        AppUtility?.startLoader(view: self.view)
    }
    
    @IBAction func favourite(_ sender: Any) {
        
        self.isDisCover = "no"
        self.fav_view.alpha = 1
        self.soud_view.alpha = 0
        self.btn_discover.setTitleColor(UIColor.lightGray, for: .normal)
        self.btn_favourite.setTitleColor(UIColor.black, for: .normal)
        //        self.getFavSounds()
        newGetFavSounds()
        AppUtility?.startLoader(view: self.view)
    }
    
    func alertModule(title:String,msg:String){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    //    Mark:- All sounds API
    func newGetAllSounds(start:String){
        AppUtility?.startLoader(view: self.view)
        soundsMainArr.removeAll()
        sectionsNamesArr.removeAll()
        ApiHandler.sharedInstance.showSounds(user_id: UserDefaults.standard.string(forKey: "userID")!, starting_point: start) { (isSuccess, response) in
            if isSuccess{
                if (response?.value(forKey: "code") as! NSNumber) == 200{
                    let msgDic = response?.value(forKey: "msg") as! NSDictionary
                    print("msgDic: ",msgDic.allKeys)
                    
                    var tempArr = [soundsMVC]()
                    
                    let allKeys = msgDic.allKeys
                    for key in allKeys{
                        
                        let keyString = key as! String
                        self.sectionsNamesArr.append(keyString)
                        
                        let objArr = msgDic.value(forKey: keyString) as! NSArray
                        
                        
                        for objDic in objArr{
                            
                            let soundDic = objDic as! NSDictionary
                            let obj = soundDic.value(forKey: "Sound") as! NSDictionary
                            
                            let id = obj.value(forKey: "id") as! String
                            let audioUrl = obj.value(forKey: "audio") as! String
                            let duration = obj.value(forKey: "duration") as! String
                            let name = obj.value(forKey: "name") as! String
                            let description = obj.value(forKey: "description") as! String
                            let thum = obj.value(forKey: "thum") as! String
                            let section = obj.value(forKey: "section") as! String
                            let uploaded_by = obj.value(forKey: "uploaded_by") as! String
                            let created = obj.value(forKey: "created") as! String
                            let favourite = obj.value(forKey: "favourite")
                            let publish = obj.value(forKey: "publish") as! String
                            
                            let soundObj = soundsMVC(id: id, audioURL: audioUrl, duration: duration, name: name, description: description, thum: thum, section: section, uploaded_by: uploaded_by, created: created, favourite: "\(favourite!)", publish: publish)
                            
                            print("soundObj: ",soundObj)
                            tempArr.append(soundObj)
                        }
                        self.soundsMainArr.append(tempArr)
                        tempArr.removeAll()
                    }
                    
                }else{
                    AppUtility?.stopLoader(view: self.view)
                    self.showToast(message: "!200", font: .systemFont(ofSize: 12))
                    print("!200: ",response?.value(forKey: "msg")!)
                }
                
                self.tablview.delegate = self
                self.tablview.dataSource = self
                self.tablview.reloadData()
            }else{
                AppUtility?.stopLoader(view: self.view)
            }
        }
        AppUtility?.stopLoader(view: self.view)
    }
    
    //    Mark:- Favorite sounds API
    func newGetFavSounds(){
        
        favSoundsArr.removeAll()
        
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
                        let section = soundObj.value(forKey: "section") as! String
                        let uploaded_by = soundObj.value(forKey: "uploaded_by") as! String
                        let created = soundObj.value(forKey: "created") as! String
                        //                        let favourite = soundObj.value(forKey: "favourite")
                        let publish = soundObj.value(forKey: "publish") as! String
                        
                        let obj = soundsMVC(id: id, audioURL: audioUrl, duration: duration, name: name, description: description, thum: thum, section: section, uploaded_by: uploaded_by, created: created, favourite: "", publish: publish)
                        
                        self.favSoundsArr.append(obj)
                    }
                    AppUtility?.stopLoader(view: self.view)
                    
                }else{
                    AppUtility?.stopLoader(view: self.view)
                    self.showToast(message: "Empty", font: .systemFont(ofSize: 12))
                    print("!200: ",response?.value(forKey: "msg")!)
                }
                
                self.tablview.delegate = self
                self.tablview.dataSource = self
                self.tablview.reloadData()
            }else{
                AppUtility?.stopLoader(view: self.view)
            }
        }
        
        AppUtility?.stopLoader(view: self.view)
    }
    
    func addFavSong(soundID:String,btnFav:UIButton){
        ApiHandler.sharedInstance.addSoundFavourite(user_id: UserDefaults.standard.string(forKey: "userID")!, sound_id: soundID) { (isSuccess, response) in
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200{
                    print("msg: ",response?.value(forKey: "msg")!)
                    
                    if btnFav.currentImage == UIImage(named: "btnFavEmpty"){
                        self.showToast(message: "Removed From Favorite", font: .systemFont(ofSize: 12))
                    }else{
                        self.showToast(message: "Added to Favorite", font: .systemFont(ofSize: 12))
                    }
                    
                }else{
                    self.showToast(message: "!200", font: .systemFont(ofSize: 12))
                }
            }
        }
    }
    
}

class Loader {
    
    enum Error: Swift.Error {
        case badURL
        case badData
        case other(Swift.Error)
    }
    
    public func loadSomeData(then block: @escaping(Result<String, Error>) -> Void) {
        let url = URL(string: "https://www.w3.org/TR/PNG/iso_8859-1.txt")!
        
        let task = URLSession.shared.downloadTask(with: url) { localURL, urlResponse, error in
            
            guard error == nil else {
                block(.failure(.other(error!)))
                return
            }
            
            guard let localURL = localURL else {
                block(.failure(.badURL))
                return
            }
            
            guard let string = try? String(contentsOf: localURL) else {
                block(.failure(.badData))
                return
            }
            
            block(.success(string))
        }
        
        task.resume()
    }
    
    
}
