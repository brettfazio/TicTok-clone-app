
import UIKit
import FBSDKLoginKit
import GoogleSignIn
import Alamofire
import AuthenticationServices

class NotificationViewController: UIViewController,GIDSignInDelegate,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var inner_view: UIView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var outer_view: UIView!
    var first_name:String! = ""
    var last_name:String! = ""
    var email:String! = ""
    var my_id:String! = ""
    var profile_pic:String! = ""
    var signUPType:String! = ""
    
    var Notifications_Array:NSMutableArray = []
    
    @IBOutlet weak var tableview: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        self.tableview.tableFooterView = UIView()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if #available(iOS 13.0, *) {
            self.setupAppleIDCredentialObserver()
        } else {
            // Fallback on earlier versions
        }
        
        
        UIApplication.shared.statusBarStyle = .default
        
        
        if(UserDefaults.standard.string(forKey: "uid") == ""){
            
            self.inner_view.alpha = 1
            
            self.navigationItem.title = "Login"
            
            
        }else{
            
            self.inner_view.alpha = 0
            self.navigationItem.title = "Notifications"
            self.getNotifications()
        }
        
    }
    
    // Facebook Login Method
    
    
    @IBAction func FBLogin(_ sender: Any) {
        
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : LoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        
                        
                    }
                }
            }
        }
    }
    
    func getFBUserData(){
        
        let sv = HomeViewController.displaySpinner(onView: self.view)
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email,age_range"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    let dict = result as! [String : AnyObject]
                    print(dict)
                    if let dict = result as? [String : AnyObject]{
                        if(dict["email"] as? String == nil || dict["id"] as? String == nil || dict["email"] as? String == "" || dict["id"] as? String == "" ){
                            
                            HomeViewController.removeSpinner(spinner: sv)
                            
                            self.alertModule(title:"Error", msg:"You cannot login with this facebook account because your facebook is not linked with any email")
                            
                        }else{
                            HomeViewController.removeSpinner(spinner: sv)
                            self.email = dict["email"] as? String
                            self.first_name = dict["first_name"] as? String
                            self.last_name = dict["last_name"] as? String
                            self.my_id = dict["id"] as? String
                            self.signUPType = "facebook"
                            let dic1 = dict["picture"] as! NSDictionary
                            let pic = dic1["data"] as! NSDictionary
                            self.profile_pic = pic["url"] as? String
                            
                            
                            self.SignUpApi()
                            
                        }
                    }
                    
                }else{
                    
                    HomeViewController.removeSpinner(spinner: sv)
                    
                    
                }
            })
        }
        
    }
    
    // Gmail Login Method
    
    
    func GoogleApi(user: GIDGoogleUser!){
        
        let sv = HomeViewController.displaySpinner(onView: self.view)
        
        if(user.profile.email == nil || user.userID == nil || user.profile.email == "" || user.userID == ""){
            
            
            
            HomeViewController.removeSpinner(spinner: sv)
            self.alertModule(title:"Error", msg:"You cannot signup with this Google account because your Google is not linked with any email.")
            
        }else{
            
            
            HomeViewController.removeSpinner(spinner: sv)
            //SliderViewController.removeSpinner(spinner: sv)
            self.email = user.profile.email
            self.first_name = user.profile.givenName
            self.last_name = user.profile.familyName
            self.my_id = user.userID
            if user.profile.hasImage
            {
                let pic = user.profile.imageURL(withDimension: 100)
                self.profile_pic = pic!.absoluteString
                
            }else{
                self.profile_pic = ""
            }
            
            self.signUPType = "gmail"
            self.SignUpApi()
        }
        
        
    }
    
    // Signup Api
    
    func SignUpApi(){
        
        
        
        let  sv = HomeViewController.displaySpinner(onView: self.view)
        
        var VersionString:String! = ""
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            VersionString = version
        }
        
        let url : String = self.appDelegate.baseUrl!+self.appDelegate.signUp!
        
        let parameter:[String:Any]?  = ["fb_id":self.my_id!,"first_name":self.first_name!,"last_name":self.last_name!,"profile_pic":self.profile_pic!,"gender":"m","signup_type":self.signUPType!,"version":VersionString!,"device":"iOS"]
        
        print(url)
        print(parameter!)
        
        let headers: HTTPHeaders = [
            "api-key": "4444-3333-2222-1111"
            
        ]
        
        AF.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:headers).validate().responseJSON(completionHandler: {
            
            respones in
            
            switch respones.result {
            case .success( let value):
                
                let json  = value
                HomeViewController.removeSpinner(spinner: sv)
                print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! NSString
                if(code == "200"){
                    
                    let myCountry = dic["msg"] as? NSArray
                    if let data = myCountry![0] as? NSDictionary{
                        print(data)
                        
                        
                        let uid = data["fb_id"] as! String
                        
                        
                        UserDefaults.standard.set(uid, forKey: "uid")
                        
                        self.inner_view.alpha = 1
                        
                        self.navigationItem.title = "Notifications"
                        
                        self.tabBarController?.selectedIndex = 3
                        
                        
                        
                        
                        
                    }
                    
                }else{
                    
                    
                    self.alertModule(title:"Error", msg:dic["msg"] as! String)
                    
                }
                
                
            case .failure(let error):
                
                print(error)
                
                HomeViewController.removeSpinner(spinner: sv)
                self.alertModule(title:"Error",msg:error.localizedDescription)
                
                
            }
        })
        
        
    }
    
    
    func getNotifications(){
        
        let url : String = self.appDelegate.baseUrl!+self.appDelegate.getNotifications!
        
        let  sv = HomeViewController.displaySpinner(onView: self.view)
        let parameter :[String:Any]? = ["fb_id":UserDefaults.standard.string(forKey: "uid")!]
        
        print(url)
        //print(parameter!)
        
        let headers: HTTPHeaders = [
            "api-key": "4444-3333-2222-1111"
            
        ]
        
        AF.request(url, method: .post, parameters:parameter, encoding:JSONEncoding.default, headers:headers).validate().responseJSON(completionHandler: {
            
            respones in
            
            
            
            switch respones.result {
            case .success( let value):
                
                let json  = value
                
                HomeViewController.removeSpinner(spinner: sv)
                
                self.Notifications_Array = []
                print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! NSString
                if(code == "200"){
                    
                    if let myCountry = dic["msg"] as? [[String:Any]]{
                        
                        for Dict in myCountry {
                            let effected_fb_id:String! = ""
                            var first_name:String! = ""
                            var last_name:String! = ""
                            var profile_pic:String! = ""
                            var username:String! = ""
                            var type:String! = ""
                            
                            var v_id:String! = ""
                            var fb_id:String! = ""
                            
                            var Vvalue:String! = ""
                            
                            let myRestaurant = Dict as NSDictionary
                            
                            if  let my_id =   myRestaurant["fb_id"] as? String{
                                
                                fb_id = my_id
                            }
                            if  let my_value =   myRestaurant["value"] as? String{
                                
                                Vvalue = my_value
                            }
                            
                            if  let my_type =   myRestaurant["type"] as? String{
                                
                                type = my_type
                            }
                            if  let my_value_data =   myRestaurant["value_data"] as? NSDictionary{
                                
                                if  let my_video =   my_value_data["video"] as? String{
                                    
                                    v_id = my_video
                                }
                            }
                            
                            if let fb_id_details =   myRestaurant["fb_id_details"] as? NSDictionary{
                                if let my_first =   fb_id_details["first_name"] as? String{
                                    
                                    first_name = my_first
                                }
                                
                                if let my_last =   fb_id_details["last_name"] as? String{
                                    
                                    last_name = my_last
                                }
                                
                                if let my_pic =   fb_id_details["profile_pic"] as? String{
                                    profile_pic = my_pic
                                }
                                if let my_user =   fb_id_details["username"] as? String{
                                    username = my_user
                                }
                            }
                            
                            let obj = Notifications(effected_fb_id:effected_fb_id,first_name: first_name, last_name: last_name,profile_pic: profile_pic, v_id: v_id, username: username,type:type,fb_id: fb_id,Vvalue:Vvalue)
                            
                            
                            self.Notifications_Array.add(obj)
                            
                            
                        }
                        
                        if(self.Notifications_Array.count == 0){
                            self.outer_view.alpha = 1
                        }else{
                            self.outer_view.alpha = 0
                            self.tableview.delegate = self
                            self.tableview.dataSource = self
                            self.tableview.reloadData()
                        }
                        
                    }
                    
                }else{
                    
                    self.alertModule(title:"Error", msg:dic["msg"] as! String)
                    
                }
                
                
                
            case .failure(let error):
                print(error)
                HomeViewController.removeSpinner(spinner: sv)
                self.alertModule(title:"Error",msg:error.localizedDescription)
            }
        })
        
        
    }
    
    // Gmail Login Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.Notifications_Array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:FollowTableViewCell = self.tableview.dequeueReusableCell(withIdentifier: "cell01") as! FollowTableViewCell
        
        let obj = self.Notifications_Array[indexPath.row] as! Notifications
        
        cell.folow_name.text = obj.username
        if(obj.type == "video_like"){
            
            cell.folow_username.text = obj.first_name+" liked your video"
            cell.foolow_btn_view.alpha = 1
        }else{
            
            cell.folow_username.text = obj.first_name+"following you"
            cell.foolow_btn_view.alpha = 0
        }
        
        
        cell.follow_img.sd_setImage(with: URL(string:obj.profile_pic), placeholderImage: UIImage(named:"nobody_m.1024x1024"))
        cell.follow_img.layer.cornerRadius = cell.follow_img.frame.size.width / 2
        cell.follow_img.clipsToBounds = true
        
        cell.follow_view.layer.cornerRadius = cell.follow_view.frame.size.width / 2
        cell.follow_view.clipsToBounds = true
        
        cell.foolow_btn_view.layer.cornerRadius = 5
        cell.foolow_btn_view.clipsToBounds = true
        
        cell.btn_follow.tag = indexPath.item
        cell.btn_follow.addTarget(self, action: #selector(NotificationViewController.connected(_:)), for:.touchUpInside)
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let obj = self.Notifications_Array[indexPath.row] as! Notifications
        
        if(obj.fb_id != UserDefaults.standard.string(forKey: "uid")!){
            
            StaticData.obj.other_id = obj.fb_id
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let yourVC: Profile1ViewController = storyboard.instantiateViewController(withIdentifier: "Profile1ViewController") as! Profile1ViewController
            
            present(yourVC , animated: true, completion: nil)
        }else{
            
            self.tabBarController?.selectedIndex = 3
        }
    }
    
    @objc func connected(_ sender : UIButton) {
        
        print(sender.tag)
        
        let buttonTag = sender.tag
        
        let obj = self.Notifications_Array[buttonTag] as! Notifications
        //        StaticData.obj.userName = obj.first_name+" "+obj.last_name
        //                 StaticData.obj.userImg = obj.profile_pic
        //                 StaticData.obj.liked = "0"
        //                 StaticData.obj.like_count = "0"
        //                 StaticData.obj.soundName = "0"
        //                 StaticData.obj.videoID = obj.v_id
        //                StaticData.obj.other_id = obj.fb_id
        //                 DispatchQueue.main.async {
        //
        //                     let vc = self.storyboard?.instantiateViewController(withIdentifier: "DiscoverVideoViewController") as! DiscoverVideoViewController
        //
        //                     self.present(vc, animated: true, completion: nil)
        //                 }
        
        let url : String = self.appDelegate.baseUrl!+self.appDelegate.showAllVideos!
        
        let  sv = HomeViewController.displaySpinner(onView: self.view)
        let parameter :[String:Any]? = ["fb_id":obj.fb_id!,"video_id":obj.Vvalue!,"device_token":"Null"]
        
        print(url)
        print(parameter!)
        
        let headers: HTTPHeaders = [
            "api-key": "4444-3333-2222-1111"
            
        ]
        
        AF.request(url, method: .post, parameters:parameter, encoding:JSONEncoding.default, headers:headers).validate().responseJSON(completionHandler: {
            
            respones in
            
            
            
            switch respones.result {
            case .success( let value):
                
                let json  = value
                
                HomeViewController.removeSpinner(spinner: sv)
                
                // self.Follow_Array = []
                print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! NSString
                if(code == "200"){
                    
                    if let myCountry = dic["msg"] as? NSArray{
                        
                        
                        if  let sectionData = myCountry[0] as? NSDictionary{
                            
                            let count = sectionData["count"] as! NSDictionary
                            let sound = sectionData["sound"] as! NSDictionary
                            let Username = sectionData["user_info"] as! NSDictionary
                            
                            StaticData.obj.userName = Username["username"] as? String
                            StaticData.obj.userImg = Username["profile_pic"] as? String
                            StaticData.obj.liked = sectionData["liked"] as? String
                            UserDefaults.standard.set(sectionData["video"] as? String, forKey: "dis_url")
                            UserDefaults.standard.set(sectionData["thum"] as? String, forKey: "dis_img")
                            StaticData.obj.like_count = count["like_count"] as? String
                            StaticData.obj.soundName = sound["sound_name"] as? String
                            StaticData.obj.comment_count = count["video_comment_count"] as? String
                            StaticData.obj.videoID = sectionData["id"] as? String
                            StaticData.obj.other_id = sectionData["fb_id"] as? String
                            DispatchQueue.main.async {
                                
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "DiscoverVideoViewController") as! DiscoverVideoViewController
                                
                                self.present(vc, animated: true, completion: nil)
                            }
                        }
                    }
                }else{
                    
                    self.alertModule(title:"Error", msg:dic["msg"] as! String)
                    
                }
                
                
                
            case .failure(let error):
                print(error)
                HomeViewController.removeSpinner(spinner: sv)
                self.alertModule(title:"Error",msg:error.localizedDescription)
            }
        })
        
        
    }
    
    
    
    @IBAction func GoogleLogin(_ sender: Any) {
        
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    
    private func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        //UIActivityIndicatorView.stopAnimating()
    }
    
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if (error == nil) {
            // Perform any operations on signed in user here.
            self.GoogleApi(user: user)
            
            // ...
        } else {
            
            //            self.view.isUserInteractionEnabled = true
            //            KRProgressHUD.dismiss {
            //                print("dismiss() completion handler.")
            //
            //            }
            print("\(error.localizedDescription)")
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!){
        
        
        
    }
    
    
    @IBAction func privacy(_ sender: Any) {
        
        guard let url = URL(string: "https://termsfeed.com/privacy-policy/9a03bedc2f642faf5b4a91c68643b1ae") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func terms(_ sender: Any) {
        
        guard let url = URL(string: "https://termsfeed.com/terms-conditions/72b8fed5b38e082d48c9889e4d1276a9") else { return }
        UIApplication.shared.open(url)
        
    }
    
    func alertModule(title:String,msg:String){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    @available(iOS 13.0, *)
    @IBAction func Applelogin(_ sender: Any) {
        
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    @available(iOS 13.0, *)
    private func setupAppleIDCredentialObserver() {
        let authorizationAppleIDProvider = ASAuthorizationAppleIDProvider()
        authorizationAppleIDProvider.getCredentialState(forUserID: "currentUserIdentifier") { (credentialState: ASAuthorizationAppleIDProvider.CredentialState, error: Error?) in
            if let error = error {
                print(error)
                // Something went wrong check error state
                return
            }
            switch (credentialState) {
            case .authorized:
                //User is authorized to continue using your app
                print("User is authorized to continue using your app")
                break
            case .revoked:
                //User has revoked access to your app
                print("User has revoked access to your app")
                break
            case .notFound:
                //User is not found, meaning that the user never signed in through Apple ID
                print("User is not found, meaning that the user never signed in through Apple ID")
                break
            default: break
            }
        }
    }
    
    
    
}
extension NotificationViewController: ASAuthorizationControllerDelegate {
    @available(iOS 12.0, *)
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        
        print("User ID: \(appleIDCredential.user)")
        
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            print(appleIDCredential)
        case let passwordCredential as ASPasswordCredential:
            print(passwordCredential)
        default: break
        }
        
        if let userEmail = appleIDCredential.email {
            print("Email: \(userEmail)")
            self.email = userEmail
            self.my_id = appleIDCredential.user
        }
        
        if let userGivenName = appleIDCredential.fullName?.givenName,
            
            let userFamilyName = appleIDCredential.fullName?.familyName {
            //print("Given Name: \(userGivenName)")
            // print("Family Name: \(userFamilyName)",
            
            self.my_id = appleIDCredential.user
            self.first_name = userGivenName
            self.last_name = userFamilyName
            
            
        }
        
        
        
        if let authorizationCode = appleIDCredential.authorizationCode,
            let identifyToken = appleIDCredential.identityToken {
            print("Authorization Code: \(authorizationCode)")
            print("Identity Token: \(identifyToken)")
            //First time user, perform authentication with the backend
            //TODO: Submit authorization code and identity token to your backend for user validation and signIn
            //self.signUp(self)
            // if(self.email != ""){
            
            self.signUPType = "apple"
            self.profile_pic = ""
            self.SignUpApi()
            //                                      }else{
            //
            //                                       self.alertModule(title:"Error", msg: "Please share your email.")
            //                                   }
            return
        }
        //TODO: Perform user login given User ID

    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Authorization returned an error: \(error.localizedDescription)")
    }
}
extension NotificationViewController: ASAuthorizationControllerPresentationContextProviding {
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}
