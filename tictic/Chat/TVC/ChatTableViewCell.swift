//
//  ChatTableViewCell.swift
//  e-EBM
//
//  Created by Arslan on 26/07/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import UIKit
import SDWebImage

class ChatTableViewCell: UITableViewCell
{
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgMessage: UIImageView!
    
    //MARK:- outlets of conversationViewController
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblLastMessage: UILabel!
    @IBOutlet weak var hiddenView: UIView!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
//        imgUser.layer.masksToBounds = false
//        imgUser.layer.cornerRadius = imgUser.frame.height/2
//        imgUser.clipsToBounds = true
//        imgUser.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }

}
