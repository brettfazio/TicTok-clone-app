//
//  phoneNoViewController.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 12/10/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit
import PhoneNumberKit
import ContactsUI
import SKCountryPicker

class phoneNoViewController: UIViewController,UITextFieldDelegate,CNContactPickerDelegate {
    
//    @IBOutlet var phoneNoTxtField: PhoneNumberTextField!
    
    @IBOutlet var phoneNoTxtField: UITextField!
    
    @IBOutlet weak var emailContainerVIEW: UIView!
    @IBOutlet weak var emailSignupContainerVIEW: UIView!
    
    @IBOutlet weak var btnSendCode: UIButton!
    @IBOutlet weak var btnPhone: UIButton!
    @IBOutlet weak var btnEmail: UIButton!
    
    @IBOutlet weak var btnPhoneBottomView: UIView!
    @IBOutlet weak var btnEmailBottomView: UIView!
    
    @IBOutlet weak var btnCountryCode: UIButton!
    
    var dialCode = "+92"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailContainerVIEW.isHidden =  true
        emailSignupContainerVIEW.isHidden = true
        
        btnSendCode.backgroundColor = #colorLiteral(red: 0.9528577924, green: 0.9529947639, blue: 0.9528278708, alpha: 1)
        btnSendCode.setTitleColor(#colorLiteral(red: 0.6437677741, green: 0.6631219387, blue: 0.6758852601, alpha: 1), for: .normal)
        btnSendCode.isUserInteractionEnabled = false
        btnEmailBottomView.isHidden = true
        
//        phoneNoTxtFieldSetup()
        phoneNoTxtField.addTarget(self, action: #selector(phoneNoViewController.textFieldDidChange(_:)), for: .editingChanged)        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.countryDataNoti(_:)), name: NSNotification.Name(rawValue: "countryDataNoti"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("pauseSongNoti"), object: nil)


    }
    
    @objc func countryDataNoti(_ notification: NSNotification) {

//      if let image = notification.userInfo?["image"] as? UIImage {
//      // do something with your image
//      }
        
        print("notification.userInfo: ",notification.userInfo?["name"] )
        
        let newDialCode = notification.userInfo?["dial_code"] as! String
        let code = notification.userInfo?["code"] as! String
        
        self.dialCode = newDialCode
        btnCountryCode.setTitle("\(code) \(newDialCode)", for: .normal)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        let textCount = textField.text?.count
        
        print("change textCount: ",textCount)
        if textCount! > 0{
            btnSendCode.backgroundColor = #colorLiteral(red: 0.9847028852, green: 0.625120461, blue: 0.007359095383, alpha: 1)
            btnSendCode.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            btnSendCode.isUserInteractionEnabled = true
        }else{
            btnSendCode.backgroundColor = #colorLiteral(red: 0.9528577924, green: 0.9529947639, blue: 0.9528278708, alpha: 1)
            btnSendCode.setTitleColor(#colorLiteral(red: 0.6437677741, green: 0.6631219387, blue: 0.6758852601, alpha: 1), for: .normal)
            btnSendCode.isUserInteractionEnabled = false
        }
    }
    
    /*
    func phoneNoTxtFieldSetup(){
//        self.phoneNoTxtField.becomeFirstResponder()
//        self.phoneNoTxtField.text = "+92000000000"
        self.phoneNoTxtField.placeholder = "+92000000000"
        self.phoneNoTxtField.withPrefix = true
        self.phoneNoTxtField.withFlag = true
        self.phoneNoTxtField.withExamplePlaceholder = true
//        self.phoneNoTxtField.i
        if #available(iOS 11.0, *) {
            self.phoneNoTxtField.withDefaultPickerUI = true
        }
        

    }
    
    */
    
    
    @IBAction func btnSendCodeAction(_ sender: Any) {
        
        UserDefaults.standard.set("phoneSignup", forKey: "signUpType")
        
        print("phone no. ",self.dialCode+phoneNoTxtField.text!)
        
        if AppUtility?.isValidPhoneNumber(strPhone: self.dialCode+phoneNoTxtField.text!) == true{
            self.verifyPhoneFunc()
        }else{
            showToast(message: "Invalid Number", font: .systemFont(ofSize: 12))
        }
        
        /*
        if phoneNoTxtField.isValidNumber == true {
            verifyPhoneFunc()
        }else{
            showToast(message: "Invalid Number", font: .systemFont(ofSize: 12))
        }
         */
    }
    
    @IBAction func btnPhoneAction(_ sender: Any) {
        
        btnEmailBottomView.isHidden = true
        btnEmail.setTitleColor(.black, for: .normal)
        emailContainerVIEW.isHidden = true
        emailSignupContainerVIEW.isHidden = true
        
        btnPhoneBottomView.isHidden = false
        btnPhone.setTitleColor(#colorLiteral(red: 0.9847028852, green: 0.625120461, blue: 0.007359095383, alpha: 1), for: .normal)
        
        
    }
    @IBAction func btnEmailAction(_ sender: Any) {
        btnPhoneBottomView.isHidden = true
        btnPhone.setTitleColor(.black, for: .normal)
        
        print(UserDefaults.standard.string(forKey: "signUpType"))
        
        if UserDefaults.standard.string(forKey: "signUpType") == "emailSignup"{
            emailSignupContainerVIEW.isHidden = false
        }else{
            emailContainerVIEW.isHidden = false
        }
        
        btnEmailBottomView.isHidden = false
        btnEmail.setTitleColor(#colorLiteral(red: 0.9847028852, green: 0.625120461, blue: 0.007359095383, alpha: 1), for: .normal)
        
    }
    
//    MARK:- BTN COUNTRY CODE ACTION
    @IBAction func btnCountryCode(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "countryCodeVC") as! countryCodeViewController
        present(vc, animated: true, completion: nil)
        
    }
    func verifyPhoneFunc(){
        
        let phoneNo = self.dialCode+phoneNoTxtField.text!
        print("phoneNo: ",phoneNo)
        AppUtility?.startLoader(view: self.view)
        ApiHandler.sharedInstance.verifyPhoneNo(phone: phoneNo, verify: "0") { (isSuccess, response) in
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    AppUtility?.stopLoader(view: self.view)
                  //  self.alertModule(title: NSLocalizedString("alert_app_name", comment: ""), msg: response?.value(forKey: "msg") as! String )
                    print("respone: ",response?.value(forKey: "msg") as! String)
                    if #available(iOS 12.0, *) {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "otpVC") as! otpViewController
                        vc.phoneNo = self.dialCode+self.phoneNoTxtField.text!
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        // Fallback on earlier versions
                        print("iOS is not 12.0, *")
                    }
                    
                }else{
                    AppUtility?.stopLoader(view: self.view)
                    self.alertModule(title: NSLocalizedString("alert_app_name", comment: ""), msg: response?.value(forKey: "msg") as! String)
                }
            }else{
                AppUtility?.stopLoader(view: self.view)
                self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12.0))
            }
        }
    }
    
        //    MARK:- Terms & privacy
        @IBAction func privacy(_ sender: Any) {
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "termsCondVC") as! termsCondViewController
            vc.privacyDoc = true
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
    //        guard let url = URL(string: "https://termsfeed.com/privacy-policy/9a03bedc2f642faf5b4a91c68643b1ae") else { return }
    //        UIApplication.shared.open(url)
        }
        
        @IBAction func terms(_ sender: Any) {
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "termsCondVC") as! termsCondViewController
            vc.privacyDoc = false
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
            
    //        guard let url = URL(string: "https://termsfeed.com/terms-conditions/72b8fed5b38e082d48c9889e4d1276a9") else { return }
    //        UIApplication.shared.open(url)
            
        }
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnTest(_ sender: Any) {
       let countryController = CountryPickerWithSectionViewController.presentController(on: self)
       { [weak self] (country: Country) in
           
           if let self = self
           {
//               self.countryImage.image = country.flag
//               self.lblCountryCode.text = "\(country.dialingCode!)"
            
            print("country.dialingCode!: ",country.dialingCode!)
           }
           else
           {
               return
           }
           
       }
       // can customize the countryPicker here e.g font and color
       countryController.detailColor = #colorLiteral(red: 0.9568627451, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
        countryController.detailFont.withSize(9.0)
        countryController.labelFont.withSize(9.0)
        countryController.flagStyle = .circular
    }
    
    //    MARK:- ALERT MODULE
    func alertModule(title:String,msg:String){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
        
    }

}
