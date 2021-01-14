//
//  privacyAndSettingViewController.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 03/11/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit

class privacyAndSettingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var arrPrivacyOptions = [privOptions]()
    
    var listArr = ["Request Verification","Push Notification","Privacy Setting","Privacy Policy","Terms and Conditions","Change Password","Logout"]
    
    @IBOutlet weak var tableOutlet: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableOutlet.tableFooterView = UIView()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "privacyAndSettingTVC") as! privacyAndSettingTableViewCell
        
        cell.title.text = listArr[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("indexpath.row: ",indexPath.row)
        //        UserDefaults.standard.set(indexPath.row, forKey: "selectRow")
        
        
        switch indexPath.row {
        case 0:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "requestVerificationVC") as! requestVerificationViewController
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "pushNotiSettingsVC") as! pushNotiSettingsViewController
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "privacySettingVC") as! privacySettingViewController
            navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = storyboard?.instantiateViewController(withIdentifier: "termsCondVC") as! termsCondViewController
            vc.privacyDoc = true
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)

        case 4:
            let vc = storyboard?.instantiateViewController(withIdentifier: "termsCondVC") as! termsCondViewController
            vc.privacyDoc = false
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        case 6:
            navigationController?.popViewController(animated: true)
            self.tabBarController?.selectedIndex = 0

            self.tabBarController?.tabBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.tabBarController?.tabBar.unselectedItemTintColor = UIColor.white
            var myUser: [User]? {didSet {}}
            myUser = User.readUserFromArchive()
            myUser?.removeAll()
            self.logoutUserApi()
        default:
            break
        }
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        //        self.dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
        print("pressed")
    }
    
    func logoutUserApi(){
        
        let userID = UserDefaults.standard.string(forKey: "userID")
        print("user id: ",userID as Any)
        AppUtility?.startLoader(view: view)
        ApiHandler.sharedInstance.logout(user_id: userID! ) { (isSuccess, response) in
            AppUtility?.stopLoader(view: self.view)
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    //  self.showToast(message: (response?.value(forKey: "msg") as? String)!, font: .systemFont(ofSize: 12))
                    print(response?.value(forKey: "msg") as Any)
                    UserDefaults.standard.set("", forKey: "userID")
                }else{
                    //                    self.showToast(message: (response?.value(forKey: "msg") as? String)!, font: .systemFont(ofSize: 12))
                    print("logout API:",response?.value(forKey: "msg") as! String)
                }
            }else{
                
                //                self.showToast(message: (response?.value(forKey: "msg") as? String)!, font: .systemFont(ofSize: 12))
                print("logout API:",response?.value(forKey: "msg") as Any)
            }
        }
    }
}
