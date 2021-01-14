
import UIKit
import NVActivityIndicatorView
import SDWebImage

class SoundTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sound_type: UILabel!
    
    @IBOutlet weak var sound_name: UILabel!
    
    @IBOutlet weak var btn_favourites: UIButton!
    
    @IBOutlet weak var sound_img: UIImageView!
    
    @IBOutlet weak var outerview: UIView!
    
    @IBOutlet weak var btn_play: UIImageView!
    
    @IBOutlet weak var select_view: UIView!
    
    @IBOutlet weak var select_btn: UIButton!
    
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    
    @IBOutlet weak var innerview: UIView!
    
    @IBOutlet weak var btnFav: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        loaderView.type = .lineSpinFadeLoader
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
