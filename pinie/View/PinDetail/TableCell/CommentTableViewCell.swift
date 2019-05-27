//
//  CommentTableViewCell.swift
//  pinie
//
//  Created by ziyuan Shan on 5/11/19.
//  Copyright © 2019 Rui Jin. All rights reserved.
//

import UIKit
import RealmSwift

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var avaterImage: UIImageView!
    @IBOutlet weak var timestampLabel: UILabel!
    
    var comment = Comment()
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
