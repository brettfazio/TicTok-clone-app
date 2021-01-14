//
//  ImagePreviewViewController.swift
//  e-EBM
//
//  Created by Arslan on 05/08/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import UIKit
import SDWebImage

class ImagePreviewViewController: UIViewController, UIScrollViewDelegate
{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    var imgUrl = String()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("imgUrl: ",imgUrl)
        
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imageView.sd_setImage(with: URL(string:imgUrl), placeholderImage: UIImage(named: "videoPlaceholder"))
        
        scrollView.maximumZoomScale = 4
        scrollView.minimumZoomScale = 1
        
        scrollView.delegate = self
        
        let doubleTapGest = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapScrollView(recognizer:)))
        doubleTapGest.numberOfTapsRequired = 2
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(doubleTapGest)
    }
    
    //MARK:- Button Actions
    @IBAction func btnDoneActiion(_ sender: UIButton)
    {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- tap gesture
    @objc func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer)
    {
        if scrollView.zoomScale == 1
        {
            scrollView.zoom(to: zoomRect(scale: scrollView.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        }
        else
        {
            scrollView.setZoomScale(1, animated: true)
        }
    }
    
    func zoomRect(scale: CGFloat, center: CGPoint) -> CGRect
    {
        var zoomRect = CGRect.zero
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    //MARK:- scrollView delegates
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1 {
            if let image = imageView.image {
                let ratioW = imageView.frame.width / image.size.width
                let ratioH = imageView.frame.height / image.size.height
                
                let ratio = ratioW < ratioH ? ratioW : ratioH
                let newWidth = image.size.width * ratio
                let newHeight = image.size.height * ratio
                let conditionLeft = newWidth*scrollView.zoomScale > imageView.frame.width
                let left = 0.5 * (conditionLeft ? newWidth - imageView.frame.width : (scrollView.frame.width - scrollView.contentSize.width))
                let conditioTop = newHeight*scrollView.zoomScale > imageView.frame.height
                
                let top = 0.5 * (conditioTop ? newHeight - imageView.frame.height : (scrollView.frame.height - scrollView.contentSize.height))
                
                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
                
            }
        } else {
            scrollView.contentInset = .zero
        }
    }
    
}
