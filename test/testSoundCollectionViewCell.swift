//
//  testSoundCollectionViewCell.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 19/11/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit

class testSoundCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var soundName : UILabel!
    @IBOutlet weak var soundDesc : UILabel!
    @IBOutlet weak var duration : UILabel!
    
    @IBOutlet weak var soundImg : UIImageView!
    @IBOutlet weak var playImg : UIImageView!
    
    @IBOutlet weak var btnFav : UIButton!
    @IBOutlet weak var btnSelect : UIButton!
    
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var btnSelectTrailing: NSLayoutConstraint!
}
