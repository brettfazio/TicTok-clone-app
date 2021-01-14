//
//  previewPlayerViewController.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 22/08/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit
import Player
import Alamofire
import GSPlayer
import DSGradientProgressView

class previewPlayerViewController: UIViewController,PlayerDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    var url:URL?
    fileprivate var player = Player()
    
    @IBOutlet weak var playerView: VideoPlayerView!
    @IBOutlet weak var progressView: DSGradientProgressView!
    @IBOutlet weak var btnPlayImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        playerView.contentMode = .scaleToFill
        
        print("url: ",url!)
        
        view.bringSubviewToFront(btnBack)
        self.player = Player()
        self.player.playerDelegate = self as PlayerDelegate
        //        self.player.playbackDelegate = self as! PlayerPlaybackDelegate
        
        self.player.view.frame = self.view.bounds
        
        self.addChild(self.player)
        self.view.addSubview(self.player.view)
        player.view.snp.makeConstraints { (mk) in
            mk.center.equalTo(view)
            mk.width.height.equalTo(view)
        }
        self.player.didMove(toParent: self)
        self.view.sendSubviewToBack(player.view)
        self.player.url = url
        
        self.player.playbackLoops = true
        
        player.view.contentMode = .scaleAspectFill
        */
        // Do any additional setup after loading the view.
        playerSetup()
    }
    
    func playerSetup(){
        
        btnPlayImg.isHidden = true
        
        playerView.contentMode = .scaleAspectFill
        playerView.play(for: url!)
        playerView.stateDidChanged = { state in
            switch state {
            case .none:
                print("none")
            case .error(let error):
                
                print("error - \(error.localizedDescription)")
                self.progressView.wait()
                self.progressView.isHidden = false

            case .loading:
                print("loading")
                self.progressView.wait()
                self.progressView.isHidden = false
            case .paused(let playing, let buffering):
                print("paused - progress \(Int(playing * 100))% buffering \(Int(buffering * 100))%")
                self.progressView.signal()
                self.progressView.isHidden = true
            case .playing:
                self.btnPlayImg.isHidden = true
                self.progressView.isHidden = true
                
                print("playing")
            }
        }
        
        print("video Pause Reason: ",playerView.pausedReason )
        
        
    }
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
        print("pressed")
    }
    @IBAction func btnNext(_ sender: Any) {
        print("next pressed")
        playerView.pause(reason: .hidden)
        //        saveVideo(withURL: url!)
        let vc = storyboard?.instantiateViewController(withIdentifier: "postVC") as! postViewController
        vc.videoUrl = url
        vc.modalPresentationStyle = .fullScreen
        UserDefaults.standard.set("Public", forKey: "privOpt")
        
        self.present(vc, animated: true, completion: nil)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
////        self.player.url = url
////        self.player.playFromBeginning()
//
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.playerView.play(for: url!)
        self.playerView.resume()
    }
    override func viewDidDisappear(_ animated: Bool) {
//        self.player.stop()
        playerView.pause(reason: .hidden)

    }
    
    func playerReady(_ player: Player) {
        print("playerReady")
        
    }
    
    func playerPlaybackStateDidChange(_ player: Player) {
        
    }
    
    func playerBufferingStateDidChange(_ player: Player) {
        
    }
    
    func playerBufferTimeDidChange(_ bufferTime: Double) {
    }
    
    func player(_ player: Player, didFailWithError error: Error?) {
        
    }
    
    internal func saveVideo(withURL url: URL) {
        let  sv = HomeViewController.displaySpinner(onView: self.view)
        
        let imageData:NSData = NSData.init(contentsOf: url)!
        
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        if(UserDefaults.standard.string(forKey: "sid") == nil || UserDefaults.standard.string(forKey: "sid") == ""){
            
            UserDefaults.standard.set("null", forKey: "sid")
        }
        
        let url : String = self.appDelegate.baseUrl!+self.appDelegate.uploadVideo!
        
        let parameter :[String:Any]? = ["fb_id":UserDefaults.standard.string(forKey: "uid")!,"videobase64":["file_data":strBase64],"sound_id":"null","description":"xyz","privacy_type":"Public","allow_comments":"true","allow_duet":"1","video_id":"009988"]
        
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
                print("json: ",json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! NSString
                if(code == "200"){
                    
                    //                                UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
                    //                                // terminaing app in background
                    //                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    //exit(EXIT_SUCCESS)
                    print("Dict: ",dic)
                    self.dismiss(animated:true, completion: nil)
                    // })
                    
                }else{
                    
                    
                }
                
            case .failure(let error):
                HomeViewController.removeSpinner(spinner: sv)
                print(error)
            }
        })
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
//        player.stop()
        playerView.pause(reason: .hidden)
        
    }
}
