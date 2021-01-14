//
//  editProfileViewController.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 20/11/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit
import SDWebImage
class editProfileViewController: UIViewController {
    
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var genderView: UIView!
    @IBOutlet weak var websiteView: UIView!
    @IBOutlet weak var bioView: UIView!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var editPhotoIcon: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var nameTF: CustomTextField!
    @IBOutlet weak var second_nameTF: CustomTextField!
    @IBOutlet weak var first_nameTF: CustomTextField!
    
    
    @IBOutlet weak var selectedbtn: UIButton!
    @IBOutlet weak var unselectedbtn: UIButton!
    
    @IBOutlet weak var websiteTF: CustomTextField!
    @IBOutlet weak var bioTF: CustomTextField!
    
    var userData = [userMVC]()
    
    var profilePicData = ""
    var isMale = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenSetup()
        
        let bottomBorder = CALayer()
        bottomBorder.borderColor = #colorLiteral(red: 0.8352941176, green: 0.8352941176, blue: 0.8352941176, alpha: 1);
        bottomBorder.borderWidth = 0.5;
        bottomBorder.frame = CGRect(x: 0, y: topView.frame.height, width: view.frame.width, height: 1)
        topView.layer.addSublayer(bottomBorder)
        
        
        let Border = CALayer()
        Border.borderColor = #colorLiteral(red: 0.9137254902, green: 0.9137254902, blue: 0.9137254902, alpha: 1);
        Border.borderWidth = 0.5;
        Border.frame = CGRect(x: 0, y: genderView.frame.height, width: genderView.frame.width, height: 1)
        genderView.layer.addSublayer(Border)
        
        
        let bo = CALayer()
        bo.borderColor = #colorLiteral(red: 0.8352941176, green: 0.8352941176, blue: 0.8352941176, alpha: 1);
        bo.borderWidth = 0.5;
        bo.frame = CGRect(x: 0, y: websiteView.frame.height, width: websiteView.frame.width, height: 1)
        websiteView.layer.addSublayer(bo)
        
        
        let bottom = CALayer()
        bottom.borderColor = #colorLiteral(red: 0.8352941176, green: 0.8352941176, blue: 0.8352941176, alpha: 1);
        bottom.borderWidth = 0.5;
        bottom.frame = CGRect(x: 0, y: bioView.frame.height, width: bioView.frame.width, height: 1)
        bioView.layer.addSublayer(bottom)
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImage(tapGestureRecognizer:)))
        editPhotoIcon.isUserInteractionEnabled = true
        editPhotoIcon.addGestureRecognizer(tapGestureRecognizer)
        
        
    }
    
    
    //MARK:- ACTION
    
    @objc func profileImage(tapGestureRecognizer: UITapGestureRecognizer)
    {
        // Your action
        ImagePickerManager().pickImage(self){ image in
            //here is the image

            self.profilePicData = (image.jpegData(compressionQuality: 0.1)?.base64EncodedString())!
            print("profilePicData: ",self.profilePicData)
            
            self.addUserImgAPI()
            
        }
    }
    
    func screenSetup(){
        
        let userObj = userData[0]
        self.profileImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.profileImage.sd_setImage(with: URL(string:(AppUtility?.detectURL(ipString: userObj.userProfile_pic))!), placeholderImage: UIImage(named:"noUserImg"))
        
        self.nameTF.text = userObj.username
        self.first_nameTF.text = userObj.first_name
        self.second_nameTF.text = userObj.last_name
        self.bioTF.text = userObj.bio
        self.websiteTF.text = userObj.website
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        addProfileDataAPI()
    }
    
    @IBAction func selectedButtonPressed(_ sender: UIButton) {
        
        selectedbtn.setImage(UIImage(named: "selected"), for: .normal)
        unselectedbtn.setImage(UIImage(named: "unselected"), for: .normal)
        
        isMale = true
        
    }
    
    
    @IBAction func unselectedButtonPressed(_ sender: UIButton) {
        
        unselectedbtn.setImage(UIImage(named: "selected"), for: .normal)
        selectedbtn.setImage(UIImage(named: "unselected"), for: .normal)
        
        isMale = false
    }
    
    func addProfileDataAPI(){
        AppUtility?.startLoader(view: self.view)
        let username = self.nameTF.text
        let firstName = self.first_nameTF.text
        let lastName = self.second_nameTF.text
        let userID = UserDefaults.standard.string(forKey: "userID") as! String
        let web = self.websiteTF.text
        let bio = self.bioTF.text
        var gender = "Male"
        if isMale == false{
            gender = "female"
        }
        ApiHandler.sharedInstance.editProfile(username: username ?? "", user_id: userID , first_name: firstName ?? "", last_name: lastName ?? "", gender: gender , website: web ?? "", bio: bio ?? "") { (isSuccess, response) in
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200{
                    AppUtility?.stopLoader(view: self.view)
                    
                    self.showToast(message: "Porfile Upated", font: .systemFont(ofSize: 12))
                }else{
                    AppUtility?.stopLoader(view: self.view)
                    self.showToast(message: response?.value(forKey: "msg") as! String ?? "Unable To Update", font: .systemFont(ofSize: 12))
                    print("!200: ",response as! Any)
                }
            }
        }
    }
    func addUserImgAPI(){
        AppUtility?.startLoader(view: self.view)
        ApiHandler.sharedInstance.addUserImage(user_id: UserDefaults.standard.string(forKey: "userID")!, profile_pic: ["file_data":self.profilePicData]) { (isSuccess, response) in
            if response?.value(forKey: "code") as! NSNumber == 200{
                AppUtility?.stopLoader(view: self.view)
                let msgDict = response?.value(forKey: "msg") as! NSDictionary
                let userDict = msgDict.value(forKey: "User") as! NSDictionary
                let profImgUrl = userDict.value(forKey: "profile_pic") as! String
                
                self.profileImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.profileImage.sd_setImage(with: URL(string:(AppUtility?.detectURL(ipString: profImgUrl))!), placeholderImage: UIImage(named:"noUserImg"))
                
            }else{
                AppUtility?.stopLoader(view: self.view)
                self.showToast(message: "Error Occur", font: .systemFont(ofSize: 12))
            }
        }
    } 
}
