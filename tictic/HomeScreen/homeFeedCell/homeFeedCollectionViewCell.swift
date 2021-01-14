//
//  homeFeedCollectionViewCell.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 01/10/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit
import GSPlayer
import MarqueeLabel
import DSGradientProgressView
import Lottie
import SnapKit

class homeFeedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var playerView: VideoPlayerView!
    
    @IBOutlet weak var btnLike: UIImageView!
    @IBOutlet weak var btnShare: UIImageView!
    @IBOutlet weak var btnComment: UIImageView!
    
    @IBOutlet weak var lblLike: UILabel!
    @IBOutlet weak var lblShare: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    
    @IBOutlet weak var playerCD: UIImageView!
    
    @IBOutlet weak var txtDesc: UILabel!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var verifiedUserImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var musicName: MarqueeLabel!
    
    @IBOutlet weak var optionsStackView: UIStackView!
    
    @IBOutlet weak var progressView: DSGradientProgressView!
    
    @IBOutlet weak var btnPlayImg: UIImageView!
    
    private var url: URL!
    
    @IBOutlet weak var btnFollow: UIButton!
    
    var heartAnimationView : AnimationView?
    
    var isLiked = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        btnPlayImg.isHidden = true
        
        playerView.contentMode = .scaleAspectFill
        
        userImg.makeRounded()
        playerView.stateDidChanged = { state in
            switch state {
            case .none:
                print("none")
            case .error(let error):
                
                print("error - \(error.localizedDescription)")
                self.progressView.wait()
                self.progressView.isHidden = false
                
                NotificationCenter.default.post(name: Notification.Name("errInPlay"), object: nil, userInfo: ["err":error.localizedDescription])
                
            case .loading:
                print("loading")
                self.progressView.wait()
                self.progressView.isHidden = false
            case .paused(let playing, let buffering):
                print("paused - progress \(Int(playing * 100))% buffering \(Int(buffering * 100))%")
                self.progressView.signal()
                self.progressView.isHidden = true
                self.playerCD.stopRotating()
            case .playing:
                self.btnPlayImg.isHidden = true
                self.progressView.isHidden = true
                self.playerCD.startRotating()
                
                print("playing")
            }
        }
        
        print("video Pause Reason: ",playerView.pausedReason )
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playerView.isHidden = true
    }
    
    func set(url: URL) {
        self.url = url
    }
    
    func play() {
        playerView.play(for: url)
        playerView.isHidden = false
    }
    
    func pause() {
        playerView.pause(reason: .hidden)
    }
    
    func like(){
        heartAnimationView?.backgroundColor = .clear
        heartAnimationView = .init(name: "lottieHeart")
        //                heartAnimationView?.frame = btnLike.frame
        heartAnimationView?.animationSpeed = 1
        //        heartAnimationView?.loopMode = .loop
        heartAnimationView?.sizeToFit()
        btnLike.addSubview(heartAnimationView!)
        
        heartAnimationView?.snp.makeConstraints({ (mkr) in
            mkr.center.equalTo(btnLike)
        })
        
        heartAnimationView?.play(fromFrame: 13, toFrame: 60, loopMode: .none, completion: { (bol) in
            //            self.heartAnimationView?.play(toFrame: 23)
        })
        isLiked = true
        
    }
    func unlike(){
        heartAnimationView?.backgroundColor = .clear
        
        heartAnimationView?.play(fromFrame: 60, toFrame: 13, loopMode: .none, completion: { (bol) in
            self.heartAnimationView?.removeFromSuperview()
        })
        isLiked = false
        
    }
    
    func alreadyLiked(){
        
        heartAnimationView?.removeFromSuperview()
        heartAnimationView?.backgroundColor = .clear
        heartAnimationView = .init(name: "lottieHeart")
        //        heartAnimationView?.frame = btnLike.frame
        
        //        heartAnimationView?.loopMode = .loop
        heartAnimationView?.sizeToFit()
        btnLike.addSubview(heartAnimationView!)
        
        heartAnimationView?.snp.makeConstraints({ (mkr) in
            mkr.center.equalTo(btnLike)
        })
        //self.heartAnimationView?.removeFromSuperview()
        self.heartAnimationView?.currentFrame = 60
        isLiked = true
        
    }
    
}
extension UIImageView {
    
    func makeRounded() {
        
        //        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        //        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
extension UIView {
    func startRotating(duration: Double = 3) {
        let kAnimationKey = "rotation"
        
        if self.layer.animation(forKey: kAnimationKey) == nil {
            let animate = CABasicAnimation(keyPath: "transform.rotation")
            animate.duration = duration
            animate.repeatCount = Float.infinity
            animate.fromValue = 0.0
            animate.toValue = Float(M_PI * 2.0)
            self.layer.add(animate, forKey: kAnimationKey)
        }
    }
    func stopRotating() {
        let kAnimationKey = "rotation"
        
        if self.layer.animation(forKey: kAnimationKey) != nil {
            self.layer.removeAnimation(forKey: kAnimationKey)
        }
    }
    
    
}
