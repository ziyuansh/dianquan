//
//  DateExtensions.swift
//  pinie
//
//  Created by Rui Jin on 5/3/19.
//  Copyright © 2019 Rui Jin. All rights reserved.
//

import UIKit

let now = Date()
extension Date{
    func timeAgoDisplay(timeStamp:Int)->String{
      
        let secondsAgo = Int(Date().timeIntervalSince1970) - timeStamp 
        let minute = 60
        let hour = 60 * 60
        let day = 24 * 60 * 60
        let month = 30 * day
        if secondsAgo < minute {
            return "\(secondsAgo)秒前"
        }
        else if secondsAgo < hour {
            return "\(secondsAgo/minute)分钟前"
        }
        else if secondsAgo < day {
            return "\(secondsAgo/hour)小时前"
        }
        else if secondsAgo < month {
            return "\(secondsAgo/day)天前"
        }
        else{
            return "\(secondsAgo/month)个月前"
        }
    }
    func getCurrentTimeStamp()->Int{
        let now = Date()
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return timeStamp
    }
    
    func convertTimeStamp(timeStamp:Int)->String{
        let timeInterval:TimeInterval = TimeInterval(timeStamp)
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss" //自定义日期格式
        let time = dateformatter.string(from: date as Date)
        return time
    }
    func convertDate(date:String)->Int{
        let datefmatter = DateFormatter()
        datefmatter.dateFormat="yyyy年MM月dd日 HH:mm:ss"
        let date = datefmatter.date(from: date)
        let dateStamp:TimeInterval = date!.timeIntervalSince1970
        let dateStr:Int = Int(dateStamp)
        return dateStr//时间转换的时间戳
    }
}
