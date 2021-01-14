//
//  privacyTableViewCell.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 04/09/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit

class privacyTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
