//
//  UIImageExtensions.swift
//  pinie
//
// //显示原始图片
//@IBAction func btn1Click(sender: AnyObject) {
//    imageView.image = image
//}
//
////将图片修改成指定尺寸（160*100）
//@IBAction func btn2Click(sender: AnyObject) {
//    let reSize = CGSize(width: 240, height: 150)
//    imageView.image = image?.reSizeImage(reSize)
//}
//
////将图片缩小成原来的一半
//@IBAction func btn3Click(sender: AnyObject) {
//    imageView.image = image?.scaleImage(0.5)
//}

//  Created by Rui Jin on 5/3/19.
//  Copyright © 2019 Rui Jin. All rights reserved.
//

import UIKit

extension UIImage {
    /**
     *  重设图片大小
     */
    func reSizeImage(reSize:CGSize)->UIImage {
        //UIGraphicsBeginImageContext(reSize);
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height));
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
    
    /**
     *  等比率缩放
     */
    func scaleImage(scaleSize:CGFloat)->UIImage {
        let reSize = CGSize(width: self.size.width * scaleSize, height: self.size.height * scaleSize)
        return reSizeImage(reSize: reSize)
    }
}
