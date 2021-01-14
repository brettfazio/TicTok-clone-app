//
//  testSoundViewController.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 19/11/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit
import SDWebImage

class testSoundViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    var soundsDataArr = [[String:Any]]()
    var startingPoint = "0"
    struct soundSectionsStruct {
        let secID:String
        let secName:String
    }
    var soundSecArr = [soundSectionsStruct]()
    
    @IBOutlet weak var testSoundsCVC : UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.GetAllSounds()
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.soundsDataArr.count
    }
    
    //MARK: CollectionView.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         let sObj = soundsDataArr[section   ]["soundObj"] as! [soundsMVC]
        return sObj.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier:"testSoundCVC" , for: indexPath) as! testSoundCollectionViewCell
        
        let sObj = soundsDataArr[indexPath.section]["soundObj"] as! [soundsMVC]
//        let secobj = soundSecArr[indexPath.section]
        let obj = sObj[indexPath.row]
//        soundCell.soundsObj = soundsDataArr[indexPath.row]["soundObj"] as! [soundsMVC]
        
        cell.soundName.text = obj.name
        cell.soundDesc.text = obj.description
        cell.duration.text = obj.duration
        
        cell.soundImg.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.soundImg.sd_setImage(with: URL(string:(AppUtility?.detectURL(ipString: obj.thum))!), placeholderImage: UIImage(named:"noMusicIcon"))
        
        if obj.favourite == "1"{
            cell.btnFav.setImage(UIImage(named: "btnFavFilled"), for: .normal)
        }else{
            cell.btnFav.setImage(UIImage(named:"btnFavEmpty"), for: .normal)
        }
        
        cell.btnSelect.tag = indexPath.row
        
        cell.btnFav.addTarget(self, action: #selector(discoverSearchViewController.btnSoundFavAction(_:)), for:.touchUpInside)
        cell.btnSelect.addTarget(self, action: #selector(discoverSearchViewController.btnSelectAction(_:)), for:.touchUpInside)
        
        cell.btnSelect.isHidden = true
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.testSoundsCVC.frame.size.width-20, height: 100)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
//         switch kind {
        
//         case UICollectionView.elementKindSectionHeader:
        
        
             let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
        
             headerView.backgroundColor = UIColor.blue
             return headerView
        
//         case UICollectionView.elementKindSectionFooter:
//             let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath)
//
//             footerView.backgroundColor = UIColor.green
//             return footerView
        
//         default:
//
//             assert(false, "Unexpected element kind")
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: collectionView.frame.width, height: 50.0)
    }

    func GetAllSounds(){
        soundsDataArr.removeAll()
        AppUtility?.startLoader(view: self.view)
        ApiHandler.sharedInstance.showSounds(user_id: UserDefaults.standard.string(forKey: "userID")!, starting_point: startingPoint) { (isSuccess, response) in
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200{
                    let soundMsg = response?.value(forKey: "msg") as! NSArray
                    
                    //                    videos hashtags extract
                    
                    print("soundMsg.count: ",soundMsg.count)
                    for i in 0 ..< soundMsg.count{
                        let dic = soundMsg[i] as! NSDictionary
                        let soundSecDict = dic.value(forKey: "SoundSection") as! NSDictionary
                        
                        let sectionID = soundSecDict.value(forKey: "id") as! String
                        let sectionName = soundSecDict.value(forKey: "name") as! String
                        
                        let secObj = soundSectionsStruct(secID: sectionID, secName: sectionName)
                        
                        self.soundSecArr.append(secObj)
                        
                        
                        let soundsObj = dic.value(forKey: "Sound") as! NSArray
                        
                        var soundsArr = [soundsMVC]()
                        soundsArr.removeAll()
                        
                        for j in 0 ..< soundsObj.count{
                            let soundsData = soundsObj[j] as! NSDictionary
                            
                            let id = soundsData.value(forKey: "id") as! String
                            let audioUrl = soundsData.value(forKey: "audio") as! String
                            let duration = soundsData.value(forKey: "duration") as! String
                            let name = soundsData.value(forKey: "name") as! String
                            let description = soundsData.value(forKey: "description") as! String
                            let thum = soundsData.value(forKey: "thum") as! String
                            let section = soundsData.value(forKey: "sound_section_id") as! String
                            let uploaded_by = soundsData.value(forKey: "uploaded_by") as! String
                            let created = soundsData.value(forKey: "created") as! String
                            let favourite = soundsData.value(forKey: "favourite")
                            let publish = soundsData.value(forKey: "publish")  as! String
                            
                            let soundObj = soundsMVC(id: id, audioURL: audioUrl, duration: duration, name: name, description: description, thum: thum, section: section, uploaded_by: uploaded_by, created: created, favourite: "\(favourite!)", publish: publish)
                            
                            soundsArr.append(soundObj)
                        }
                        self.soundsDataArr.append(["soundObj":soundsArr,"soundSection":self.soundSecArr])
                        print("soundsDataArr: ",self.soundsDataArr[i])
                    }
                    AppUtility?.stopLoader(view: self.view)
                }else{
                    print("!200: ",response as! Any)
                    AppUtility?.stopLoader(view: self.view)
                }
            }
            
            self.testSoundsCVC.reloadData()

        }
    }

}
