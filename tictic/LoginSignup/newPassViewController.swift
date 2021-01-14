//
//  newPassViewController.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 10/10/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit

class newPassViewController: UIViewController {

    @IBOutlet weak var userNameLbl: UILabel!
    
    @IBOutlet weak var newPass: UITextField!
    @IBOutlet weak var confirmPass: UITextField!
    
    var userName = "Username"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userNameLbl.text = "Username: \(userName)"
        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnNewPass(_ sender: Any) {
               if AppUtility!.isEmpty(self.newPass.text!){
                   AppUtility?.displayAlert(title: NSLocalizedString("alert_app_name", comment: ""), messageText: NSLocalizedString("validation_empty_New_password", comment: ""), delegate: self)
                   return
               }
               if AppUtility!.isEmpty(self.confirmPass.text!){
                   AppUtility?.displayAlert(title: NSLocalizedString("alert_app_name", comment: ""), messageText: NSLocalizedString("validation_empty_Confirm_password", comment: ""), delegate: self)
                   return
               }
               
               if self.newPass.text! != self.confirmPass.text! {
                   AppUtility?.displayAlert(title: NSLocalizedString("alert_app_name", comment: ""), messageText: NSLocalizedString("validation_empty_Both_password", comment: ""), delegate: self)
                   return
               }
        let objToBeSent = newPass.text
        NotificationCenter.default.post(name: Notification.Name("passNoti"), object: objToBeSent)
    //           self.UpdatePasswordAPI()
        dismiss(animated: true, completion: nil)
           }

}
