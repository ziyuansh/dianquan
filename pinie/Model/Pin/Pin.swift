//
//  Pin.swift
//  pinie
//
//  Created by Rui Jin on 4/27/19.
//  Copyright © 2019 Rui Jin. All rights reserved.
//

import Foundation
import RealmSwift
@objcMembers class Pin: Object{
    dynamic var id:String = ""
    dynamic var title:String = ""
    dynamic var subTitle:String = ""
    var coord = List<Double>()
    var images = List<String>()
    var details = List<Description>()
    var icon:String = ""
    var isStarred:Bool = false
    var comments = List<Comment>()
    var attributes = List<Attribute>()
    dynamic var timeStamp:Int = 0
    dynamic var isSearchResult:Bool = false
    var parentUser = LinkingObjects(fromType: UserModel.self, property: "pins")
    convenience init(id:String, title:String, subTitle:String, coord:List<Double>, images:List<String>, icon:String, isStarred:Bool, comments:List<Comment>, attributes:List<Attribute>, timeStamp:Int){
        self.init()
        self.id = id
        self.title = title
        self.subTitle = subTitle
        self.coord = coord
        self.images = images
        self.icon = icon
        self.isStarred = isStarred
        self.comments = comments
        self.attributes = attributes
        self.timeStamp = timeStamp
    }
    override static func primaryKey() -> String? {
        return "id"
    }
}

