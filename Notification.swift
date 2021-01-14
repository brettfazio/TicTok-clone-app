//
//  Notification.swift
//  TIK TIK
//
//  Created by Junaid Kamoka on 02/07/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit

class Notifications: NSObject {


       
       var effected_fb_id:String! = ""
       var first_name:String! = ""
       var last_name:String! = ""
       var profile_pic:String! = ""
       var username:String! = ""
       var type:String! = ""
     
       var v_id:String! = ""
       var fb_id:String! = ""
        var Vvalue:String! = ""
    
       
       init(effected_fb_id: String!, first_name: String!, last_name: String!,profile_pic: String!, v_id: String!, username: String!,type: String!,fb_id: String!,Vvalue: String!) {
           
           self.effected_fb_id = effected_fb_id
           self.first_name = first_name
           self.last_name = last_name
           self.profile_pic = profile_pic
           self.v_id = v_id
           self.username = username
           self.type = type
           self.fb_id = fb_id
           self.Vvalue = Vvalue
          
           
       }
}
