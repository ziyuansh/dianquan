//
//  UserModel.swift
//  pinie
//
//  Created by Rui Jin on 4/27/19.
//  Copyright © 2019 Rui Jin. All rights reserved.
//

import Foundation
import RealmSwift
@objcMembers class UserModel:Object{
    dynamic var id:String = ""
    dynamic var name:String = ""
    dynamic var avatar:String = ""
    var pins = List<Pin>()
    var wishPins = List<Pin>()
    var starredPins = List<Pin>()
    dynamic var exp:Int = 0
    var followers = List<String>()
    var followings = List<String>()
    var friends = List<UserModel>()
    convenience init(id:String, name:String, avatar:String, pins:List<Pin>, starredPins:List<Pin>, exp:Int, followers:List<String>, followings:List<String>, friends:List<UserModel>) {
        self.init()
        self.id = id
        self.name = name
        self.avatar = avatar
        self.pins = pins
        self.starredPins = starredPins
        self.exp = exp
        self.followers = followers
        self.followings = followings
        self.friends = friends
    }
    override static func primaryKey() -> String? {
        return "id"
    }
}
