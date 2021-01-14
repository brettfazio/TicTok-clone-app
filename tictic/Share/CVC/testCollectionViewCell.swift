//
//  testCollectionViewCell.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 10/09/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit

class testCollectionViewCell: UICollectionViewCell {
     @IBOutlet weak var imgView: UIImageView!
    //User info cell
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var typeFollowing: UILabel!
    @IBOutlet weak var verticalView: UIView!
    
    //User Items Cell
    @IBOutlet weak var imgItems: UIImageView!
    @IBOutlet weak var horizontalView: UIView!
    
    //Video Controller
    
    @IBOutlet weak var imgVideoTrimer: UIImageView!
    @IBOutlet weak var lblViewerCount: UIButton!
}
