//
//  UIImageViewExtensions.swift
//  pinie
//
//  Created by Rui Jin on 5/25/19.
//  Copyright © 2019 Rui Jin. All rights reserved.
//

import UIKit

extension UIImageView {
    func makeAvatar(name:String){
        self.image = UIImage(named:name)
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
}
