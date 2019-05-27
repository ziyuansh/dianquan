//
//  Comment.swift
//  pinie
//
//  Created by Rui Jin on 4/27/19.
//  Copyright © 2019 Rui Jin. All rights reserved.
//

import Foundation
import RealmSwift
@objcMembers class Comment: Object{
    dynamic var sender:String = ""
    dynamic var receiver:String = ""
    dynamic var content:String = ""
    let timeStamp:Int = Date().getCurrentTimeStamp()
    var parentPin = LinkingObjects(fromType: Pin.self, property: "comments")
    convenience init(sender:String, receiver:String, content:String){
        self.init()
        self.sender = sender
        self.receiver = receiver
        self.content = content
        
    }
}
