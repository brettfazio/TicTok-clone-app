//
//  reportViewController.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 10/11/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit

class reportViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let arr = ["Hate Speech","Harassement or bullying","Minor safety","Pornography and nudity","Spam","Animal cruelty","Violent and graphic content","Illegal activities and regulated goods","Other"]
    
    var reportDataArr = [reportMVC]()
    var videoID = ""
    
    @IBOutlet weak var reportTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reportTV.delegate = self
        reportTV.dataSource = self
        reportTV.tableFooterView = UIView()
        
        getReportReasons()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
            dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportDataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportTVC", for: indexPath)as! reportTableViewCell
        cell.lbl.text = reportDataArr[indexPath.row].title
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 49
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reportObj = reportDataArr[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "reportDetailVC") as! reportDetailViewController
        vc.reportTiltleText = reportObj.title
        vc.reportID = reportObj.id
        vc.videoID = self.videoID
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
    func getReportReasons(){
        
        reportDataArr.removeAll()
        
        AppUtility?.startLoader(view: self.view)
        ApiHandler.sharedInstance.showReportReasons { (isSuccess, response) in
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200{
                    let msgData = response?.value(forKey: "msg") as! NSArray
                    
                    for reportObj in msgData{
                        let reportDict = reportObj as! NSDictionary
                        
                        let report = reportDict.value(forKey: "ReportReason") as! NSDictionary
                        
                        let id = report.value(forKey: "id") as! String
                        let title = report.value(forKey: "title") as! String
                        let created = report.value(forKey: "created") as! String
                        
                        let obj = reportMVC(id: id, title: title, created: created)
                        
                        AppUtility?.stopLoader(view: self.view)
                        self.reportDataArr.append(obj)
                        
                    }
                }else{
                    AppUtility?.stopLoader(view: self.view)
                    print("!200: ",response as Any)
                }
                
                self.reportTV.reloadData()
            }else{
                AppUtility?.stopLoader(view: self.view)
                print("failed: ",response as Any)
            }
        }
    }
}
