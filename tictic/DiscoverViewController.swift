

import UIKit
import Alamofire
import SDWebImage
import ContentLoader

class DiscoverViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate,ContentLoaderDataSource {
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var search: UISearchBar!
    
    @IBOutlet weak var tableview: UITableView!
    
    
    var video_array =  [Discover]()
    
    var filtered = [Discover]()
    var searchActive : Bool = false
    
    var Newssection:NSMutableArray = []
    
    var loadingToggle:String? = "yes"
    var refreshControl = UIRefreshControl()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        MARK:- SEARCH BAR FORMAT
        self.search.delegate = self
        
//        self.search.searchTextField.layer.masksToBounds = true
        if let textfield = search.value(forKey: "searchField") as? UITextField {

//            textfield.backgroundColor = UIColor.yellow
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])

            textfield.textColor = UIColor.black

            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = UIColor.black
            }
        }
        
        tableview.tableFooterView = UIView()
        self.getVideos()
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "")
        self.refreshControl.addTarget(self, action: #selector(DiscoverViewController.refresh), for: UIControl.Event.valueChanged)
        self.tableview?.addSubview(refreshControl)
      
        //self.tableview.isLoadable = true
        
        
      var format = ContentLoaderFormat()
          format.color = "#F6F6F6".hexColor
          format.radius = 5
          format.animation = .fade
      
        
        //self.tableview.startLoading(format: format)
        
        //self.tableview.startLoading()
        
        
              
              
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
    
    @objc func refresh(sender:AnyObject) {
        loadingToggle = "no"
        self.getVideos()
    }
    
    // get a sigle video api
    
    func getVideos(){
        
      
        
        var sv = UIView()
        
        let url : String = self.appDelegate.baseUrl!+self.appDelegate.discover!
      
        
        if(loadingToggle == "yes"){
            
            //sv = HomeViewController.displaySpinner(onView: self.view)
         

            
        }
        
        let parameter :[String:Any]? = ["fb_id":UserDefaults.standard.string(forKey: "uid")!]
        
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
                
                //self.tableview.hideLoading()
                
                self.video_array = []
                self.Newssection = []
                print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! NSString
                if(code == "200"){

                    if let myCountry = dic["msg"] as? NSArray{
                        for i in 0...myCountry.count-1{
                            
                            if  let sectionData = myCountry[i] as? NSDictionary{
                               let tempMenuObj = Discover()
                                tempMenuObj.name = sectionData["section_name"] as? String
                                self.Newssection.add(tempMenuObj.name!)
                                if let extraData = sectionData["sections_videos"] as? NSArray{
                                    
                                    for j in 0...extraData.count-1{
                                        let dic2 = extraData[j] as! [String:Any]
                                        
                                        var tempProductList = ItemVideo()

                                        if let count = dic2["count"] as? NSDictionary{

                                            tempProductList.like_count = count["like_count"] as? String

                                            tempProductList.video_comment_count = count["video_comment_count"] as? String
                                        }
                                        
                                        if let user_info = dic2["user_info"] as? NSDictionary{
                                            
                                            tempProductList.first_name = user_info["username"] as? String
                                            
                                            tempProductList.last_name = user_info["last_name"] as? String
                                            
                                            tempProductList.profile_pic = user_info["profile_pic"] as? String
                                            
                                             tempProductList.u_id = user_info["id"] as? String
                                        }
                                        
                                        
                                            tempProductList.video = dic2["video"] as? String
                                           tempProductList.thum = dic2["gif"] as? String
                                            tempProductList.liked = dic2["liked"] as? String
                                         tempProductList.v_id = dic2["id"] as? String
                                        
                                        if let sound = dic2["sound"] as? NSDictionary{
                                            
                                            tempProductList.sound_name = sound["sound_name"] as? String
                                             
                                        }
                                        
                                        
                                        
                                            tempMenuObj.listOfProducts.append(tempProductList)
                                   
                                    }
                               
                                    }
                                
                                    self.video_array.append(tempMenuObj)
                                }
                            
                            }
                            
                    }
                    
                  
                    self.refreshControl.endRefreshing()
                    self.tableview.delegate = self
                    self.tableview.dataSource = self
                    self.tableview.reloadData()




                }else{
                    self.refreshControl.endRefreshing()
                    self.alertModule(title:"Error", msg:dic["msg"] as! String)

                }
                
                
                
            case .failure(let error):
                print(error)
                self.refreshControl.endRefreshing()
               // self.tableview.hideLoading()

                //to hide the loader
                
                self.alertModule(title:"Error",msg:error.localizedDescription)
            }
        })
        
        
    }
    
   
  // tableview Delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.searchActive == true){
            return filtered.count
        }else{
        return video_array.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:dicoverTableCell = self.tableview.dequeueReusableCell(withIdentifier: "ditaCell") as! dicoverTableCell
        if(self.searchActive == true){
        
        let obj = self.filtered[indexPath.row]
         
        cell.dis_label.text = obj.name
        
            
            let layout = UICollectionViewFlowLayout()
            
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 5
            layout.minimumInteritemSpacing = 5
            layout.sectionInset = UIEdgeInsets(top:0, left: 0, bottom: 0, right: 0)
            
            
            cell.collectionview.collectionViewLayout = layout
        
        cell.collectionview.dataSource = self
        cell.collectionview.delegate = self
        cell.collectionview.reloadData()
        cell.collectionview.tag = indexPath.row
      
    }else{
    let obj = self.video_array[indexPath.row]
    
    cell.dis_label.text = obj.name
    
            let layout = UICollectionViewFlowLayout()
             
            
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 5
            layout.minimumInteritemSpacing = 5
            layout.sectionInset = UIEdgeInsets(top:0, left: 0, bottom: 0, right: 0)
            
            
            cell.collectionview.collectionViewLayout = layout
            cell.collectionview.dataSource = self
            cell.collectionview.delegate = self
            cell.collectionview.reloadData()
            cell.collectionview.tag = indexPath.row
    }
        
        return cell
    
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 190
        
    }
    
    func numSections(in contentLoaderView: UIView) -> Int {
           return 1
       }

       /// Number of rows you would like to show in loader
       func contentLoaderView(_ contentLoaderView: UIView, numberOfItemsInSection section: Int) -> Int {
           return 10
       }

       /// Cell reuse identifier you would like to use (ContenLoader will search loadable objects here!)
       func contentLoaderView(_ contentLoaderView: UIView, cellIdentifierForItemAt indexPath: IndexPath) -> String {
           return "ditaCell"
       }
    
    // Collectionview Delegate methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(searchActive == true){
            
            return self.filtered[collectionView.tag].listOfProducts.count
        }else{
           
            return self.video_array[collectionView.tag].listOfProducts.count
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell:discoverCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "dicocell", for: indexPath) as! discoverCollectionCell
        
        if(self.searchActive == true){
        
        let obj:ItemVideo = filtered[collectionView.tag].listOfProducts[indexPath.row]
            
            
            cell.tik_img.layer.masksToBounds = false
           
  //          cell.tik_img.layer.cornerRadius = 4
            cell.tik_img.clipsToBounds = true
       
        cell.tik_img.sd_setImage(with: URL(string:obj.thum), placeholderImage: UIImage(named:"Spinner-1s-200px.gif"))
           
        }else{
            let obj:ItemVideo = video_array[collectionView.tag].listOfProducts[indexPath.row]
            
            cell.tik_img.layer.masksToBounds = false
            
    //        cell.tik_img.layer.cornerRadius = 4
            cell.tik_img.clipsToBounds = true
            
            print(obj.thum)
            
            cell.tik_img.sd_setImage(with: URL(string:obj.thum), placeholderImage: UIImage(named:"Spinner-1s-200px.gif"))
        }
        
        return cell
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(self.searchActive == true){

        let obj =  self.filtered[collectionView.tag].listOfProducts[indexPath.row]
        UserDefaults.standard.set(obj.video, forKey: "dis_url")
        UserDefaults.standard.set(obj.thum, forKey: "dis_img")
        StaticData.obj.userName = "@"+obj.first_name
        StaticData.obj.userImg = obj.profile_pic
        StaticData.obj.liked = obj.liked
        StaticData.obj.comment_count = obj.video_comment_count
        StaticData.obj.like_count = obj.like_count
        StaticData.obj.soundName = obj.sound_name
        StaticData.obj.videoID = obj.v_id
       StaticData.obj.other_id = obj.u_id
            
        DispatchQueue.main.async {

            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DiscoverVideoViewController") as! DiscoverVideoViewController
           
            self.present(vc, animated: true, completion: nil)
        }
        }else{
            let obj =  self.video_array[collectionView.tag].listOfProducts[indexPath.row]
            UserDefaults.standard.set(obj.video, forKey: "dis_url")
            UserDefaults.standard.set(obj.thum, forKey: "dis_img")
            StaticData.obj.userName = obj.first_name+" "+obj.last_name
            StaticData.obj.userImg = obj.profile_pic
            StaticData.obj.liked = obj.liked
            StaticData.obj.comment_count = obj.video_comment_count
            StaticData.obj.like_count = obj.like_count
            StaticData.obj.soundName = obj.sound_name
            StaticData.obj.videoID = obj.v_id
            StaticData.obj.other_id = obj.u_id
            DispatchQueue.main.async {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "DiscoverVideoViewController") as! DiscoverVideoViewController
                
                self.present(vc, animated: true, completion: nil)
            }
        }


    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width:collectionView.layer.bounds.width/3.5, height: collectionView.layer.bounds.width/2.2)
        
    }
    
//    MARK:- Line spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
  
    
    // search bar delegate methods
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        
        searchActive = false;
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchActive = false;
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        
        searchBar.showsCancelButton = true
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = []
        searchActive = true;
        
        if((self.video_array.count) > 0){
            for i in 0...(video_array.count)-1{
                let obj = video_array[i]
                if obj.name.lowercased().range(of:searchText.lowercased()) != nil {
                    
                    self.filtered.append(obj)
                    
                }
            }
        }
        
        
        print(filtered)
        
        
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableview.reloadData()
        
    }
    
    
    
    
    
    func alertModule(title:String,msg:String){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
 

}
