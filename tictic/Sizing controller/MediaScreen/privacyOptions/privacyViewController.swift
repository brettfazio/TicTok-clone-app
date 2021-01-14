//
//  privacyViewController.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 04/09/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit

class privacyViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var arrPrivacyOptions = [privOptions]()
    var privType = "Public"
    
    @IBOutlet weak var tableOutlet: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //        UserDefaults.standard.set(0, forKey: "checkMarkRow")
        
        
        let opt1 = privOptions(title: "Public", desc: "Anyone on MusicTok")
        //        let opt2 = privOptions(title: "Friends", desc: "Followers that you follow back")
        let opt3 = privOptions(title: "Private", desc: "Visible to me only")
        
        arrPrivacyOptions.append(opt1)
        //        arrPrivacyOptions.append(opt2)
        arrPrivacyOptions.append(opt3)
        
        self.tableOutlet.tableFooterView = UIView()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPrivacyOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "privacyTVC") as! privacyTableViewCell
        
        
        let opt = arrPrivacyOptions[indexPath.row]
        cell.title.text = opt.title
        cell.desc.text = opt.desc
        
        let selectedRow = UserDefaults.standard.integer(forKey: "selectRow")
        if selectedRow == indexPath.row{
            cell.accessoryType = .checkmark
            cell.accessoryView?.tintColor = #colorLiteral(red: 1, green: 0.5223166943, blue: 0, alpha: 1)
            
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("index",indexPath.row)
        
        self.tableOutlet.cellForRow(at: indexPath)?.accessoryView?.tintColor = #colorLiteral(red: 1, green: 0.5223166943, blue: 0, alpha: 1)
        self.tableOutlet.cellForRow(at: indexPath)?.accessoryView?.backgroundColor = .clear
        self.tableOutlet.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        print("indexpath.row: ",indexPath.row)
        //        UserDefaults.standard.set(indexPath.row, forKey: "selectRow")
        
        tableOutlet.reloadData()
        
        switch indexPath.row {
        case 0:
            UserDefaults.standard.set("Public", forKey: "privOpt")
            
            privType = "Public"
        case 1:
            UserDefaults.standard.set("Private", forKey: "privOpt")
            privType = "Private"
            //            case 2:
            //            UserDefaults.standard.set("Private", forKey: "privOpt")
        //            privType = "Private"
        default:
            break
        }
        
        NotificationCenter.default.post(name: Notification.Name("privTypeNC"), object: nil, userInfo: ["privType":privType])
        dismiss(animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.tableOutlet.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
        print("pressed")
    }
    
    
}
