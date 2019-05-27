//
//  Attribute.swift
//  pinie
//
//  Created by ziyuan Shan on 5/19/19.
//  Copyright © 2019 Rui Jin. All rights reserved.
//

import UIKit
import RealmSwift
@objcMembers class Attribute: Object {
    dynamic var attribute = ""
    dynamic var infomation = ""
    convenience init(attribute:String, infomation:String){
        self.init()
        self.attribute = attribute
        self.infomation = infomation
    }
    
    
}
