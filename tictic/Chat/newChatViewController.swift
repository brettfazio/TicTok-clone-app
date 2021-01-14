
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import SDWebImage

class newChatViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate
{
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var accessoryView: CustomView!
    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var imgAdd: UIImageView!
    
    @IBOutlet weak var txtMessageHeight: NSLayoutConstraint!
    @IBOutlet weak var accessoryViewBottom: NSLayoutConstraint!
    
    var minTextViewHeight: CGFloat = 40
    var maxTextViewHeight: CGFloat = 100
    
    var arrMessages = [[String : Any]]()
//    var recArrMessages = [[String : Any]]()
//    var mainMsgsArr = [[String : Any]]()
    
    var imagedata = Data()
    let imagePicker = UIImagePickerController()
    
    //    var currentUserId = Auth.auth().currentUser!.uid
    
    var dict = [String : Any]()
    var receiverDict = [String : Any]()
    
    var receiverData = [userMVC]()
    var otherVisiting = false
    
    var msgDict = [String : Any]()
    
    var receiverName = String()
    var receiverProfile = String()
    //    var userToken = String()
    var senderName = String()
    var senderProfile = String()
    
    var dateString = String()
    
    var currentUserName = String()
    
    var senderID = "1"
    var receiverID = "2"
    
    var currentUserId = "2"
    var myUser: [User]? {didSet {}}
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        IQKeyboardManager.shared.disabledToolbarClasses.append(newChatViewController.self)
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(newChatViewController.self)
        
        self.hideKeyboardWhenTappedAround()
        
        //        self.userId = dict["id"] as? String ?? "id"
        //        self.userName = dict["name"] as? String ?? "name"
        //        self.lblTitle.text = self.userName
        //        self.userProfile = dict["profile"] as? String ?? dict["image"] as? String ?? "image"
        
        myUser = User.readUserFromArchive()
        
        print("myUser: ",myUser![0].username)
        self.senderName = myUser![0].username
        self.senderProfile = (AppUtility?.detectURL(ipString: myUser![0].profile_pic))!
        
        self.senderID = UserDefaults.standard.string(forKey: "userID")!
        
        if otherVisiting == true{
            let obj = receiverData[0]
            self.receiverID = obj.userID
            self.receiverName = obj.username
            self.lblTitle.text = self.receiverName
            self.receiverProfile = (AppUtility?.detectURL(ipString:obj.userProfile_pic))!
            print("receiverProfile: ",receiverProfile)
            
        }else{
            self.receiverID = receiverDict["rid"] as? String ?? "receiver id"
            self.receiverName = receiverDict["name"] as? String ?? "name"
            //        self.receiverID = msgDict["rid"] as? String ?? "receiver id"
            self.lblTitle.text = self.receiverName
            self.receiverProfile = ((AppUtility?.detectURL(ipString: receiverDict["pic"] as! String))!)
            print("receiverProfile: ",receiverProfile)
        }
        
        
        //        let user = UserDefaults.standard.value(forKey: "userlogin") as? [String : Any] ?? [:]
        //        self.currentUserName = user["name"] as? String ?? "name"
        
        txtMessage.text = "Send Message..."
        txtMessage.textColor = UIColor.lightGray
        
        txtMessage.delegate = self
        
        ChatDBhandler.shared.fetchMessage(senderID: senderID, receiverID: receiverID) { (isSuccess, message) in
            self.arrMessages.removeAll()
            if isSuccess == true
            {
                
                for key in message
                {
                    let messages = key.value as? [String : Any] ?? [:]
                    self.arrMessages.append(messages)
                    self.arrMessages.sort(by: { ("\($0["time"]!)") < ("\($1["time"]!)") })
                    self.scrollToBottom()
                }
                
                self.tblView.reloadData()
            }
        }

        
        self.txtMessage.tintColor = #colorLiteral(red: 0.9568627451, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
        self.txtMessage.tintColorDidChange()
        self.txtMessage.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.imagePicker.delegate = self
        let imgTap = UITapGestureRecognizer.init(target: self, action: #selector(self.tapImage(sender:)))
        imgAdd.isUserInteractionEnabled = true
        imgAdd.addGestureRecognizer(imgTap)
        
    }
    
    
    
    //MARK:- scroll to bottom
    func scrollToBottom()
    {
        if arrMessages.count > 0
        {
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.arrMessages.count-1, section: 0)
                self.tblView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }
    
    //MARK:- tap gesture
    @objc func tapImage(sender:UITapGestureRecognizer)
    {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.modalPresentationStyle = .fullScreen
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK:- image picker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            self.dismiss(animated: true, completion: nil)
            self.imagedata = pickedImage.jpegData(compressionQuality: 0.25)!
            
            let time = Date().millisecondsSince1970

            AppUtility?.startLoader(view: self.view)
            ChatDBhandler.shared.sendImage(senderID: senderID, receiverID: receiverID, image: imagedata, seen: false, time: time, type: "pic") { (result, url) in
                if result == true
                {
                    print("image sent")

                    ChatDBhandler.shared.userChatInbox(senderID: self.senderID, receiverID: self.receiverID, image: self.receiverProfile, name: self.receiverName, message: url, type: "pic", seen: false, timestamp: time, date: "\(time)", status: "1") { (result) in
                        if result == true
                        {
                            print("user Sent")
                            self.sendMsgNoti()
                            AppUtility?.stopLoader(view: self.view)
                            //                            ChatDBhandler.shared.sendPushNotification(to: self.userToken, title: self.currentUserName, body: "Send an Image")
                        }
                    }
                    

                }
                
            }
        }
        else
        {
            print("Error in pick Image")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Change the height of textView when type
    func textViewDidChange(_ textView: UITextView)
    {
        var height = textView.contentSize.height
        
        if height < minTextViewHeight
        {
            height = minTextViewHeight
        }
        
        if (height > maxTextViewHeight)
        {
            height = maxTextViewHeight
        }
        
        if height != txtMessageHeight.constant
        {
            txtMessageHeight.constant = height
            textView.setContentOffset(CGPoint.zero, animated: false)
        }
    }
    
    //    MARK:- PLACEHOLDER OF TEXT VIEW
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    //    func textViewDidEndEditing(_ textView: UITextView) {
    //        if textView.text.isEmpty {
    //            textView.text = "Send Message..."
    //            textView.textColor = UIColor.lightGray
    //        }
    //    }
    
    //MARK:- keyboardWillShow
    @objc func keyboardWillShow(notification: Notification)
    {
        let keyboardSize = (notification.userInfo?  [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        
        let keyboardHeight = keyboardSize?.height
        
        self.accessoryViewBottom.constant = -(keyboardHeight! - view.safeAreaInsets.bottom)
        
        UIView.animate(withDuration: 0.5)
        {
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK:- keyboardWillHide
    @objc func keyboardWillHide(notification: Notification)
    {
        //        txtMessage.text = "Send Message..."
        //        txtMessage.textColor = UIColor.lightGray
        
        self.accessoryViewBottom.constant =  0 // or change according to your logic
        
        UIView.animate(withDuration: 0.5)
        {
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK:- button Actions
    @IBAction func btnBackAction(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:- SEND MSG ACTION
    //    private func textView(textView: UITextView, shouldChangeTextInRange  range: NSRange, replacementText text: String) -> Bool {
    //      if (text == "\n") {
    //         textView.resignFirstResponder()
    //         sendPressed()
    //      }
    //      return true
    //    }
    //
    //    func sendPressed() {
    //        print("send")
    //    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            sendPressed()
        }
        return true
        
    }
    
    func sendPressed() {
        if self.txtMessage.text == ""
        {
            AppUtility!.displayAlert(title: "customChat", message: "Please type your message")
        }
        else
        {
            let time = Date().millisecondsSince1970
            /*
             ChatDBhandler.shared.sendMessages(uid: self.currentUserId, merchantId: self.userId, message: self.txtMessage.text!, seen: false, time: time, type: "text") { (isSuccess) in
             if isSuccess == true
             {
             print("Message Sent")
             }
             }
             */
            //            AppUtility?.startLoader(view: self.view)
            
            print("sender: \(senderID) && receiver: \(receiverID)")
            
            print("self.txtMessage.text: ",self.txtMessage.text!)
            ChatDBhandler.shared.sendMessage(senderID: senderID, receiverID: receiverID, senderName: self.senderName, message: self.txtMessage.text!, seen: false, time: time, type: "text") { (isSuccess) in
                if isSuccess == true{
                    print("Message Sent")
                }
            }
            
            //            ChatDBhandler.shared.sendPushNotification(to: self.userToken, title: self.currentUserName, body: self.txtMessage.text!)
            
            /*
             ChatDBhandler.shared.userChat(uid: self.currentUserId, userId: self.userId, image: self.userProfile, name: self.userName, message: self.txtMessage.text, type: "text", seen: false, timestamp: time) { (result) in
             if result == true
             {
             print("User Sent")
             }
             }
             */
            ChatDBhandler.shared.userChatInbox(senderID: self.senderID, receiverID: self.receiverID, image: receiverProfile, name: self.receiverName, message: self.txtMessage.text!, type: "text", seen: false, timestamp: time, date: "\(time)", status: "1") { (result) in
                if result == true
                {
                    print("user Sent")
                    
                    //                    ChatDBhandler.shared.sendPushNotification(to: self.userToken, title: self.currentUserName, body: "Send an Image")
                    //                    AppUtility?.stopLoader(view: self.view)
                    
                    self.sendMsgNoti()
                }
            }
                        
                        
            self.txtMessageHeight.constant = self.minTextViewHeight
        }
    }
    
    
    
    //MARK:- tableView delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.arrMessages.count == 0
        {
            self.lblMessage.isHidden = false
            return 0
        }
        else
        {
            self.lblMessage.isHidden = true
            return self.arrMessages.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        /*
        mainMsgsArr.removeAll()
        mainMsgsArr.append(contentsOf: arrMessages)
        mainMsgsArr.append(contentsOf: recArrMessages)
        mainMsgsArr.sort(by: { ("\($0["time"]!)") < ("\($1["time"]!)") })
        
        */
        
        
        
        let time = (self.arrMessages[indexPath.row]["time"] as? Double)
        let date = Date(timeIntervalSince1970: time!/1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yy' 'HH:mm a"
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "pm"
        let dateString = dateFormatter.string(from: date)
        
        let from = self.arrMessages[indexPath.row]["sender_id"] as? String ?? "from"
        let type = self.arrMessages[indexPath.row]["type"] as? String ?? "type"
        let picture = arrMessages[indexPath.row]["text"] as? String ?? "text"
        
        if self.senderID == from
        {
            if type == "text"
            {
                let chatCell1 = tableView.dequeueReusableCell(withIdentifier: "chatCell1") as! ChatTableViewCell
                chatCell1.lblMessage.text = arrMessages[indexPath.row]["text"] as? String ?? "text"
                chatCell1.lblDate.text = dateString
                return chatCell1
            }
            else
            {
                let chatCell2 = tableView.dequeueReusableCell(withIdentifier: "chatCell2") as! ChatTableViewCell
                chatCell2.imgMessage.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                chatCell2.imgMessage.sd_setImage(with: URL(string: picture), placeholderImage: UIImage(named: "videoPlaceholder"))
                
                let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.imagePreview(_:)))
                chatCell2.imgMessage.isUserInteractionEnabled = true
                chatCell2.imgMessage.addGestureRecognizer(tap)
                
                return chatCell2
            }
        }
        else
        {
            if type == "text"
            {
                let chatCell3 = tableView.dequeueReusableCell(withIdentifier: "chatCell3") as! ChatTableViewCell
                chatCell3.lblMessage.text = arrMessages[indexPath.row]["text"] as? String ?? "text"
                chatCell3.lblDate.text = dateString
                return chatCell3
            }
            else
            {
                let chatCell4 = tableView.dequeueReusableCell(withIdentifier: "chatCell4") as! ChatTableViewCell
                chatCell4.imgMessage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                chatCell4.imgMessage.sd_setImage(with: URL(string: picture), placeholderImage: UIImage(named: "videoPlaceholder"))
                
                let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.imagePreview(_:)))
                chatCell4.imgMessage.isUserInteractionEnabled = true
                chatCell4.imgMessage.addGestureRecognizer(tap)
                
                return chatCell4
            }
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    //MARK:- tap getsure recognizer
    @objc func imagePreview(_ gesture: UITapGestureRecognizer)
    {
        let tapLocation = gesture.location(in: self.tblView)
        let indexPath = self.tblView.indexPathForRow(at: tapLocation)!
        
        let type = self.arrMessages[indexPath.row]["type"] as? String ?? "type"
        let picture = arrMessages[indexPath.row]["text"] as? String ?? "messages"
        
        print("pic: ",picture)
        if type == "pic"
        {
            let imagePreviewVC = self.storyboard?.instantiateViewController(withIdentifier: "imagePreviewVC") as! ImagePreviewViewController
            imagePreviewVC.imgUrl = picture
            imagePreviewVC.modalPresentationStyle = .fullScreen
            navigationController?.present(imagePreviewVC, animated: true, completion: nil)
        }
    }
    
    func sendMsgNoti(){
        ApiHandler.sharedInstance.sendMessageNotification(senderID: senderID, receiverID: receiverID, msg: txtMessage.text!, title: senderName) { (isSuccess, response) in
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200{
                    print("msg noti sent: ")
                    self.txtMessage.text = "Send Message..."
                    self.txtMessage.textColor = UIColor.lightGray
                    
                }else{
                    print("!200: ",response as Any)
                    self.txtMessage.text = "Send Message..."
                    self.txtMessage.textColor = UIColor.lightGray
                }


            }
        }
    }
}

