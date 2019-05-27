//
//  UIViewExtensions.swift
//  pinie
//
//  Created by Rui Jin on 4/26/19.
//  Copyright © 2019 Rui Jin. All rights reserved.
//

import UIKit

extension UIView {
    func addRoundedCorners(){
        layer.cornerRadius = 10
    }
    func addShadowCorner(){
        layer.cornerRadius = 10
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.7
    }
    func addShadowCorner2(){
        layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.3
    }
    func goLeft(){
        self.frame = CGRect(x: self.frame.origin.x, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.55)
        UIView.setAnimationCurve(.easeInOut)
        self.frame = CGRect(x: 0 , y: 0, width: self.frame.size.width, height: self.frame.size.height)
        UIView.commitAnimations()
        
       
//        UIView.animate(withDuration: 0.5, animations: {
//            self.transform = CGAffineTransform(translationX: 0 - UIScreen.main.bounds.width,y:0)
//        })
    }
    func goRight(){
        self.frame = CGRect(x: self.frame.origin.x, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.55)
        UIView.setAnimationCurve(.easeInOut)
        self.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        UIView.commitAnimations()
        
//        UIView.animate(withDuration: 0.5, animations: {
//            self.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width,y:0)
//        })
    }
    func FromMidToRight(){
        self.frame = CGRect(x: self.frame.origin.x, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.35)
        UIView.setAnimationCurve(.easeInOut)
        self.frame = CGRect(x: UIScreen.main.bounds.width, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        UIView.commitAnimations()
    }
    func FromMidToLeft(){
        self.frame = CGRect(x: self.frame.origin.x, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.35)
        UIView.setAnimationCurve(.easeInOut)
        self.frame = CGRect(x: 0 - UIScreen.main.bounds.width, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        UIView.commitAnimations()
    }
    func goBottom(){
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        UIView.setAnimationCurve(.easeInOut)
        self.frame = CGRect(x: self.frame.origin.x, y: UIScreen.main.bounds.height, width: self.frame.size.width, height: self.frame.size.height)
        UIView.commitAnimations()
    }
    func goMid(){
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        UIView.setAnimationCurve(.easeInOut)
        self.frame = CGRect(x: self.frame.origin.x, y: UIScreen.main.bounds.height/1.8, width: self.frame.size.width, height: self.frame.size.height)
        UIView.commitAnimations()
    }
    func goTop(){
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        UIView.setAnimationCurve(.easeInOut)
        self.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        UIView.commitAnimations()
    }
    func resetContraint(){
        
    }
}
