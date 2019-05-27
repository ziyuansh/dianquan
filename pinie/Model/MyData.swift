//
//  Data.swift
//  pinie
//
//  Created by Rui Jin on 4/27/19.
//  Copyright © 2019 Rui Jin. All rights reserved.
//

import Foundation
import RealmSwift
@objcMembers class MyData: Object{
    var id:String = "as"
    var friendList = List<UserModel>()
//    static var starredPin = [Pin]()
//    static var userInfo = UserModel(id: "090265c0-3d4a-47c2-a021-4003e4a6ca20", name: "钱力", avatar: "4", pins: [:], wishPins: [:],starredPins:[], exp:10, followers:[], followings:[], friends:[], userSetting:[:])
    dynamic var userInfo:UserModel!
    convenience init(userInfo:UserModel) {
        self.init()
        self.userInfo = userInfo
    }
    override static func primaryKey() -> String? {
        return "id"
    }
}
