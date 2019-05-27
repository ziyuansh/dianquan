//
//  BMKClusterManager.swift
//  BMKSwiftDemo
//
//  Created by Baidu RD on 2018/7/23.
//  Copyright © 2018年 Baidu. All rights reserved.
//

import UIKit

class BMKClusterManager: NSObject {
    var clusterCaches = NSMutableArray()
    var quadItems = [BMKQuadItem]()
    var quadtree = BMKClusterQuadtree(rect: CGRect.zero)
//    var loadMainMap: (()->())?
//    var loadFriendMap: (()->())?
    override init() {
    }
    func loadMainMap(){
        clusterCaches.removeAllObjects()
        quadItems.removeAll()
        for _ in 3..<22 {
            clusterCaches.add(NSMutableArray())
        }
        quadtree = BMKClusterQuadtree(rect: CGRect(x: 0, y: 0, width: 1, height: 1))
//        quadItems = [BMKQuadItem]()
        let friendList = UserFunctions().getFriendList()
        let userInfo = UserFunctions().getMyInfo()
        for friend in friendList!{
            for pin in friend.starredPins{
                let coordinate = CLLocationCoordinate2D(latitude: pin.coord[0], longitude: pin.coord[1])
                let quadItem = BMKQuadItem()
                quadItem.pinId = pin.id
                quadItem.pin = pin
                quadItem.UserId = friend.id
                quadItem.coordinate = coordinate
                objc_sync_enter(quadtree)
                quadItems.append(quadItem)
                quadtree.addItem(quadItem: quadItem)
                objc_sync_exit(quadtree)
            }
        }
        for pin in userInfo.starredPins{
            let coordinate = CLLocationCoordinate2D(latitude: pin.coord[0], longitude: pin.coord[1])
            let quadItem = BMKQuadItem()
            quadItem.pinId = pin.id
            quadItem.pin = pin
            quadItem.UserId = userInfo.id
            quadItem.coordinate = coordinate
            objc_sync_enter(quadtree)
            quadItems.append(quadItem)
            quadtree.addItem(quadItem: quadItem)
            objc_sync_exit(quadtree)
        }
        
    }
    func loadPinsFrom(user:UserModel){
        clusterCaches.removeAllObjects()
        quadItems.removeAll()
        for _ in 3..<22 {
            clusterCaches.add(NSMutableArray())
        }
        quadtree = BMKClusterQuadtree(rect: CGRect(x: 0, y: 0, width: 1, height: 1))
//        quadItems = [BMKQuadItem]()
        for pin in user.pins{
            let coordinate = CLLocationCoordinate2D(latitude: pin.coord[0], longitude: pin.coord[1])
            let quadItem = BMKQuadItem()
            quadItem.pinId = pin.id
            quadItem.pin = pin
            quadItem.UserId = user.id
            quadItem.coordinate = coordinate
            objc_sync_enter(quadtree)
            quadItems.append(quadItem)
            quadtree.addItem(quadItem: quadItem)
            objc_sync_exit(quadtree)
        }
    }
    func loadPinsFromResult(pins:[Pin]){
        clusterCaches.removeAllObjects()
        quadItems.removeAll()
        for _ in 3..<22 {
            clusterCaches.add(NSMutableArray())
        }
        quadtree = BMKClusterQuadtree(rect: CGRect(x: 0, y: 0, width: 1, height: 1))
        //        quadItems = [BMKQuadItem]()
        for pin in pins{
           
            let quadItem = SearchBMKQuadItem()
            if let pinTemp = UserFunctions().getPinInfo(id: pin.id){
                 let coordinate = CLLocationCoordinate2D(latitude: pinTemp.coord[0], longitude: pinTemp.coord[1])
                quadItem.pinId = pinTemp.id
                quadItem.pin = pinTemp
                quadItem.coordinate = coordinate
                quadItem.address = pinTemp.details[0].descriptionText
            }
            else{
                let coordinate = CLLocationCoordinate2D(latitude: pin.coord[0], longitude: pin.coord[1])
                quadItem.pinId = pin.id
                quadItem.pin = pin
                quadItem.coordinate = coordinate
                quadItem.address = pin.details[0].descriptionText
            }
            objc_sync_enter(quadtree)
            quadItems.append(quadItem)
            quadtree.addItem(quadItem: quadItem)
            objc_sync_exit(quadtree)
        }
    }
    func getClusters(zoomLevel: CGFloat) -> [BMKCluster] {
        if zoomLevel < 3 || zoomLevel > 22 {
            return [BMKCluster]()
        }
        
        let results = NSMutableArray()
        
        let zoomSpecificSpan = 100 / pow(2, zoomLevel) / 256
        let visitedCandidates = NSMutableSet()
        let distanceToCluster = NSMutableDictionary()
        let itemToCluster = NSMutableDictionary()
        
        objc_sync_enter(quadtree)
        for candidate in quadItems {
            //candidate已经添加到另一cluster中
            if visitedCandidates.contains(candidate) {
                continue
            }
            let cluster = BMKCluster()
            cluster.coordinate = candidate.coordinate
            
            let searchRect = getRectWithPt(pt: candidate.pt, span: zoomSpecificSpan)
            let items: [BMKQuadItem] = quadtree.searchInRect(searchRect: searchRect) as! [BMKQuadItem]
            if items.count == 1 {
                let coor = candidate.coordinate
                //let value: NSValue = NSValue(bytes: &coor, objCType: "CLLocationCoordinate2D")
                //test
                let clusterItem = ClusterItem()
                clusterItem.clusterItemCoor = coor
                clusterItem.pinId = items[0].pinId
                clusterItem.pin = items[0].pin
                clusterItem.userId = items[0].UserId
                cluster.clusterAnnotations[items[0].pinId] = clusterItem
                //test
                results.add(cluster)
                visitedCandidates.add(candidate)
                distanceToCluster.setObject(NSNumber(value: 0), forKey: NSNumber(value: candidate.hash))
                continue
            }
            
            for quadItem in items {
                let existDistache: NSNumber? = distanceToCluster.object(forKey: NSNumber(value: quadItem.hash)) as? NSNumber
                let distance = getDistanceSquared(pt: candidate.pt, otherPt: quadItem.pt)
                
                if let _ = existDistache {
                    if existDistache!.doubleValue < Double(distance) {
                        continue
                    }
                    let existCluster: BMKCluster = itemToCluster.object(forKey: NSNumber(value: quadItem.hash)) as! BMKCluster
                    _ = quadItem.coordinate
                    //let value: NSValue = NSValue(bytes: &coor, objCType: "CLLocationCoordinate2D")
                    existCluster.clusterAnnotations.removeValue(forKey: quadItem.pinId)
                }
                distanceToCluster.setObject(NSNumber(value: 0), forKey: NSNumber(value: quadItem.hash))
                let coor = quadItem.coordinate
                //let value: NSValue = NSValue(bytes: &coor, objCType: "CLLocationCoordinate2D")
                let clusterItem = ClusterItem()
                clusterItem.clusterItemCoor = coor
                clusterItem.pin = quadItem.pin
                clusterItem.pinId = quadItem.pinId
                clusterItem.userId = quadItem.UserId
                cluster.clusterAnnotations[quadItem.pinId] = clusterItem
                itemToCluster.setObject(NSNumber(value: 0), forKey: NSNumber(value: quadItem.hash))
            }
            visitedCandidates.addObjects(from: items)
            results.add(cluster)
        }
        objc_sync_exit(quadtree)
        return results as! [BMKCluster]
    }
    
    func getRectWithPt(pt: CGPoint, span: CGFloat) -> CGRect {
        let half = span / 2
        return CGRect(x: pt.x - half, y: pt.y - half, width: span, height: span)
    }
    
    func getDistanceSquared(pt: CGPoint, otherPt: CGPoint) -> CGFloat {
        return pow(pt.x - otherPt.x, 2) + pow(pt.y - otherPt.y, 2)
    }
    
  
}
