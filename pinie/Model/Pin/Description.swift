//
//  Description.swift
//  pinie
//
//  Created by Rui Jin on 5/9/19.
//  Copyright © 2019 Rui Jin. All rights reserved.
//

import UIKit
import RealmSwift
@objcMembers class Description: Object {
    dynamic var name = ""
    dynamic var descriptionText = ""
    var parentPin = LinkingObjects(fromType: Pin.self, property: "details")
    convenience init(name:String, descriptionText:String){
        self.init()
        self.name = name
        self.descriptionText = descriptionText
    }
    
    
}
