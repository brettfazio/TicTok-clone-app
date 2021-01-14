//
//  homecollCell.swift
//  TIK TIK
//
//  Created by Junaid Kamoka on 25/04/2019.
//  Copyright © 2019 Junaid Kamoka. All rights reserved.
//

import UIKit
import AVKit
import DSGradientProgressView
import MarqueeLabel


class homecollCell: UICollectionViewCell {
    
    @IBOutlet weak var progressView: DSGradientProgressView!
    @IBOutlet weak var playerView: UIView!
    var player:AVPlayer? = nil
    var playerItem:AVPlayerItem? = nil
    var playerLayer:AVPlayerLayer? = nil
    @IBOutlet weak var playBtn: UIButton!
    
    @IBOutlet weak var other_profile: UIButton!
    
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var inner_view: UIView!
    
    
    @IBOutlet weak var btn_like: UIButton!
    
    @IBOutlet weak var btnshare: UIButton!
    
    @IBOutlet weak var btn_comments: UIButton!
    
    @IBOutlet weak var txt_desc: UILabel!
    
    @IBOutlet weak var user_view: UIView!
    
    @IBOutlet weak var user_img: UIImageView!
    
    @IBOutlet weak var user_name: UILabel!
    
    @IBOutlet weak var music_name: MarqueeLabel!
    
    @IBOutlet weak var musicBottomConstrtraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()

       //do some work here that needs to happen only once, you don’t wanna change them later.

        
    }
    
        
    //    MARK:- DEVICE CHECKS
        func devicesChecks(){
            if DeviceType.iPhoneWithHomeButton{
                
                bottomConstraint?.constant = 10
                

            }
            
        
        }
    
   
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        self.playerItem = nil
        self.playerLayer?.removeFromSuperlayer()
        

        
       
    }
    
    
    
    
    
}
