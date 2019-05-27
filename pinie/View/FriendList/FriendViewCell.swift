//
//  FriendViewCell.swift
//  pinie
//
//  Created by Rui Jin on 4/28/19.
//  Copyright © 2019 Rui Jin. All rights reserved.
//

import UIKit

class FriendViewCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var newPin: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var timeAgo: UILabel!
    var loadMap: (()->Int)?
    @IBAction func mapButtonTapped(_ sender: UIButton) {
        mapButton.showsTouchWhenHighlighted = true
        let result = loadMap?()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadPin"), object: result)
    }
    @IBAction func messageButtonTapped(_ sender: UIButton) {
        messageButton.showsTouchWhenHighlighted = true
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        messageButton.addRoundedCorners()
        messageButton.titleLabel?.adjustsFontForContentSizeCategory = true
        messageButton.imageView?.adjustsImageSizeForAccessibilityContentSizeCategory = true
        mapButton.addRoundedCorners()
        avatar.layer.cornerRadius = avatar.frame.height/2
        avatar.clipsToBounds = true
        // Initialization code
        self.cardView.addShadowCorner()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        // Configure the view for the selected state
   }

}
