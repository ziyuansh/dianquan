//
//  SearchPOIViewController.swift
//  pinie
//
//  Created by Rui Jin on 5/11/19.
//  Copyright © 2019 Rui Jin. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON

class SearchPOIViewController: UIViewController {
    var dataArray: NSMutableArray = NSMutableArray()
//    var searchPOI:(([BMKPointAnnotation])->())?
    var pins = [Pin]()
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var keywords: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var cityName: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBAction func pressSearchButton(_ sender: UIButton) {
        popView.goBottom()
        setupDefaultData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        cityName.text = "成都"
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        popView.layer.cornerRadius = 10
        popView.layer.masksToBounds = true
        searchButton.addRoundedCorners()
        cancelButton.addRoundedCorners()
        // Do any additional setup after loading the view.
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func alertMessage(_ message: String) {
        let alert = UIAlertController(title: "检索结果", message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "我知道了", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension SearchPOIViewController: BMKMapViewDelegate, BMKPoiSearchDelegate{
    func searchData(_ option: BMKPOICitySearchOption) {
        //初始化BMKPoiSearch实例
        let POISearch = BMKPoiSearch()
        //设置POI检索的代理
        POISearch.delegate = self
        //初始化请求参数类BMKCitySearchOption的实例
        let cityOption = BMKPOICitySearchOption()
        //检索关键字，必选。举例：天安门
        cityOption.keyword = option.keyword
        //区域名称(市或区的名字，如北京市，海淀区)，最长不超过25个字符，必选
        cityOption.city = option.city
        //检索分类，与keyword字段组合进行检索，多个分类以","分隔。举例：美食,酒店
        cityOption.tags = option.tags
        //区域数据返回限制，可选，为true时，仅返回city对应区域内数据
        cityOption.isCityLimit = option.isCityLimit
        /**
         POI检索结果详细程度
         
         BMK_POI_SCOPE_BASIC_INFORMATION: 基本信息
         BMK_POI_SCOPE_DETAIL_INFORMATION: 详细信息
         */
        cityOption.scope = option.scope
        //检索过滤条件，scope字段为BMK_POI_SCOPE_DETAIL_INFORMATION时，filter字段才有效
        cityOption.filter = option.filter
        //分页页码，默认为0，0代表第一页，1代表第二页，以此类推
        cityOption.pageIndex = option.pageIndex
        //单次召回POI数量，默认为10条记录，最大返回20条
        cityOption.pageSize = option.pageSize
        /**
         城市POI检索：异步方法，返回结果在BMKPoiSearchDelegate的onGetPoiResult里
         
         cityOption 城市内搜索的搜索参数类（BMKCitySearchOption）
         成功返回YES，否则返回NO
         */
        let flag = POISearch.poiSearch(inCity: cityOption)
        if flag {
            NSLog("POI城市内检索成功")
        } else {
            NSLog("POI城市内检索失败")
        }
    }
    func setupDefaultData() {
        //初始化请求参数类BMKCitySearchOption的实例
        let cityOption = BMKPOICitySearchOption()
        //区域名称(市或区的名字，如北京市，海淀区)，最长不超过25个字符，必选
        cityOption.city = cityName.text
        //检索关键字
        cityOption.keyword = keywords.text
        print(cityOption.keyword)
        searchData(cityOption)
    }
    //MARK:BMKPoiSearchDelegate
    /**
     POI检索返回结果回调
     
     @param searcher 检索对象
     @param poiResult POI检索结果列表
     @param error 错误码
     */
    func onGetPoiResult(_ searcher: BMKPoiSearch, result poiResult: BMKPOISearchResult, errorCode: BMKSearchErrorCode) {
        if Int(errorCode.rawValue) == 8{
            let alert = UIAlertController(title: "提示", message: "网络好像出问题了", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "好的", style: .default, handler: { action in
               self.dismiss(animated: false)
            }))
            present(alert, animated: true, completion: nil)
        }
        if errorCode == BMK_SEARCH_NO_ERROR {
            
            //BMKSearchErrorCode错误码，BMK_SEARCH_NO_ERROR：检索结果正常返回
            if errorCode == BMK_SEARCH_NO_ERROR {
                for index in 0..<poiResult.poiInfoList.count {
                    //POI信息类的实例
                    let POIInfo = poiResult.poiInfoList[index]
                    //初始化标注类BMKPointAnnotation的实例
                    let dou = List<Double>()
                    dou.append(POIInfo.pt.latitude)
                    dou.append(POIInfo.pt.longitude)
                    let img1 = List<String>()
                    img1.append("https://i.imgur.com/SsJmZ9jl.jpg")
                    img1.append("https://i.imgur.com/SsJmZ9jl.jpg")
                    img1.append("https://i.imgur.com/SsJmZ9jl.jpg")
                    let details = List<Description>()
                    let description = Description()
                    description.name = "address"
                    description.descriptionText = POIInfo.address ?? ""
                    details.append(description)
                    let commentList = List<Comment>()
                    let attributeList = List<Attribute>()
                    let url = "http://map.baidu.com/detail?qt=ninf&uid="+POIInfo.uid
                    print(url)
                    Alamofire.request(url).responseJSON { response in
                       
                        let json = JSON(response.result.value)
                        let menus = json["content"]["ext"]["detail_info"]["image"]//["featured_menus"]
                        for (key,subJson):(String, JSON) in menus{
                            if img1.count == 5{
                                break;
                            }
                            if subJson["imgs"] != ""{
                                 img1.append(subJson["imgs"].string!)
                            }
                        }
                        let pin = Pin(id: POIInfo.uid ?? "", title: POIInfo.name ?? "", subTitle: POIInfo.tag ?? "", coord: dou, images: img1, icon: "", isStarred: false, comments: commentList, attributes: attributeList, timeStamp: Date().getCurrentTimeStamp())
                        pin.isSearchResult = true
                        pin.details = details
                        //设置标注的经纬度坐标
                        self.pins.append(pin)
                        if index == poiResult.poiInfoList.count - 1{
                            if self.pins.count != 0{
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue:"loadSearchResults"), object:self)
                            }
                            self.dismiss(animated: false)
                            print(self.pins)
                        }
                    }
                   
                }
            }
        }
       
       
        
    }
    func combineStrings(_ POIResult: BMKPOISearchResult) -> String {
        let info = POIResult.poiInfoList[0]
        var basicMessage = String(format: "检索结果总数：%ld\n总页数：%ld\n当前页的结果数：%ld\n当前页的页数索引：%ld\n纬度：%f\n经度：%f\n", POIResult.totalPOINum, POIResult.totalPageNum, POIResult.curPOINum, POIResult.curPageIndex, info.pt.latitude, info.pt.longitude)
        if let _ = info.name {
            basicMessage += String(format: "名称：%@\n", info.name)
        }
        if let _ = info.address {
            basicMessage += String(format: "地址：%@\n", info.address)
        }
        if let _ = info.phone {
            basicMessage += String(format: "电话：%@\n", info.phone)
        }
        if let _ = info.uid {
            basicMessage += String(format: "UID：%@\n", info.uid)
        }
        if let _ = info.province {
            basicMessage += String(format: "省份：%@\n", info.province)
        }
        if let _ = info.city {
            basicMessage += String(format: "城市：%@\n", info.city)
        }
        if let _ = info.area {
            basicMessage += String(format: "行政区域：%@\n", info.area)
        }
        if let _ = info.streetID {
            basicMessage += String(format: "街景图ID：%@\n", info.streetID)
        }
        if  info.hasDetailInfo {
            basicMessage += String(format: "有详情信息\n")
        }
        var detailMessage = ""
        if info.hasDetailInfo {
            let detailInfo: BMKPOIDetailInfo = info.detailInfo
            detailMessage = String(format: "距离中心点的距离：%ld\n导航引导点坐标纬度：%f\n导航引导点坐标经度：%f\n商户的价格：%f\n总体评分：%f\n口味评分：%f\n服务评分：%f\n环境评分：%f\n星级评分：%f\n卫生评分：%f\n技术评分：%f\n图片数目：%ld\n团购数目：%ld\n优惠数目：%ld\n评论数目：%ld\n收藏数目：%ld\n签到数目：%ld", detailInfo.distance, detailInfo.naviLocation.latitude, detailInfo.naviLocation.longitude, detailInfo.price, detailInfo.overallRating, detailInfo.tasteRating, detailInfo.serviceRating, detailInfo.environmentRating, detailInfo.facilityRating, detailInfo.hygieneRating, detailInfo.technologyRating, detailInfo.imageNumber, detailInfo.grouponNumber, detailInfo.discountNumber, detailInfo.commentNumber, detailInfo.favoriteNumber, detailInfo.checkInNumber)
            if let _ = detailInfo.type {
                detailMessage += String(format: "类型：%@\n", detailInfo.type)
            }
            if let _ = detailInfo.tag {
                detailMessage += String(format: "标签：%@\n", detailInfo.tag)
            }
            if let _ = detailInfo.detailURL {
                detailMessage += String(format: "详情页URL：%@\n", detailInfo.detailURL)
            }
            if let _ = detailInfo.openingHours {
                detailMessage += String(format: "营业时间：%@\n", detailInfo.openingHours)
            }
        }
        return basicMessage + detailMessage
    }
    
}
