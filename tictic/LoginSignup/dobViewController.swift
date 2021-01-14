//
//  dobViewController.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 12/10/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class dobViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var dobDatePicker: UIDatePicker!
    @IBOutlet weak var btnNext: UIButton!
    
    var dob = ""
    var phoneNo = ""
    
    var email = ""
    var pass = ""
    
    var socialEmail = ""
    var socialID = ""
    var authToken = ""
    var firstName = ""
    var lastName = ""
    var socialUserName = ""
    var socialSignUpType = ""
    
    let fromVC = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnNext.backgroundColor = #colorLiteral(red: 0.5750417709, green: 0.5841686726, blue: 0.6059108973, alpha: 1)
        btnNext.isUserInteractionEnabled = false
        
        dobSetup()
        
    }
    
    func dobSetup(){
        dobDatePicker.addTarget(self, action: #selector(dobDateChanged(_:)), for: .valueChanged)
        dobDatePicker.maximumDate = Date()
    }
    @objc func dobDateChanged(_ sender: UIDatePicker) {
        /*
         let components = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
         */
        sender.datePickerMode = UIDatePicker.Mode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let selectedDate = dateFormatter.string(from: sender.date)
        print("selectedDate",selectedDate)
        
        self.dob = selectedDate
        let textCount = self.dob.count
        if textCount > 0{
            btnNext.backgroundColor = #colorLiteral(red: 0.9847028852, green: 0.625120461, blue: 0.007359095383, alpha: 1)
            btnNext.isUserInteractionEnabled = true
        }else{
            btnNext.backgroundColor = #colorLiteral(red: 0.5750417709, green: 0.5841686726, blue: 0.6059108973, alpha: 1)
            btnNext.isUserInteractionEnabled = false
        }
        
        NotificationCenter.default.post(name: Notification.Name("dobNoti"), object: selectedDate)
//        self.UpdatePasswordAPI()
//        dismiss(animated: true, completion: nil)
        
        print("date: ",sender.date)
    }
    
    @IBAction func btnNext(_ sender: Any) {
        if dob.isEmpty == true{
            showToast(message: "Select Date", font: .systemFont(ofSize: 12))
        }else{
            let vc = storyboard?.instantiateViewController(withIdentifier: "nameVC") as! nameViewController
            vc.dob = self.dob
            vc.phoneNo = self.phoneNo
            vc.email = self.email
            vc.pass = self.pass
            
            vc.socialEmail = self.socialEmail
            vc.firstName = self.firstName
            vc.lastName = self.lastName
            vc.authToken = self.authToken
            vc.socialUserName = self.socialUserName
            vc.socialID = self.socialID
            vc.socialSignUpType = self.socialSignUpType
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnSkip(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "nameVC") as! nameViewController
        vc.dob = self.dob
        vc.phoneNo = self.phoneNo
        vc.email = self.email
        vc.pass = self.pass
        
        vc.socialEmail = self.socialEmail
        vc.firstName = self.firstName
        vc.lastName = self.lastName
        vc.authToken = self.authToken
        vc.socialUserName = self.socialUserName
        vc.socialID = self.socialID
        vc.socialSignUpType = self.socialSignUpType
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
}
