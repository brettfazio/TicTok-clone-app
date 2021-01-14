//
//  Utility.swift
//  SuperMarket
//
//  Created by macbook on 10/31/16.
//  Copyright © 2016 MCIT. All rights reserved.
//

import UIKit
import FullMaterialLoader
import CoreLocation
import PhoneNumberKit
//import FBSDKCoreKit
//import FBSDKLoginKit
//import Foundation
//import  LanguageManager_iOS
import NVActivityIndicatorView
import Foundation
import Photos

protocol DatePickerDelegate {
    func timePicked(time: String)
}



//import Reachability

let AppUtility =  Utility.sharedUtility()
let phoneNumberKit = PhoneNumberKit()
let ud = UserDefaults.standard
var indicatorHud = MaterialLoadingIndicator(frame: CGRect(x:0, y:0, width: 50, height: 50))
var hudContainer = UIView(frame: CGRect(x:0, y:0, width: 50, height: 50))


struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
        isSim = true
        #endif
        return isSim
    }()
}

//MARK:- Server URL Definition
let imageDownloadUrl  = ""

//MARK:- Loading Colour
let strloadingColour = "FFCC02"

//MARK:- User Defaults Keys
let strToken = "strToken"
let strAPNSToken = "strAPNSToken"
let strDate = "strDate"
let strURL = "strURL"
let strPicURL = ""
let InternetConnected = "InternetConnected"
var isVerifiedPhone = "0"

var isUpated = false
var sstrCode = ""
var sstrflag = ""
var sstrPhoneNumber = ""

let delegate:AppDelegate = UIApplication.shared.delegate as!  AppDelegate

var loader = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: nil, color: nil, padding: nil)


//MARK:- Utility Initialization Methods
class Utility: NSObject {
    
    func displayAlert(title: String, message: String) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alertController.view.tintColor = #colorLiteral(red: 0.7568627451, green: 0.2784313725, blue: 0.2745098039, alpha: 1)
        guard let viewController = UIApplication.shared.keyWindow?.rootViewController else
        {
            fatalError("keyWindow has no rootViewController")
        }

        viewController.present(alertController, animated: true, completion: nil)
    }
    
//    Mark:- check whether image is gif or not
    func isAnimatedImage(_ imageUrl: URL) -> Bool {
        if let data = try? Data(contentsOf: imageUrl),
            let source = CGImageSourceCreateWithData(data as CFData, nil) {
            
            let count = CGImageSourceGetCount(source)
            return count > 1
        }
        return false
    }
    
// Mark:-   Convert concatinate url with BASEURL
    func detectURL(ipString:String)-> String{
        let input = ipString
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))

        if matches.isEmpty{
            return imgBaseUrl+ipString
        }else{
        
            var urlString = ""
            for match in matches {
                guard let range = Range(match.range, in: input) else { continue }
                let url = input[range]
                print(url)
                
                urlString = String(url)
            }
            
            return urlString
        }

    }
    //    MARK:- add device data
    func addDeviceData(){
        
        let uid = UserDefaults.standard.string(forKey: "userID")
        let fcm = UserDefaults.standard.string(forKey: "DeviceToken")
        let ip = getIPAddress()
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let deviceType = "iOS"

        
        ApiHandler.sharedInstance.addDeviceData(user_id: uid!, device: deviceType, version: appVersion!, ip: ip, device_token: fcm!) { (isSuccess, response) in
            if isSuccess{
                
                if response?.value(forKey: "code") as! NSNumber == 200{
                    print("Data of Device Added: ",response?.value(forKey: "msg"))
                }else{
                    print("!200: ",response?.value(forKey: "msg"))
                }
                
            }
        }
    }
    
    func startLoader(view: UIView){
         
        loader = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), type: .lineSpinFadeLoader, color: .white, padding: view.frame.width * 0.46)
        
        print("view.frame.width: ",view.frame.width * 0.46)

        loader.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.6)
        
        
        view.addSubview(loader)
         loader.startAnimating()
    }
    func stopLoader(view: UIView){
        
        DispatchQueue.main.async { // Correct
           loader.removeFromSuperview()
        }
        loader.stopAnimating()

        
    }
    

    
    //var fbLogin:FBSDKLoginManager!
    var datePickerDelegate : DatePickerDelegate?
    class func sharedUtility()->Utility!
    {
        struct Static
        {
            static var sharedInstance:Utility?=nil;
            static var onceToken = 0
        }
        Static.sharedInstance = self.init();
        return Static.sharedInstance!
    }
    required override init() {
    
    }
    
    //MARK:- Get Date Method
    func getDateFromUnixTime(_ unixTime:String) -> String {
        let date = Date(timeIntervalSince1970: Double(unixTime)!)
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let currentTime =  formatter.string(from: date as Date)
        return currentTime;
    }
    
    func getAgeYears(birthday:String)-> Int{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd,MMMM yyyy" //"dd-MM-yyyy"
        let birthdate = formatter.date(from: birthday)
        let now = Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthdate!, to: now)
        let age = ageComponents.year!
        return age
    }
    
    func showDatePicker(fromVC : UIViewController){
        
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 250)
        let pickerView = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        pickerView.datePickerMode = .date
        //pickerView.locale = NSLocale(localeIdentifier: "\(Formatter.getInstance.getAppTimeFormat().rawValue)") as Locale
        vc.view.addSubview(pickerView)
        
        let alertCont = UIAlertController(title: "Choose Date", message: "", preferredStyle: UIAlertController.Style.alert)
        
        alertCont.setValue(vc, forKey: "contentViewController")
        let setAction = UIAlertAction(title: "Select", style: .default) { (action) in
            if self.datePickerDelegate != nil{
                //let selectedTime = Formatter.getInstance.convertDateToTime(date: pickerView.date)
                //self.datePickerDelegate!.timePicked(time: selectedTime)
                
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                formatter.timeZone = TimeZone.current
                let selectedTime = formatter.string(from: pickerView.date)
                self.datePickerDelegate!.timePicked(time: selectedTime)
            }
        }
        alertCont.addAction(setAction)
        alertCont.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        fromVC.present(alertCont, animated: true)
    }
    // MARK:- Phone Number Validation Check
    func isValidPhoneNumber(strPhone:String) -> Bool{
        do {
            _ = try phoneNumberKit.parse(strPhone)
            return true
        }
        catch {
            print("Generic parser error")
            return false
        }
    }
    
    //MARK: Check Internet
    func connected() -> Bool
    {
        let reachibility = Reachability.forInternetConnection()
        let networkStatus = reachibility?.currentReachabilityStatus()
        
        return networkStatus != NotReachable
        
    }
    
    //MARK:- Validation Text
    func hasValidText(_ text:String?) -> Bool
    {
        if let data = text
        {
            let str = data.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if str.count>0
            {
                return true
            }
            else
            {
                return false
            }
        }
        else
        {
            return false
        }
        
    }
    
    //MARK:- Validation Atleast 1 special schracter or number
    
    func checkTextHaveChracterOrNumber( text : String) -> Bool{
        
        
        //        let text = text
        //        let capitalLetterRegEx  = ".*[A-Z]+.*"
        //        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        //        let capitalresult = texttest.evaluate(with: text)
        //        print("\(capitalresult)")
        
        
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberresult = texttest1.evaluate(with: text)
        print("\(numberresult)")
        
        
        let specialCharacterRegEx  = ".*[!&^%$#@()/]+.*"
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        
        let specialresult = texttest2.evaluate(with: text)
        print("\(specialresult)")
        
        //return capitalresult || numberresult || specialresult
        return numberresult || specialresult
        
    }
    
    //MARK:- Validation Email
    func isEmail(_ email:String  ) -> Bool
    {
        let strEmailMatchstring = "\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"
        let regExPredicate = NSPredicate(format: "SELF MATCHES %@", strEmailMatchstring)
        if(!isEmpty(email as String?) && regExPredicate.evaluate(with: email))
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    
    //MARK:- Validation Empty
    func isEmpty(_ thing : String? )->Bool {
        
        if (thing?.count == 0) {
            return true
        }
        return false;
    }
    
    //MARK:- CNIC Validation
    func isValidIdentityNumber(_ value: String) -> Bool {
        guard
            value.count == 11,
            let digits = value.map({ Int(String($0)) }) as? [Int],
            digits[0] != 0
            else { return false }
        
        let check1 = (
            (digits[0] + digits[2] + digits[4] + digits[6] + digits[8]) * 7
                - (digits[1] + digits[3] + digits[5] + digits[7])
            ) % 10
        
        guard check1 == digits[9] else { return false }
        
        let check2 = (digits[0...8].reduce(0, +) + check1) % 10
        
        return check2 == digits[10]
    }
    //MARK:- Show Alert
    func displayAlert(title titleTxt:String, messageText msg:String, delegate controller:UIViewController) ->()
    {
        let alertController = UIAlertController(title: titleTxt, message: msg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        controller.present(alertController, animated: true, completion: nil)
        alertController.view.tintColor = UIColor(named:strloadingColour )
        
    }
    
    /*//MARK:- Customize Textfield for mulitple language
     func CustomizetextField(tf:CustomTextField,Padding:CGFloat){
     if LanguageManager.shared.currentLanguage == .ar {
     tf.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
     tf.textAlignment = .right
     tf.paddingRight = Padding
     tf.paddingLeft = 0
     }else{
     tf.semanticContentAttribute = UISemanticContentAttribute.forceLeftToRight
     tf.textAlignment = .left
     tf.paddingLeft = Padding
     tf.paddingRight = 0
     }
     }
     //MARK:- Customize Button for mulitple language
     func CustomizeButton(btn:CustomButton){
     if LanguageManager.shared.currentLanguage == .ar {
     btn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
     }else{
     btn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
     }
     }
     
     //MARK:- Customize label for mulitple language
     func CustomizeLabel(lbl:UILabel){
     if LanguageManager.shared.currentLanguage == .ar {
     lbl.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
     lbl.textAlignment = .right
     
     }else{
     lbl.semanticContentAttribute = UISemanticContentAttribute.forceLeftToRight
     lbl.textAlignment = .left
     }
     }*/
    
    //MARK:- Color with HEXA
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    //MARK:- Get & Set Methods For UserDefaults
    
    func saveObject(obj:String,forKey strKey:String){
        ud.set(obj, forKey: strKey)
    }
    
    func getObject(forKey strKey:String) -> String {
        if let obj = ud.value(forKey: strKey) as? String{
            let obj2 = ud.value(forKey: strKey) as! String
            return obj2
        }else{
            return ""
        }
    }
    
    func deleteObject(forKey strKey:String) {
        ud.set(nil, forKey: strKey)
    }
    
    //MARK:- FullMaterialLoader Hud Methods
    
    func showHud(viewHud:UIView, hudColor:String){
        hudContainer.frame = viewHud.frame
        hudContainer.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        hudContainer.isUserInteractionEnabled = false
        indicatorHud.indicatorColor = [self.hexStringToUIColor(hex: hudColor).cgColor]
        indicatorHud.center = viewHud.center
        //viewHud.isUserInteractionEnabled = false
        hudContainer.addSubview(indicatorHud)
        viewHud.addSubview(hudContainer)
        indicatorHud.startAnimating()
    }
    
    func hideHud(viewHud:UIView){
        indicatorHud.stopAnimating()
        hudContainer.removeFromSuperview()
        //viewHud.isUserInteractionEnabled = true
    }
    
    //MARK: Add Delay
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    //MARK: Calculate Time
    
    func timeAgoSinceDate(_ date:Date,currentDate:Date, numericDates:Bool) -> String {
        let calendar = Calendar.current
        let now = currentDate
        let earliest = (now as NSDate).earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
        
    }
    
    func calculateTimeDifference(start: String) -> String {
        let formatter = DateFormatter()
        //        2018-12-17 18:01:34
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var startString = "\(start)"
        if startString.count < 4 {
            for _ in 0..<(4 - startString.count) {
                startString = "0" + startString
            }
        }
        let currentDateTime = Date()
        let strcurrentDateTime = formatter.string(from: currentDateTime)
        var endString = "\(strcurrentDateTime)"
        if endString.count < 4 {
            for _ in 0..<(4 - endString.count) {
                endString = "0" + endString
            }
        }
        let startDate = formatter.date(from: startString)!
        let endDate = formatter.date(from: endString)!
        let difference = endDate.timeIntervalSince(startDate)
        if (difference / 3600) > 24{
            let differenceInDays = Int(difference/(60 * 60 * 24 ))
            return "\(differenceInDays) DAY AGO"
        }else{
            return "\(Int(difference) / 3600)HOURS \(Int(difference) % 3600 / 60)MIN AGO"
        }
    }
    
    func offsetFrom(dateFrom : Date,dateTo:Date) -> String {
        
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: dateFrom, to: dateTo);
        
        let seconds = "\(difference.second ?? 0)s"
        let minutes = "\(difference.minute ?? 0)m" + ":" + seconds
        let hours = "\(difference.hour ?? 0)h" + ":" + minutes
        let days = "\(difference.day ?? 0)d" + ":" + hours
        
        if let day = difference.day, day          > 0 { return days }
        if let hour = difference.hour, hour       > 0 { return hours }
        if let minute = difference.minute, minute > 0 { return minutes }
        if let second = difference.second, second > 0 { return seconds }
        return ""
    }
    
    //MARK: Random Number
    func getCurrentMillis()->Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    //MARK: Send Notification
    /*func sendPushNotification(body: [String : Any]) {
     print("push body",body)
     //let paramString  = ["to" : token, "notification" : ["title" : "Group Tag", "body" : "You recieved cake"]/*, "data" : ["user" : self.myUser![0].email]*/] as [String : Any]
     
     let urlString = "https://fcm.googleapis.com/fcm/send"
     let url = NSURL(string: urlString)!
     let request = NSMutableURLRequest(url: url as URL)
     request.httpMethod = "POST"
     let json = try! JSONSerialization.data(withJSONObject: body, options: [.prettyPrinted])
     let outString = String(data:json, encoding:.utf8)
     
     print("outstring",outString!)
     request.setValue("application/json", forHTTPHeaderField: "Content-Type")
     request.setValue("key=AIzaSyBhZyP653nt4vu3insFqTK7I0c5RAk4voM", forHTTPHeaderField: "Authorization")
     //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
     request.httpBody = json
     
     let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
     do {
     print("task",response!)
     if let jsonData = data {
     let outString = String(data:jsonData, encoding:.utf8)
     print("out",outString!)
     if let jsonDataDict = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [String: AnyObject] {
     NSLog("Received data:\n\(jsonDataDict))")
     }
     }
     } catch let err as NSError {
     print(err.debugDescription)
     }
     }
     task.resume()
     }*/
    
    //MARK: Location
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        if !self.connected(){
            return
        }
        //var addressString : String = ""
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    print(pm.country)
                    print(pm.locality)
                    print(pm.subLocality)
                    print(pm.thoroughfare)
                    print(pm.postalCode)
                    print(pm.subThoroughfare)
                    if pm.locality != nil {
                        //addressString = addressString + pm.subLocality! + ", "
                        //User have option to chnage his city
                        //strCurrentCityName = pm.locality!
                    }
                    if pm.country != nil {
                        //  strCurrentCountryName = pm.country!
                    }
                    NotificationCenter.default.post(name: Notification.Name("LocationGeoCoding"), object: nil)
                    /*if pm.thoroughfare != nil {
                     addressString = addressString + pm.thoroughfare! + ", "
                     }
                     if pm.locality != nil {
                     addressString = addressString + pm.locality! + ", "
                     }
                     if pm.country != nil {
                     addressString = addressString + pm.country! + ", "
                     }
                     if pm.postalCode != nil {
                     addressString = addressString + pm.postalCode! + " "
                     }*/
                    //print(addressString)
                }
        })
    }
    
    func getIPAddress() -> String {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }
                
                guard let interface = ptr?.pointee else { return "" }
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    
                    // wifi = ["en0"]
                    // wired = ["en2", "en3", "en4"]
                    // cellular = ["pdp_ip0","pdp_ip1","pdp_ip2","pdp_ip3"]
                    
                    let name: String = String(cString: (interface.ifa_name))
                    if  name == "en0" || name == "en2" || name == "en3" || name == "en4" || name == "pdp_ip0" || name == "pdp_ip1" || name == "pdp_ip2" || name == "pdp_ip3" {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface.ifa_addr, socklen_t((interface.ifa_addr.pointee.sa_len)), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return address ?? ""
    }
    
}
extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

