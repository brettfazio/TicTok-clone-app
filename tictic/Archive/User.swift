//
//  user.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 13/10/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit
class User:NSObject, NSCoding {

     var startlat:Double!
       var startlong:Double!
       var endLat:Double!
       var endLong:Double!
       
       var id: String!
       var active: String!
       var city: String!
       var country: String!
       var created: String!
       var device: String!
       var dob: String!
       var email: String!
       var fb_id: String!
       var first_name: String!
       var gender: String!
       var last_name: String!
       var ip: String!
       var lat: String!
       var long: String!
       var online: String!
       var password: String!
       var phone: String!
       var profile_pic: String!
       var role: String!
       var social: String!
       var social_id: String!
       var username: String!
       var verified: String!
       var version: String!
       var website: String!
       
     //  PushNotification
       
       var comments: String!
       var direct_messages: String!
       var likes: String!
       var mentions: String!
       var new_followers: String!
       var video_updates: String!
       
       
    //   PrivacySetting
       var direct_message: String!
       var duet: String!
       var liked_videos: String!
       var video_comment: String!
       var videos_download: String!
       
    override init() {
        super.init()
    }
    required init?(coder aDecoder: NSCoder){

        self.id = aDecoder.decodeObject(forKey: "id") as? String
        self.active = aDecoder.decodeObject(forKey: "active") as? String
        self.city = aDecoder.decodeObject(forKey: "city") as? String
        self.country = aDecoder.decodeObject(forKey: "country") as? String
        self.created = aDecoder.decodeObject(forKey: "created") as? String
        self.device = aDecoder.decodeObject(forKey: "device") as? String
        self.dob = aDecoder.decodeObject(forKey: "dob") as? String
        self.email = aDecoder.decodeObject(forKey: "email") as? String
        self.fb_id = aDecoder.decodeObject(forKey: "fb_id") as? String
        self.first_name = aDecoder.decodeObject(forKey: "first_name") as? String
        self.gender = aDecoder.decodeObject(forKey: "gender") as? String
        self.last_name = aDecoder.decodeObject(forKey: "last_name") as? String
        
        self.ip = aDecoder.decodeObject(forKey: "ip") as? String
        self.lat = aDecoder.decodeObject(forKey: "lat") as? String
        self.long = aDecoder.decodeObject(forKey: "long") as? String
        self.password = aDecoder.decodeObject(forKey: "password") as? String
        self.online = aDecoder.decodeObject(forKey: "online") as? String
        self.phone = aDecoder.decodeObject(forKey: "phone") as? String
        self.profile_pic = aDecoder.decodeObject(forKey: "profile_pic") as? String
        self.role = aDecoder.decodeObject(forKey: "role") as? String
        self.social = aDecoder.decodeObject(forKey: "social") as? String
        self.social_id = aDecoder.decodeObject(forKey: "social_id") as? String
        self.username = aDecoder.decodeObject(forKey: "username") as? String
        self.verified = aDecoder.decodeObject(forKey: "verified") as? String
        self.version = aDecoder.decodeObject(forKey: "version") as? String
        self.website = aDecoder.decodeObject(forKey: "website") as? String
        
        self.comments = aDecoder.decodeObject(forKey: "comments") as? String
        self.direct_messages = aDecoder.decodeObject(forKey: "direct_messages") as? String
        self.likes = aDecoder.decodeObject(forKey: "likes") as? String
        self.mentions = aDecoder.decodeObject(forKey: "mentions") as? String
        self.new_followers = aDecoder.decodeObject(forKey: "new_followers") as? String
        self.video_updates = aDecoder.decodeObject(forKey: "video_updates") as? String


       self.direct_message = aDecoder.decodeObject(forKey: "direct_message") as? String
       self.duet = aDecoder.decodeObject(forKey: "duet") as? String
       self.liked_videos = aDecoder.decodeObject(forKey: "liked_videos") as? String
       self.video_comment = aDecoder.decodeObject(forKey: "video_comment") as? String
       self.videos_download = aDecoder.decodeObject(forKey: "videos_download") as? String

    }
    func encode(with acoder: NSCoder) {
        acoder.encode(self.startlat,forKey: "startlat")
        acoder.encode(self.startlong,forKey: "startlong")
        acoder.encode(self.endLat,forKey: "endLat")
        acoder.encode(self.endLong,forKey: "endLong")
        
        
        acoder.encode(self.id,forKey: "id")
        acoder.encode(self.active,forKey: "active")
        acoder.encode(self.city,forKey: "city")
        acoder.encode(self.country,forKey: "country")
        acoder.encode(self.created,forKey: "created")
        acoder.encode(self.device,forKey: "device")
        acoder.encode(self.dob,forKey: "dob")
        acoder.encode(self.email,forKey: "email")
        acoder.encode(self.fb_id,forKey: "fb_id")
        acoder.encode(self.first_name,forKey: "first_name")
        acoder.encode(self.gender,forKey: "gender")
        acoder.encode(self.last_name,forKey: "last_name")
        acoder.encode(self.ip,forKey: "ip")
        acoder.encode(self.lat,forKey: "lat")
        acoder.encode(self.long,forKey: "long")
        acoder.encode(self.online,forKey: "online")
        acoder.encode(self.password,forKey: "password")
        acoder.encode(self.phone,forKey: "phone")
        acoder.encode(self.profile_pic,forKey: "profile_pic")
        acoder.encode(self.role,forKey: "role")
        acoder.encode(self.social,forKey: "social")
        acoder.encode(self.social_id,forKey: "social_id")
        acoder.encode(self.username,forKey: "username")
        acoder.encode(self.verified,forKey: "verified")
        acoder.encode(self.version,forKey: "version")
        acoder.encode(self.website,forKey: "website")
        
        acoder.encode(self.comments,forKey: "comments")
        acoder.encode(self.likes,forKey: "likes")
        acoder.encode(self.direct_messages,forKey: "direct_messages")
        acoder.encode(self.mentions,forKey: "mentions")
        acoder.encode(self.new_followers,forKey: "new_followers")
        acoder.encode(self.video_updates,forKey: "video_updates")
        acoder.encode(self.direct_message,forKey: "direct_message")
        acoder.encode(self.video_comment,forKey: "video_comment")
        acoder.encode(self.videos_download,forKey: "videos_download")
    

    }
    //MARK: Archive Methods
        class func archiveFilePath() -> String {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            return documentsDirectory.appendingPathComponent("User.archive").path
        }
        
        class func readUserFromArchive() -> [User]? {
            return NSKeyedUnarchiver.unarchiveObject(withFile: archiveFilePath()) as? [User]
        }
        
        class func saveUserToArchive(user: [User]) -> Bool {
            return NSKeyedArchiver.archiveRootObject(user, toFile: archiveFilePath())
        }
        
    }
