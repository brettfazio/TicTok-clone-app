//
//  reportDetailViewController.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 10/11/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit

class reportDetailViewController: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var reportView: UIView!
    
    @IBOutlet weak var reportTitle: UILabel!
    @IBOutlet weak var reportDescTF: UITextField!
    
    var reportTiltleText = ""
    var reportID = ""
    var videoID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitButton.layer.cornerRadius = 3.0
        
        let bottomBorder = CALayer()
        bottomBorder.borderColor = #colorLiteral(red: 0.8352941176, green: 0.8352941176, blue: 0.8352941176, alpha: 1);
        bottomBorder.borderWidth = 0.5;
        bottomBorder.frame = CGRect(x: 0, y: topView.frame.height, width: view.frame.width, height: 1)
        topView.layer.addSublayer(bottomBorder)
        
        let Border = CALayer()
        Border.borderColor = #colorLiteral(red: 0.8352941176, green: 0.8352941176, blue: 0.8352941176, alpha: 1);
        Border.borderWidth = 0.5;
        Border.frame = CGRect(x: 0, y: reportView.frame.height, width: view.frame.width, height: 1)
        reportView.layer.addSublayer(Border)
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(report(tapGestureRecognizer:)))
        reportView.isUserInteractionEnabled = true
        reportView.addGestureRecognizer(tapGestureRecognizer)
        
        reportTitle.text = reportTiltleText
    }
    
    //MARK:-ACTION
    
    @objc func report(tapGestureRecognizer: UITapGestureRecognizer)
    {
        // Your action
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        
        let desc = reportDescTF.text
         
         reportVideo(reportReason: desc!)
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
            dismiss(animated: true, completion: nil)
    }
    
    //    MARK:- Report video func
    func reportVideo(reportReason: String){
        AppUtility?.startLoader(view: self.view)
        ApiHandler.sharedInstance.reportVideo(user_id: UserDefaults.standard.string(forKey: "userID")!, video_id: videoID, report_reason_id: reportID, description: reportReason) { (isSuccess, response) in
            if isSuccess{
                AppUtility?.stopLoader(view: self.view)
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    self.showToast(message: "Report Under Review", font: .systemFont(ofSize: 12))
                    self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                }else{
                    self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                }
            }else{
                AppUtility?.stopLoader(view: self.view)
            }
        }
    }
    
    
}
