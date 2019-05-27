//
//  BMKCluster.swift
//  BMKSwiftDemo
//
//  Created by Baidu RD on 2018/7/23.
//  Copyright © 2018年 Baidu. All rights reserved.
//

import UIKit

class BMKCluster: NSObject {
    var clusterAnnotations = [String:ClusterItem]()// NSMutableArray = NSMutableArray()
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var size: UInt {
        get {
            return UInt(clusterAnnotations.count)
        }
    }
}


