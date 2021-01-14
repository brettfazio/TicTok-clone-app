//
//  AsyncPhotoMediaItem.swift
//  Jalebi
//
//  Created by Junaid Kamoka on 10/29/18.
//  Copyright © 2018 Junaid Kamoka. All rights reserved.
//

import Foundation
import JSQMessagesViewController
import Kingfisher


class AsyncPhotoMediaItem: JSQPhotoMediaItem {
    var asyncImageView: UIImageView!
    
    override init!(maskAsOutgoing: Bool) {
        super.init(maskAsOutgoing: maskAsOutgoing)
    }
    
    init(withURL url: URL) {
        super.init()
        asyncImageView = UIImageView()
        asyncImageView.frame = CGRect(x: 0, y: 0, width: 170, height: 130)
        asyncImageView.contentMode = .scaleAspectFill
        asyncImageView.clipsToBounds = true
        asyncImageView.layer.cornerRadius = 20
        asyncImageView.backgroundColor = UIColor.init(red:255/255.0, green:101/255.0, blue:96/255.0, alpha: 1.0)
       
        
        let activityIndicator = JSQMessagesMediaPlaceholderView.withActivityIndicator()
        activityIndicator?.frame = asyncImageView.frame
        asyncImageView.addSubview(activityIndicator!)
        
        
        KingfisherManager.shared.cache.retrieveImage(forKey: url.absoluteString, options: nil) { (image, cacheType) -> () in
            
            if let image = image {
                self.asyncImageView.image = image
                activityIndicator?.removeFromSuperview()
            } else {
              
                KingfisherManager.shared.downloader.downloadImage(with: url , progressBlock: nil) { (image, error, imageURL, originalData) -> () in
                    
                    if let image = image {
                        self.asyncImageView.image = image
                        activityIndicator?.removeFromSuperview()
                        KingfisherManager.shared.cache.store(image, forKey: url.absoluteString)
                        
                    }else{
                        activityIndicator?.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    override func mediaView() -> UIView! {
        return asyncImageView
    }
    
    override func mediaViewDisplaySize() -> CGSize {
        return asyncImageView.frame.size
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

