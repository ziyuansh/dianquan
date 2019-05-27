//
//  AppDelegate.swift
//  pinie
//
//  Created by Rui Jin on 4/26/19.
//  Copyright © 2019 Rui Jin. All rights reserved.
//

import UIKit
import RealmSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var _mapManager: BMKMapManager = {return BMKMapManager()}()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        _mapManager = BMKMapManager()
        // 如果要关注网络及授权验证事件，请设定generalDelegate参数
        let ret = _mapManager.start("qzfzRqGQ95kla4R0nbijlKTjiYxWtCRc",
                                     generalDelegate: nil)
        if ret == false {
            NSLog("manager start failed!")
        }
        
        let obj1 = List<Double>()
        obj1.append(30.664131)
        obj1.append(104.072893)
        let obj2 = List<Double>()
        obj2.append(30.665684)
        obj2.append(104.062969)
        let obj3 = List<Double>()
        obj3.append(30.670095)
        obj3.append(104.059735)
        let obj4 = List<Double>()
        obj4.append(30.664038)
        obj4.append(104.086145)
        let obj5 = List<Double>()
        obj5.append(30.678823)
        obj5.append(104.079785)
        let obj6 = List<Double>()
        obj6.append(30.678823)
        obj6.append(104.079785)
        let obj7 = List<Double>()
        obj7.append(30.656834)
        obj7.append(104.086828)
        let img1 = List<String>()
        img1.append("https://i.imgur.com/SsJmZ9jl.jpg")
        img1.append("https://i.imgur.com/SsJmZ9jl.jpg")
        img1.append("https://i.imgur.com/SsJmZ9jl.jpg")
        
        //fake comment data
        let comment1 = Comment(sender: "090265c0-3d4a-47c2-a021-4003e4a6ca12", receiver: "090265c0-3d4a-47c2-a021-4003e4a6ca13", content: "万逸-天府广场")
        let comment2 = Comment(sender: "090265c0-3d4a-47c2-a021-4003e4a6ca13", receiver: "090265c0-3d4a-47c2-a021-4003e4a6ca14", content: "罗佳宁-人民公园")
        let comment3 = Comment(sender: "090265c0-3d4a-47c2-a021-4003e4a6ca14", receiver: "090265c0-3d4a-47c2-a021-4003e4a6ca15", content: "单子渊-宽窄巷子!")
        let comment4 = Comment(sender: "090265c0-3d4a-47c2-a021-4003e4a6ca15", receiver: "090265c0-3d4a-47c2-a021-4003e4a6ca15", content: "陈箫月 王府井!")
        let comment5 = Comment(sender: "090265c0-3d4a-47c2-a021-4003e4a6ca16", receiver: "090265c0-3d4a-47c2-a021-4003e4a6ca15", content: "钱力-文殊院 babe!")
        let comment6 = Comment(sender: "090265c0-3d4a-47c2-a021-4003e4a6ca11", receiver: "090265c0-3d4a-47c2-a021-4003e4a6ca15", content: "晋瑞-文殊院 babe!")
        let comment7 = Comment(sender: "090265c0-3d4a-47c2-a021-4003e4a6ca12", receiver: "090265c0-3d4a-47c2-a021-4003e4a6ca15", content: "万逸-春熙路小龙坎火锅")
//        let commentWY = Comment(sender: "090265c0-3d4a-47c2-a021-4003e4a6ca12", receiver: "090265c0-3d4a-47c2-a021-4003e4a6ca15", content: "Hello babe!")
//        let commentLJN = Comment(sender: "090265c0-3d4a-47c2-a021-4003e4a6ca12", receiver: "090265c0-3d4a-47c2-a021-4003e4a6ca15", content: "Hello babe!")
        let commentList1 = List<Comment>()
        let commentList2 = List<Comment>()
        let commentList3 = List<Comment>()
        let commentList4 = List<Comment>()
        let commentList5 = List<Comment>()
        let commentList6 = List<Comment>()
        let commentList7 = List<Comment>()
        commentList1.append(comment1)
        commentList2.append(comment2)
        commentList2.append(comment2)
        commentList3.append(comment3)
        commentList3.append(comment3)
        commentList3.append(comment3)
        commentList4.append(comment4)
        commentList5.append(comment5)
        commentList6.append(comment6)
        commentList7.append(comment7)
        
        
        let attribute1 = Attribute(attribute: "人均", infomation: "100元")
        let attribute2 = Attribute(attribute: "环境", infomation: "超棒，适合约会")
        let attribute3 = Attribute(attribute: "服务", infomation: "慢死了")
        let attributeList1 = List<Attribute>()
        let attributeList2 = List<Attribute>()
        attributeList1.append(attribute1)
        attributeList1.append(attribute2)
        attributeList1.append(attribute3)
        attributeList2.append(attribute1)
        attributeList2.append(attribute2)
        
        let Pin1 = Pin(id:"190265c0-3d4a-47c2-a021-4003e4a6ca12", title:"天府广场", subTitle:"我爱天府广场❤️", coord: obj1, images: img1, icon: "", isStarred: true, comments: commentList1, attributes: attributeList1, timeStamp: Date().getCurrentTimeStamp() - 10)//1
        let Pin2 = Pin(id:"290265c0-3d4a-47c2-a021-4003e4a6ca12",title:"人民公园", subTitle:"我爱人民公园❤️", coord: obj2, images: img1, icon: "", isStarred: true, comments: commentList2, attributes: attributeList1, timeStamp: Date().getCurrentTimeStamp() - 100)//2
        let Pin3 = Pin(id:"390265c0-3d4a-47c2-a021-4003e4a6ca12", title:"宽窄巷子", subTitle:"我爱宽窄巷子❤️", coord: obj3, images: img1, icon: "", isStarred: true, comments: commentList3, attributes: attributeList1, timeStamp: Date().getCurrentTimeStamp() - 7300)//3
        let Pin4 = Pin(id:"490265c0-3d4a-47c2-a021-4003e4a6ca12", title:"王府井", subTitle:"我爱王府井❤️", coord: obj4, images: img1, icon: "", isStarred: true, comments: commentList4, attributes: attributeList2, timeStamp: Date().getCurrentTimeStamp() - 87000)//1
        let Pin5 = Pin(id:"590265c0-3d4a-47c2-a021-4003e4a6ca12", title:"文殊院", subTitle:"我爱文殊院❤️", coord: obj5, images: img1, icon: "", isStarred: true, comments: commentList5, attributes: attributeList2, timeStamp: Date().getCurrentTimeStamp() - 87000*60)//1
        let Pin6 = Pin(id:"690265c0-3d4a-47c2-a021-4003e4a6ca12", title:"文殊院", subTitle:"我爱文殊院❤️", coord: obj6, images: img1, icon: "", isStarred: true, comments: commentList6, attributes: attributeList2, timeStamp: Date().getCurrentTimeStamp() - 87000*60)//1
        let Pin7 = Pin(id:"1b11011fe05f8f21b05c6acb", title:"春熙路小龙坎火锅", subTitle:"安逸啊", coord: obj7, images: img1, icon: "", isStarred: true, comments: commentList7, attributes: attributeList1, timeStamp: Date().getCurrentTimeStamp() - 87000*60)//1
        let description = Description()
        description.name = "address"
        description.descriptionText = "四川省成都市东大街下东大街36号蓝光郁金香花园广场2层"
        Pin7.details.append(description)
        let listPin1 = List<Pin>()
        listPin1.append(Pin1)
        listPin1.append(Pin7)
        let listPin2 = List<Pin>()
        listPin2.append(Pin2)
        let listPin3 = List<Pin>()
        listPin3.append(Pin3)
        let listPin4 = List<Pin>()
        listPin4.append(Pin4)
        let listPin5 = List<Pin>()
        listPin5.append(Pin5)
        let listPin6 = List<Pin>()
        listPin6.append(Pin6)
        let friends = List<UserModel>()
        let followers = List<String>()
        let followings = List<String>()
        let user1 = UserModel(id: "090265c0-3d4a-47c2-a021-4003e4a6ca12", name: "万逸", avatar: "1", pins: listPin1, starredPins: listPin1, exp: 10, followers: followers, followings: followings, friends: friends)
        let user2 = UserModel(id: "090265c0-3d4a-47c2-a021-4003e4a6ca13", name: "罗佳宁", avatar: "2", pins: listPin2, starredPins: listPin2, exp: 10, followers: followers, followings: followings, friends: friends)
        let user3 = UserModel(id: "090265c0-3d4a-47c2-a021-4003e4a6ca14", name: "单子渊", avatar: "3", pins: listPin3, starredPins: listPin3, exp: 10, followers: followers, followings: followings, friends: friends)
        let user4 = UserModel(id: "090265c0-3d4a-47c2-a021-4003e4a6ca15", name: "陈箫月", avatar: "4", pins: listPin4, starredPins: listPin4, exp: 10, followers: followers, followings: followings, friends: friends)
        let user5 = UserModel(id: "090265c0-3d4a-47c2-a021-4003e4a6ca16", name: "钱力", avatar: "5", pins: listPin5, starredPins: listPin5, exp: 10, followers: followers, followings: followings, friends: friends)
        let me = UserModel(id: "090265c0-3d4a-47c2-a021-4003e4a6ca11", name: "晋瑞", avatar: "6", pins: listPin6, starredPins: listPin6, exp: 10, followers: followers, followings: followings, friends: friends)
        let dataSource = MyData(userInfo: me)
//        for _ in 0..<100 {
//            let dou = List<Double>()
//            let lat: Double = Double((arc4random() % 100)) * 0.001
//            let lon: Double = Double((arc4random() % 100)) * 0.001
//            dou.append(lat + 30.665684)
//            dou.append(lon + 104.062969)
//            let pinRandom = Pin(id: UUID().uuidString, title: "test", subTitle: "test", coord: dou, images: img1, icon: "", isStarred: true, timeStamp: Date().getCurrentTimeStamp() - 87000*60)
//            listPin1.append(pinRandom)
//        }
        dataSource.friendList.append(user1)
        dataSource.friendList.append(user2)
        dataSource.friendList.append(user3)
        dataSource.friendList.append(user4)
        dataSource.friendList.append(user5)
        print(Realm.Configuration.defaultConfiguration.fileURL)
        do {
            let realm = try Realm()
            try  realm.write {
                realm.add(dataSource, update: true)
            }
        }
        catch{
            print("Error initializing new realm")
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

