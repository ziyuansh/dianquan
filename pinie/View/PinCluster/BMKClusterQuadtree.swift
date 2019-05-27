//
//  BMKClusterQuadtree.swift
//  BMKSwiftDemo
//
//  Created by Baidu RD on 2018/10/18.
//  Copyright © 2018年 Baidu. All rights reserved.
//

import UIKit

class BMKQuadItem: NSObject {
    var pt: CGPoint = CGPoint()
    var coor: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var pinId:String!
    var pin:Pin!
    var UserId:String!
    var coordinate: CLLocationCoordinate2D {
        get {
            return coor
        }
        set {
            coor = newValue
            pt = convertCoordinateToPoint(coor: coor)
        }
    }
    
    func convertCoordinateToPoint(coor: CLLocationCoordinate2D) -> CGPoint {
        let x: Double = coor.longitude / 360.0 + 0.5
        let siny: Double = sin(coor.latitude * Double.pi / 180.0)
        let y: Double = 0.5 * log((1 + siny) / (1 - siny)) / -(2 * Double.pi) + 0.5
        return CGPoint(x: x, y: y)
    }
}

class BMKClusterQuadtree: NSObject {
    //四叉树区域
    var rect: CGRect = CGRect()
    //所包含BMKQuadItem
    var quadItems: [BMKQuadItem] = [BMKQuadItem]()
    var childrens: [BMKClusterQuadtree] = [BMKClusterQuadtree]()
    
    init(rect: CGRect) {
        quadItems = NSMutableArray(capacity: 40) as! [BMKQuadItem]
        self.rect = rect
    }
    func removeAll(){
        
    }
    //四叉树拆分
    func subdivide() {
        childrens = NSMutableArray(capacity: 4) as! [BMKClusterQuadtree]
        let x = Double(rect.origin.x)
        let y = Double(rect.origin.y)
        let width = Double(rect.size.width / 2.0)
        let height = Double(rect.size.height / 2.0)
        childrens.append(BMKClusterQuadtree.init(rect: CGRect(x: x, y: y, width: width, height: height)))
        childrens.append(BMKClusterQuadtree.init(rect: CGRect(x: x + width, y: y, width: width, height: height)))
        childrens.append(BMKClusterQuadtree.init(rect: CGRect(x: x, y: y + height, width: width, height: height)))
        childrens.append(BMKClusterQuadtree.init(rect: CGRect(x: x + width, y: y + height, width: width, height: height)))
    }
    
    //插入数据
    func addItem(quadItem: BMKQuadItem) {
        if rect.contains(quadItem.pt) == false {
            return
        }
        if quadItems.count < 40 {
            quadItems.append(quadItem)
            return
        }
        if childrens.count == 0 {
            subdivide()
        }
        
        for child in childrens {
            child.addItem(quadItem: quadItem)
        }
    }
    
    //获取rect范围内的BMKQuadItem
    func searchInRect(searchRect: CGRect) -> NSMutableArray {
        //searchrect和四叉树区域rect无交集
        if searchRect.intersects(rect) == false {
            return NSMutableArray()
        }
        let array = NSMutableArray()
        //searchrect包含四叉树区域
        if searchRect.contains(rect) {
            array.addObjects(from: quadItems)
        } else {
            for item in quadItems {
                if searchRect.contains(item.pt) {
                    array.add(item)
                }
            }
        }
        if childrens.count == 4 {
            for child in childrens {
                array.addObjects(from: child.searchInRect(searchRect: searchRect) as! [Any])
            }
        }
        return array
    }
    
}
