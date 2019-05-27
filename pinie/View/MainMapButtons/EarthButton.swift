//
//  EarthButton.swift
//  pinie
//
//  Created by Rui Jin on 4/26/19.
//  Copyright © 2019 Rui Jin. All rights reserved.
//

import UIKit

class EarthButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func setDefault(){
        let EarthImage = UIImage(named: "earth")?.withRenderingMode(.alwaysTemplate)
        self.setImage(EarthImage, for: .normal)
        self.tintColor = UIColor(red:1.00, green:0.69, blue:0.15, alpha:1.0)
    }
}
