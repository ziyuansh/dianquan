//
//  AttributeTableViewCell.swift
//  pinie
//
//  Created by ziyuan Shan on 5/11/19.
//  Copyright © 2019 Rui Jin. All rights reserved.
//

import UIKit

class AttributeTableViewCell: UITableViewCell {
    @IBOutlet weak var attributeLabel: UILabel!
    @IBOutlet weak var informationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
