
import UIKit

class Home: NSObject {
    
    
    var like_count:String! = "0"
    var video_comment_count:String! = "0"
    var sound_name:String! = ""
    var thum:String! = ""
    var first_name:String! = ""
    var last_name:String! = ""
    var profile_pic:String! = ""
    var video_url:String! = ""
    var v_id:String! = ""
    var u_id:String! = ""
    var like:String! = "0"
    var desc:String! = ""
    
    init(like_count: String!, video_comment_count: String!, sound_name: String!,thum: String!, first_name: String!, last_name: String!,profile_pic: String!, video_url: String!, v_id: String!, u_id: String!, like: String!, desc: String!) {
        
        self.like_count = like_count
        self.video_comment_count = video_comment_count
        self.sound_name = sound_name
        self.thum = thum
        self.first_name = first_name
        self.last_name = last_name
        self.profile_pic = profile_pic
        self.video_url = video_url
        self.v_id = v_id
        self.u_id = u_id
        self.like = like
        self.desc = desc
       
    }
        
        
        
        
}
