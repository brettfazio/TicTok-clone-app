//
//  chatDBhandler.swift
//  customChatWithFirebase
//
//  Created by Junaid  Kamoka on 12/11/2020.
//  Copyright © 2020 Junaid  Kamoka. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ChatDBhandler
{
    static let shared = ChatDBhandler()
    
    
    //MARK:- send text messages
    func sendMessages(uid: String, merchantId: String, message: String, seen: Bool, time: Any, type: String, completionHandler: @escaping (_ result: Bool) -> Void)
    {
        let messages  = Database.database().reference().child("messages")
        let fromId = messages.child(uid).child(merchantId).childByAutoId()
        let value = ["from": "\(merchantId)", "messages": "\(message)", "seen": seen, "time": time, "type": "\(type)"] as [String : Any]
        fromId.updateChildValues(value) { (error, Ref) in
            if error != nil
            {
                print("error in send message fromId: ", error!.localizedDescription)
                AppUtility!.displayAlert(title: "customChat", message: error!.localizedDescription)
                completionHandler(false)
            }
            let toId = messages.child(merchantId).child(uid).child("\(fromId.key!)")
            let value = ["from": "\(merchantId)", "messages": "\(message)", "seen": seen, "time": time, "type": "\(type)"] as [String : Any]
            toId.updateChildValues(value) { (error, Ref) in
                if error != nil
                {
                    print("error in send message toId: ", error!.localizedDescription)
                    AppUtility!.displayAlert(title: "customChat", message: error!.localizedDescription)
                    completionHandler(false)
                }
                
                completionHandler(true)
            }
        }
    }
    
    //MARK:- send text message
    func sendMessage(senderID: String, receiverID: String,senderName: String, message: String, seen: Bool, time: Any, type: String, completionHandler: @escaping (_ result: Bool) -> Void)
    {
        let messages  = Database.database().reference().child("chat")
        let chatOf = messages.child(senderID+"-"+receiverID).childByAutoId()
        let value = ["chat_id": "\(chatOf.key!)", "text": "\(message)","pic_url":"","sender_id":senderID,"receiver_id":receiverID,"sender_name":senderName ,"seen": seen, "time": time, "type": "\(type)"] as [String : Any]
        chatOf.updateChildValues(value) { (error, Ref) in
            if error != nil
            {
                print("error in send message fromId: ", error!.localizedDescription)
                AppUtility!.displayAlert(title: "customChat", message: error!.localizedDescription)
                completionHandler(false)
            }
            
            let toId = messages.child(receiverID+"-"+senderID).child("\(chatOf.key!)")
            let value = ["chat_id": "\(chatOf.key!)", "text": "\(message)","pic_url":"","sender_id":senderID,"receiver_id":receiverID,"sender_name":senderName ,"seen": seen, "time": time, "type": "\(type)"] as [String : Any]
            toId.updateChildValues(value) { (error, Ref) in
                if error != nil
                {
                    print("error in send message toId: ", error!.localizedDescription)
                    AppUtility!.displayAlert(title: "customChat", message: error!.localizedDescription)
                    completionHandler(false)
                }
                
                completionHandler(true)
            }
            
        }
    }
    
    /*
    //MARK:- send user-Chat
    func userChat(uid: String, userId: String, image: String, name: String, message: String, type: String, seen: Bool, timestamp: Any, completionHandler: @escaping (_ result: Bool) -> Void)
    {
        let Chat  = Database.database().reference().child("Chat")
        
        let fromId = Chat.child(uid).child(userId)
        let value = ["id": "\(userId)", "image": "\(image)", "name": "\(name)", "message": "\(message)", "type": "\(type)", "seen": seen, "timestamp": timestamp] as [String : Any]
        
        fromId.updateChildValues(value) { (error, Ref) in
            if error != nil
            {
                print("error in send message fromId: ", error!.localizedDescription)
                AppUtility.shared.displayAlert(title: "customChat", message: error!.localizedDescription)
                completionHandler(false)
            }
            
            //............toId............//
            
            let user = UserDefaults.standard.value(forKey: "userlogin") as? [String : Any] ?? UserDefaults.standard.value(forKey: "merchantlogin") as? [String : Any] ?? [:]
            
            let currentUserName = user["name"] as? String ?? "name"
            let currentUserProfile = user["profile"] as? String ?? "profile"
                    
            let toId = Chat.child(userId).child(uid)
            let value = ["id": "\(uid)", "image": "\(currentUserProfile)", "name": "\(currentUserName)", "message": "\(message)", "type": "\(type)", "seen": seen, "timestamp": timestamp] as [String : Any]
            
            toId.updateChildValues(value) { (error, Ref) in
                if error != nil
                {
                    print("error in send message toId: ", error!.localizedDescription)
                    AppUtility.shared.displayAlert(title: "customChat", message: error!.localizedDescription)
                    completionHandler(false)
                }
                
                completionHandler(true)
            }
        }
    }
    
   */
    //MARK:- send user-Chat
    func userChatInbox(senderID: String, receiverID: String, image: String, name: String, message: String, type: String, seen: Bool, timestamp: Any, date:String,status:String,completionHandler: @escaping (_ result: Bool) -> Void)
     {
         let Inbox  = Database.database().reference().child("Inbox")
         
         let fromId = Inbox.child(senderID).child(receiverID)
         let value = ["rid": "\(receiverID)", "pic": "\(image)", "name": "\(name)", "msg": "\(message)", "type": "\(type)", "seen": seen, "timestamp": timestamp,"date": date,"status": status] as [String : Any]
         
         fromId.updateChildValues(value) { (error, Ref) in
             if error != nil
             {
                 print("error in send message fromId: ", error!.localizedDescription)
                AppUtility!.displayAlert(title: "customChat", message: error!.localizedDescription)
                 completionHandler(false)
             }
             
             //............toId............//
             
             let user = UserDefaults.standard.value(forKey: "userlogin") as? [String : Any] ?? UserDefaults.standard.value(forKey: "merchantlogin") as? [String : Any] ?? [:]
             
             let currentUserName = user["name"] as? String ?? "name"
             let currentUserProfile = user["profile"] as? String ?? "profile"
                     
            var myUser: [User]? {didSet {}}
            myUser = User.readUserFromArchive()
            print("myUser: ",myUser![0].username)
            let senderName = myUser![0].username
            let senderProfile = (AppUtility?.detectURL(ipString: myUser![0].profile_pic))!
            
             let toId = Inbox.child(receiverID).child(senderID)
             let value = ["rid": "\(senderID)", "pic": "\(senderProfile)", "name": "\(senderName!)", "msg": "\(message)", "type": "\(type)", "seen": seen, "timestamp": timestamp,"date": date,"status": status] as [String : Any]
             
             toId.updateChildValues(value) { (error, Ref) in
                 if error != nil
                 {
                     print("error in send message toId: ", error!.localizedDescription)
                    AppUtility!.displayAlert(title: "customChat", message: error!.localizedDescription)
                     completionHandler(false)
                 }
                 
                 completionHandler(true)
             }
         }
     }
    /*
    //MARK:- send image messages
    func sendImages(uid: String, merchantId: String, image: Data, seen: Bool, time: Any, type: String, completionHandler: @escaping (_ result: Bool,_ url: String) -> Void)
    {
        AppUtility.shared.showLoader(message: "Please wait...")
        
        let dbRef = Database.database().reference().childByAutoId()
        let storageRef = Storage.storage().reference().child("Images/\(dbRef.key!)")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        storageRef.putData(image, metadata: metadata) { (storageMetaData, error) in
            if error != nil
            {
                print("error in upload photo: ", error!.localizedDescription)
                AppUtility.shared.hideLoader()
                AppUtility.shared.displayAlert(title: "customChat", message: error!.localizedDescription)
                completionHandler(false, "")
            }
            storageRef.downloadURL { (url, error) in
                if error != nil
                {
                    print("error in download url photo: ", error!.localizedDescription)
                    AppUtility.shared.hideLoader()
                    AppUtility.shared.displayAlert(title: "customChat", message: error!.localizedDescription)
                    completionHandler(false, "")
                }
                else
                {
                    self.sendMessages(uid: uid, merchantId: merchantId, message: "\(url!)", seen: seen, time: time, type: type) { (isSuccess) in
                        completionHandler(true, "\(url!)")
                        AppUtility.shared.hideLoader()
                    }
                }
            }
        }
    }
    */
    
    //MARK:- send image message
    func sendImage(senderID: String, receiverID: String, image: Data, seen: Bool, time: Any, type: String, completionHandler: @escaping (_ result: Bool,_ url: String) -> Void)
    {
//        AppUtility.shared.showLoader(message: "Please wait...")
        
        let dbRef = Database.database().reference().childByAutoId()
        let storageRef = Storage.storage().reference().child("Images/\(dbRef.key!)")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        storageRef.putData(image, metadata: metadata) { (storageMetaData, error) in
            if error != nil
            {
                print("error in upload photo: ", error!.localizedDescription)
//                AppUtility.shared.hideLoader()
                AppUtility!.displayAlert(title: "customChat", message: error!.localizedDescription)
                completionHandler(false, "")
            }
            storageRef.downloadURL { (url, error) in
                if error != nil
                {
                    print("error in download url photo: ", error!.localizedDescription)
//                    AppUtility.shared.hideLoader()
                    AppUtility!.displayAlert(title: "customChat", message: error!.localizedDescription)
                    completionHandler(false, "")
                }
                else
                {
                    /*
                    self.sendMessage(uid: uid, merchantId: merchantId, message: "\(url!)", seen: seen, time: time, type: type) { (isSuccess) in
                        completionHandler(true, "\(url!)")
                        AppUtility.shared.hideLoader()
                    }
                    */
                    var myUser: [User]? {didSet {}}
                    myUser = User.readUserFromArchive()
                    print("myUser: ",myUser![0].username)
                    let senderName = myUser![0].username
                    let senderProfile = (AppUtility?.detectURL(ipString: myUser![0].profile_pic))!
                    
                    self.sendMessage(senderID: senderID, receiverID: receiverID, senderName: senderName!, message: "\(url!)", seen: seen, time: time, type: type) { (isSuccess) in
                        completionHandler(true, "\(url!)")
//                         AppUtility.shared.hideLoader()
                    }
                }
            }
        }
    }
    
    //MARK:- fetch messages
    func fetchMessages(uid: String, merchantId: String, completionHandler: @escaping (_ result: Bool, _ messages: [String : Any]) -> Void)
    {
        let messages = Database.database().reference().child("messages").child(uid).child(merchantId)
        messages.observe(.value, with: { (dataSnapshot) in
            
            if let dict = dataSnapshot.value as? [String: Any]
            {
                completionHandler(true, dict)
            }
            
        }, withCancel: nil)
    }
    
    //MARK:- fetch message
    func fetchMessage(senderID: String, receiverID: String, completionHandler: @escaping (_ result: Bool, _ messages: [String : Any]) -> Void)
    {
        let messages = Database.database().reference().child("chat").child(senderID+"-"+receiverID)
        messages.observe(.value, with: { (dataSnapshot) in
            
            if let dict = dataSnapshot.value as? [String: Any]
            {
                completionHandler(true, dict)
            }
            
        }, withCancel: nil)
    }
    /*
    //MARK:- fetchuser-Chat
    func fetchuserChat(uid: String, completionHandler: @escaping (_ result: Bool, _ conversation: [String : Any]) -> Void)
    {
        let Chat = Database.database().reference().child("Chat").child(uid)
        Chat.observe(.value, with: { (snapshot) in
            
            let data = snapshot.value as? [String: Any] ?? [:]
            completionHandler(true, data)
        }, withCancel: nil)
    }
    */
    //MARK:- fetchuser-Chat
    func fetchUserInbox(userID: String, completionHandler: @escaping (_ result: Bool, _ conversation: [String : Any]) -> Void)
    {
        let Chat = Database.database().reference().child("Inbox").child(userID)
        Chat.observe(.value, with: { (snapshot) in
            
            let data = snapshot.value as? [String: Any] ?? [:]
            completionHandler(true, data)
        }, withCancel: nil)
    }
    
    //MARK:- delete coversation
    func deleteConversation(senderID: String, receiverID: String, completionHandler: @escaping (_ result: Bool) -> Void)
    {
//        AppUtility.shared.showLoader(message: "Please wait...")
        
        let Chat = Database.database().reference().child("Inbox").child(senderID).child(receiverID)
        Chat.removeValue { (error, dbRef) in
            if error != nil
            {
//                AppUtility.shared.hideLoader()
                print("Error in remove chat: ", error!.localizedDescription)
                AppUtility!.displayAlert(title: "TicTic", message: error!.localizedDescription)
                completionHandler(false)
            }
            let messages = Database.database().reference().child("chat").child(senderID+"-"+receiverID)
            messages.removeValue { (error, Ref) in
                if error != nil
                {
//                    AppUtility.shared.hideLoader()
                    print("Error in remove chat: ", error!.localizedDescription)
                    AppUtility!.displayAlert(title: "TicTic", message: error!.localizedDescription)
                    completionHandler(false)
                }
                
//                AppUtility.shared.hideLoader()
                completionHandler(true)
            }
        }
    }
    
    //MARK:- send Push Notification
    func sendPushNotification(to token: String, title: String, body: String)
    {
        let url = URL(string: "https://fcm.googleapis.com/fcm/send")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAAfxL6pHs:APA91bFRh4e1ZxUYZANQdMSYSQ16cCvq3FPjuXf1gGgmWWuWMeTYxM2dOGoB8ETmEjo093MS9N37wXDdyRMU6sB2pNnj8lAAkHs0HFjyDA8thTl1PWXOD-RFKHXhkZOeIR4Z7gqMVQGb", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let paramString: [String : Any] = ["to" : token,
                                           "notification" : ["title" : title, "body" : body, "sound": "default", "badge": 1],
                                           "data" : ["user" : ""]
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error!)")
                return
            }

            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response!)")
            }

            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString!)")
        }
        task.resume()
    }

}
