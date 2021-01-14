//
//  postViewController.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 28/08/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation
import Photos
//import iOSDropDown

class postViewController: UIViewController,UITextViewDelegate {
    
    
    var videoUrl:URL?
    //    @IBOutlet weak var dropDownMenu: DropDown!
    @IBOutlet weak var privacyView: UIView!
    
    @IBOutlet weak var publicLabel: UILabel!
    @IBOutlet weak var privacyIconImg: UIImageView!
    @IBOutlet weak var vidThumbnail: UIImageView!
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var describeTextView: UITextView!
    
    
    var privacyType = "Public"
    var desc = ""
    var allowDuet = "1"
    var allowComments = "true"
    var duet = "1"
    var soundId = "null"
    var saveV = "1"
    
    var boxView = UIView()
    var blurView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("videoURL",videoUrl)
        describeTextView.text = "Describe your video"
        describeTextView.textColor = UIColor.lightGray
        
        let privayOpt = UITapGestureRecognizer(target: self, action:  #selector(self.privacyOptionsList))
        self.privacyView.addGestureRecognizer(privayOpt)
        self.getThumbnailImageFromVideoUrl(url: videoUrl!) { (thumb) in
            self.vidThumbnail.image = thumb
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
            textView.text = .none
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Describe your video"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func uploadData(){
        
        AppUtility?.startLoader(view: self.view)
        //        let  sv = HomeViewController.displaySpinner(onView: self.view)
        if(UserDefaults.standard.string(forKey: "sid") == nil || UserDefaults.standard.string(forKey: "sid") == ""){
            
            UserDefaults.standard.set("null", forKey: "sid")
        }
        
        //        let url : String = self.appDelegate.baseUrl!+self.appDelegate.uploadMultipartVideo!
        let url : String = ApiHandler.sharedInstance.baseApiPath+"postVideo"
        
        let cmnt = self.allowComments
        let allwDuet = self.allowDuet
        let prv = self.privacyType
        var des = self.desc
        if describeTextView.text != "Describe your video" {
            des = describeTextView.text
        }else{
            des = ""
        }
        
        print("cmnt",cmnt)
        print("allwDuet",allwDuet)
        print("prv",prv)
        print("des",des)
        
        let parameter :[String:Any]? = ["user_id":UserDefaults.standard.string(forKey: "userID")!,
                                        "sound_id":"null",
                                        "description":des,
                                        "privacy_type":prv,
                                        "allow_comments":cmnt,
                                        "allow_duet":allwDuet]
        
        let uidString = UserDefaults.standard.string(forKey: "userID")!
        let soundIDString = "null"
        
        print(url)
        //                   print(parameter!)
        let headers: HTTPHeaders = [
            "Api-Key":ApiHandler.sharedInstance.apiKey
        ]
        
        
        let serializer = DataResponseSerializer(emptyResponseCodes: Set([200, 204, 205]))
        AF.upload(multipartFormData: { MultipartFormData in
            
            for (key,value) in parameter! {
                MultipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
            }
            
            print("uidString: ",uidString)
            
            print("soundIDString: ",soundIDString)
            
            print("video url:-",self.videoUrl)
            do{
                let vid = try NSData(contentsOf: self.videoUrl!, options: .alwaysMapped)
                MultipartFormData.append(self.videoUrl!, withName: "video")
                
                print("vid: ",vid)
            }catch{
                print("catch err: ",error)
            }
            
        }, to: url, method: .post, headers: headers)
            .responseJSON { (response) in
                //                HomeViewController.removeSpinner(spinner: sv)
                //                AppUtility?.stopLoader(view: self.view)
                switch response.result{
                    
                case .success(let value):
                    
                    print("progress: ",Progress.current())
                    let json = value
                    let dic = json as! NSDictionary
                    
                    print("response:- ",response)
                    if(dic["code"] as! NSNumber == 200){
                        print("200")
                        debugPrint("SUCCESS RESPONSE: \(response)")
                        //                                UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
                        //                                // terminaing app in background
                        //                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        //exit(EXIT_SUCCESS)
                        
                        
                        if self.saveV == "1"{
                            self.saveVideoToAlbum(self.videoUrl!) { (err) in
                                
                                if err != nil{
                                    //                                    AppUtility?.stopLoader(view: self.view)
                                    print("Unable to save video to album dur to: ",err!)
                                    self.showToast(message: "Unable to save video to album dur to:", font: .systemFont(ofSize: 12))
                                }else{
                                    //                                    HomeViewController.removeSpinner(spinner: sv)
                                    
                                    print("video saved to gallery")
                                    self.showToast(message: "video saved to gallery", font: .systemFont(ofSize: 12))
                                }
                                
                            }
                        }
                        AppUtility?.stopLoader(view: self.view)
                        print("Dict: ",dic)
                        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                        // })
                        
                        
                    }else{
                        AppUtility?.stopLoader(view: self.view)
                        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                        print(dic)
                        
                    }
                case .failure(let error):
                    print("\n\n===========Error===========")
                    print("Error Code: \(error._code)")
                    print("Error Messsage: \(error.localizedDescription)")
                    if let data = response.data, let str = String(data: data, encoding: String.Encoding.utf8){
                        print("Server Error: " + str)
                    }
                    debugPrint(error as Any)
                    print("===========================\n\n")
                  //  self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
            //        AppUtility?.stopLoader(view: self.view)
               //     self.showToast(message: "Not Posted", font: .systemFont(ofSize: 12))
                }
                
        }
        .response(responseSerializer: serializer) { response in
            // Process response.
            switch response.result{
            case .success(let value):
                let json = value
                let dic = json as? NSDictionary
                let code = dic?["code"] as? NSString
                
                print("value: ",value)
                print("response",response)
                if(code == "200"){
                    print("200")
                    debugPrint("SUCCESS RESPONSE: \(response)")
                }else{
                    print("dic: ",dic)
                    
                }
                
                if self.saveV == "1"{
                    self.saveVideoToAlbum(self.videoUrl!) { (err) in
                        
                        if err != nil{
                            //                                    AppUtility?.stopLoader(view: self.view)
                            print("Unable to save video to album dur to: ",err!)
                            self.showToast(message: "Unable to save video to album dur to:", font: .systemFont(ofSize: 12))
                            AppUtility?.stopLoader(view: self.view)
                        }else{
                            //                                    HomeViewController.removeSpinner(spinner: sv)
                            
                            print("video saved to gallery")
                            self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                            AppUtility?.stopLoader(view: self.view)
//                            self.showToast(message: "video saved to gallery", font: .systemFont(ofSize: 12))
                        }
                        
                    }
                }
                
                
            case .failure(let error):
                print("\n\n===========Error===========")
                print("Error Code: \(error._code)")
                print("Error Messsage: \(error.localizedDescription)")
                if let data = response.data, let str = String(data: data, encoding: String.Encoding.utf8){
                    print("Server Error: " + str)
                }
                debugPrint(error as Any)
                print("===========================\n\n")
                
            }
        }
    }

    @IBAction func btnPost(_ sender: Any) {
        uploadData()
        //            saveVideo(withURL: videoUrl!)
    }
    
    
    
    
    @IBAction func commentSwitch(_ sender: UISwitch) {
        if sender.isOn {
            self.allowComments = "true"
        }else{
            self.allowComments = "false"
        }
    }
    
    @IBAction func duetSwitch(_ sender: UISwitch) {
        if sender.isOn {
            self.allowDuet = "1"
        }else{
            self.allowDuet = "0"
        }
    }
    
    @IBAction func saveSwitch(_ sender: UISwitch) {
        if sender.isOn {
            self.saveV = "1"
        }else{
            self.saveV = "0"
        }
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
        print("pressed")
    }
    
    //    MARK:- VIEWWILL APPEAR
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("selected row : ",UserDefaults.standard.integer(forKey: "selectRow"))
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("privTypeNC"), object: nil)
        
    }
    
    //    MARK:- UIVIEWS ACTIONS
    @objc func privacyOptionsList(sender : UITapGestureRecognizer) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "privacyVC") as! privacyViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
        
    }
    
    //    MARK:- CHANEGE PRIVACY INFO
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        if let type = notification.userInfo?["privType"] as? String {
            print("type: ",type)
            self.publicLabel.text = type
            self.privacyType = type
            
            switch type {
            case "Public":
                self.privacyIconImg.image = #imageLiteral(resourceName: "openLockIcon")
                UserDefaults.standard.set(0, forKey: "selectRow")
            case "Friends":
                self.privacyIconImg.image = #imageLiteral(resourceName: "30")
            case "Private":
                self.privacyIconImg.image = #imageLiteral(resourceName: "lockedLockIcon")
                UserDefaults.standard.set(1, forKey: "selectRow")
            default:
                self.privacyIconImg.image = #imageLiteral(resourceName: "openLockIcon")
                self.publicLabel.text = "Public"
                self.privacyType = "Public"
                UserDefaults.standard.set(0, forKey: "selectRow")
                //                UserDefaults.standard.set(0, forKey: "selection")
            }
        }
    }
    
    
    //    MARK:- SET VIDEO THUMBNAIL FUNC
    
    func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
        DispatchQueue.global().async { //1
            let asset = AVAsset(url: url) //2
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
            let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                let thumbNailImage = UIImage(cgImage: cgThumbImage) //7
                DispatchQueue.main.async { //8
                    completion(thumbNailImage) //9
                }
            } catch {
                print(error.localizedDescription) //10
                DispatchQueue.main.async {
                    completion(nil) //11
                }
            }
        }
    }
    
    //    MARK:- SAVE VIDEO DATA
    
    func requestAuthorization(completion: @escaping ()->Void) {
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization { (status) in
                DispatchQueue.main.async {
                    completion()
                }
            }
        } else if PHPhotoLibrary.authorizationStatus() == .authorized{
            completion()
        }
    }
    
    
    
    func saveVideoToAlbum(_ outputURL: URL, _ completion: ((Error?) -> Void)?) {
        requestAuthorization {
            PHPhotoLibrary.shared().performChanges({
                let request = PHAssetCreationRequest.forAsset()
                request.addResource(with: .video, fileURL: outputURL, options: nil)
            }) { (result, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("Saved VIDEO TO photos successfully")
                    }
                    completion?(error)
                }
            }
        }
    }
    
    func showShimmer(progress: String){
        
        //        boxView = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25, width: 180, height: 50))
        boxView = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 70, width: 180, height: 50))
        boxView.backgroundColor = UIColor.white
        boxView.alpha = 0.8
        boxView.layer.cornerRadius = 10
        
        //Here the spinnier is initialized
        let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        activityView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityView.startAnimating()
        
        let textLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        textLabel.textColor = UIColor.gray
        textLabel.text = progress
        
        blurView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.3)
        let blurView = UIView(frame: UIScreen.main.bounds)
        
        
        boxView.addSubview(blurView)
        boxView.addSubview(activityView)
        boxView.addSubview(textLabel)
        
        view.addSubview(boxView)
    }
    
    func HideShimmer(){
        
        boxView.removeFromSuperview()
    }
    
}

