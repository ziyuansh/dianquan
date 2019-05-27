//
//  User.swift
//  pinie
//
//  Created by Rui Jin on 4/27/19.
//  Copyright © 2019 Rui Jin. All rights reserved.
//

import UIKit
import RealmSwift
class UserFunctions{
    func getUserInfo(id:String)->UserModel?{
        let realm = try! Realm()
        let me = realm.objects(MyData.self).first?.userInfo
        if me!.id == id{
            return me
        }
        if let userInfo = realm.object(ofType: UserModel.self, forPrimaryKey: id){
            return userInfo
        }
        return nil
    }

    func getPinInfo(id:String)->Pin?{
        let realm = try! Realm()
        if let pin = realm.object(ofType: Pin.self, forPrimaryKey: id){
            return pin
        }
        return nil
    }
    func getPinsUsers(id:String)->LinkingObjects<UserModel>?{
        let realm = try! Realm()
        if let pin = realm.object(ofType: Pin.self, forPrimaryKey: id){
            return pin.parentUser
        }
        return nil
    }
    func getFriendList()->List<UserModel>?{
        let realm = try! Realm()
        let results = realm.objects(MyData.self)
        return results[0].friendList
    }
    func getMyInfo()->UserModel{
        let realm = try! Realm()
        let me = realm.objects(MyData.self).first?.userInfo
        return me!
    }
    func addPin(pin:Pin){
        let realm = try! Realm()
        let me = realm.objects(MyData.self).first?.userInfo
        try! realm.write {
            me!.pins.append(pin)
        }
    }
}
