//
//  favSoundsTableViewCell.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 17/11/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit

class favSoundsTableViewCell: UITableViewCell {

    @IBOutlet weak var soundName : UILabel!
    @IBOutlet weak var soundDesc : UILabel!
    @IBOutlet weak var duration : UILabel!
    
    @IBOutlet weak var soundImg : UIImageView!
    @IBOutlet weak var playImg : UIImageView!
    
    @IBOutlet weak var btnFav : UIButton!
    @IBOutlet weak var btnSelect : UIButton!
    
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var btnSelectTrailing: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
