//
//  Follow.swift
//  TIK TIK
//
//  Created by Junaid Kamoka on 30/06/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit

class Follow: NSObject {
    
       var fb_id:String! = ""
       var first_name:String! = ""
       var last_name:String! = ""
       var follow_status_button:String! = ""
     
       var profile_pic:String! = ""
       var username:String! = ""
       var status:String! = ""
    
       
    init(fb_id: String!,first_name: String!, last_name: String!,follow_status_button: String!, profile_pic: String!, username: String!, status: String!) {
           
           self.fb_id = fb_id
           self.first_name = first_name
           self.last_name = last_name
           self.follow_status_button = follow_status_button
           self.profile_pic = profile_pic
           self.username = username
           self.status = status
          
           
       }

}
