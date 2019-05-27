//
//  UIButtonExtension.swift
//  pinie
//
//  Created by Rui Jin on 5/5/19.
//  Copyright © 2019 Rui Jin. All rights reserved.
//

import UIKit
extension UIButton {
    func lightVibrate(){
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
}
