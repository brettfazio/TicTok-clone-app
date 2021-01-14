

import UIKit
import Alamofire
import SDWebImage
import FirebaseDatabase
//import Firebase

class ChatViewController: UIViewController {
    @IBOutlet weak var msg_img: UIImageView!
    
    @IBOutlet weak var msg_name: UILabel!
    
    @IBOutlet weak var shadoview: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dropShadow()
        msg_img.layer.masksToBounds = false
        msg_img.layer.cornerRadius = msg_img.frame.height/2
        msg_img.clipsToBounds = true
        
      
        self.msg_img.sd_setImage(with: URL(string:StaticData.obj.receiver_img!), placeholderImage: UIImage(named: "nobody_m.1024x1024"))
        
        self.msg_name.text = StaticData.obj.receiver_name!
        
        
        
    }
    

    @IBAction func back(_ sender: Any) {
        
        self.dismiss(animated:false, completion:nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func dropShadow() {
        self.shadoview.layer.shadowColor = UIColor.lightGray.cgColor
        self.shadoview.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        self.shadoview.layer.shadowOpacity = 0.5
        self.shadoview.layer.shadowRadius = 4
        self.shadoview.layer.cornerRadius = 2
        self.shadoview.layer.masksToBounds = false
        
    }
    
    
    @IBAction func flag(_ sender: Any) {
        
        let actionSheet =  UIAlertController(title: nil, message:nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Report "+StaticData.obj.receiver_name!, style: .default, handler: {
            (_:UIAlertAction)in
           
        })
        
        let gallery = UIAlertAction(title: "Block", style: .destructive, handler: {
            (_:UIAlertAction)in
            
        })
    
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (_:UIAlertAction)in
          
        })
        actionSheet.addAction(camera)
        
        actionSheet.addAction(gallery)
        //actionSheet.addAction(Giphy)
        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true, completion: nil)
        
        
    }
    

}
