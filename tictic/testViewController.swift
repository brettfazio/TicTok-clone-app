//
//  testViewController.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 02/11/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit

class testViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate  {
    
    
    @IBOutlet weak var cv: UICollectionView!
    var arrImage = [["image":"v1"],["image":"v3"],["image":"v1"],["image":"v3"],["image":"v1"],["image":"v3"],["image":"v3"],["image":"v3"],["image":"v3"],["image":"v3"],["image":"v3"],["image":"v3"],["image":"v3"],["image":"v3"],["image":"v3"],["image":"v3"]]
    
    var userInfo = [["type":"Following","count":"170"],["type":"Followers","count":"60.1K"],["type":"Likes","count":"5.7M"],["type":"Videos","count":"320"]]
    
    
    var userItem = [["Image":"music tok icon-2","ImageSelected":"music tok icon-5","isSelected":"true"],["Image":"likeVideo","ImageSelected":"music tok icon-6","isSelected":"false"],["Image":"music tok icon-1","ImageSelected":"music tok icon-4","isSelected":"false"]]
    
    @IBOutlet weak var videoCollection: UICollectionView!
    @IBOutlet weak var whoopsView: UIView!
    @IBOutlet weak var btnFollow: UIButton!

    @IBOutlet weak var userInfoCollectionView: UICollectionView!
     @IBOutlet weak var userItemsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "test", for: indexPath)
        return headerView

    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == cv{
            return arrImage.count
        }else{
            return 1
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "testCVC", for:indexPath) as! testCollectionViewCell
        
        if collectionView == cv{
            cell.imgVideoTrimer.image = UIImage(named: arrImage[indexPath.row]["image"]!)
            cell.lblViewerCount.text("test")
        }
        if collectionView ==  userInfoCollectionView{
            
            cell.lblCount.text =  self.userInfo[indexPath.row]["count"] as? String
            cell.typeFollowing.text = self.userInfo[indexPath.row]["type"] as? String
            
            if indexPath.row ==  self.userInfo.count - 1 {
                cell.verticalView.isHidden = true
            }else{
                cell.verticalView.isHidden = false
            }
            
            
        }else{
            if indexPath.row == 0 {
                if self.userItem[indexPath.row]["isSelected"] == "false"{
                    cell.horizontalView.isHidden  = true
                    cell.imgItems.image = UIImage(named: self.userItem[indexPath.row]["Image"]!)
                }else{
                    cell.horizontalView.isHidden  = false
                    cell.imgItems.image = UIImage(named: self.userItem[indexPath.row]["ImageSelected"]!)
                }
            }
            if indexPath.row == 1 {
                if self.userItem[indexPath.row]["isSelected"] == "false"{
                    cell.horizontalView.isHidden  = true
                    cell.imgItems.image = UIImage(named: self.userItem[indexPath.row]["Image"]!)
                }else{
                    cell.horizontalView.isHidden  = false
                    cell.imgItems.image = UIImage(named: self.userItem[indexPath.row]["ImageSelected"]!)
                }
            }
            if indexPath.row == 2{
                if self.userItem[indexPath.row]["isSelected"] == "false"{
                    cell.horizontalView.isHidden  = true
                    cell.imgItems.image = UIImage(named: self.userItem[indexPath.row]["Image"]!)
                }else{
                    cell.horizontalView.isHidden  = false
                    cell.imgItems.image = UIImage(named: self.userItem[indexPath.row]["ImageSelected"]!)
                }
            }
            
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == userInfoCollectionView{
            return CGSize(width: self.userInfoCollectionView.frame.size.width/4, height: 50)
            
        }else if collectionView == userItemsCollectionView{
            return CGSize(width: self.userItemsCollectionView.frame.size.width/3, height: 50)
            
        }else{
            return CGSize(width: self.cv.frame.size.width/3-1, height: 204)
        }
        
        
    }
}
