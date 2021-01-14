//
//  ConversationViewController.swift
//  Custom
//


import UIKit
import Firebase
import  SDWebImage

class ConversationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblMessage: UILabel!
    
    var arrConversation = [[String : Any]]()
//    let currentUserId = Auth.auth().currentUser!.uid
    
    var senderID = ""
//     var currentUserId = "2"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        senderID = UserDefaults.standard.string(forKey: "userID")!

        /*
        ChatDBhandler.shared.fetchuserChat(uid: self.senderID) { (isSuccess, conversation) in
            
            self.arrConversation.removeAll()
            
            for key in conversation
            {
                let conver = key.value as? [String: Any] ?? [:]
                self.arrConversation.append(conver)
                self.arrConversation.sort(by: { ("\($0["timestamp"]!)") > ("\($1["timestamp"]!)") })
            }
            self.tblView.reloadData()
        }
        */
        
        AppUtility?.startLoader(view: self.view)
        ChatDBhandler.shared.fetchUserInbox(userID: self.senderID) { (isSuccess, conversation) in
            self.arrConversation.removeAll()
            
            for key in conversation
            {
                let conver = key.value as? [String: Any] ?? [:]
                self.arrConversation.append(conver)
                self.arrConversation.sort(by: { ("\($0["timestamp"])") > ("\($1["timestamp"])") })
            }
            AppUtility?.stopLoader(view: self.view)
            self.tblView.reloadData()
        }
    }
    
    //MARK:- tableView delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.arrConversation.count == 0
        {
            self.lblMessage.isHidden = false
            return 0
        }
        else
        {
            self.lblMessage.isHidden = true
            return self.arrConversation.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let data = self.arrConversation[indexPath.row]
        let image = data["pic"] as? String ?? "pic"
        let name = data["name"] as? String ?? "name"
        let lastMessage = data["msg"] as? String ?? "message"
        let type = data["type"] as? String ?? "type"
        
        
        if type == "text"
        {
            let userChatCell = tableView.dequeueReusableCell(withIdentifier: "userChatCell") as! ChatTableViewCell
            userChatCell.imgUser.sd_imageIndicator = SDWebImageActivityIndicator.gray
            userChatCell.imgUser.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "noUserImg"))
            userChatCell.lblUserName.text = name
            userChatCell.lblLastMessage.isHidden = false
            userChatCell.lblLastMessage.text = lastMessage
            userChatCell.hiddenView.isHidden = true
            
            let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
            longGesture.minimumPressDuration = 1.0
            userChatCell.addGestureRecognizer(longGesture)
            
            return userChatCell
        }
        else
        {
            let userChatCell = tableView.dequeueReusableCell(withIdentifier: "userChatCell") as! ChatTableViewCell
            
            userChatCell.imgUser.sd_imageIndicator = SDWebImageActivityIndicator.gray
            userChatCell.imgUser.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "noUserImg"))
            userChatCell.lblUserName.text = name
            userChatCell.lblLastMessage.isHidden = true
            userChatCell.hiddenView.isHidden = false
            
            let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
            longGesture.minimumPressDuration = 1.0
            userChatCell.addGestureRecognizer(longGesture)
            
            return userChatCell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "newChatVC") as! newChatViewController
        chatVC.receiverDict = self.arrConversation[indexPath.row]
        navigationController?.pushViewController(chatVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
    
    @objc func longTap(gestureReconizer: UILongPressGestureRecognizer)
    {
        let longPress = gestureReconizer as UILongPressGestureRecognizer
        _ = longPress.state
        let locationInView = longPress.location(in: tblView)
        let indexPath = tblView.indexPathForRow(at: locationInView)!
        
        let alert = UIAlertController.init(title: "customChat", message: "Are you sure to delete conversation ?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            print("Cancel")
        }))
        
        alert.addAction(UIAlertAction.init(title: "Delete", style: .destructive, handler: { (UIAlertAction) in
            print("Delete")
            
            let rid = self.arrConversation[indexPath.row]["rid"] as? String ?? "rid"
            
            ChatDBhandler.shared.deleteConversation(senderID: self.senderID, receiverID: rid) { (isSuccess) in
                if isSuccess == true
                {
                    print("conversation And chat is deleted: ", indexPath.row)
                }
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- button Actions
    @IBAction func btnBackAction(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
}
