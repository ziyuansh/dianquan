//
//  ViewController.swift
//  pinie
//
//  Created by Rui Jin on 4/26/19.
//  Copyright © 2019 Rui Jin. All rights reserved.
//

import UIKit
import Realm
class ViewController: UIViewController, BMKMapViewDelegate{
    var onWhichPage = onPage.map
    var onWhichStatus = mapStatus.mainMap
    enum onPage {
        case map, friendsList, myList
    }
    enum mapStatus{
        case friendMap, myMap, mainMap, searchPage
    }
    @IBOutlet weak var friendsButton: friendsButton!
    @IBOutlet weak var mapTitle: UILabel!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var earthButton: EarthButton!
    @IBOutlet weak var earthBack: UIView!
    @IBOutlet weak var friendBack: UIView!
    @IBOutlet weak var meButton: meButton!
    @IBOutlet weak var meBack: UIView!
    @IBOutlet weak var backToMainMapButton: UIButton!
    var myListView: UIView!
    var friendsListView: UIView!
    var PinDetailView: UIView!
    var PinDetailViewVC: UIViewController!
    @IBAction func pressBackToMainMap(_ sender: UIButton) {
        loadMainPins()
        backToMainMapButton.isHidden = true
        earthButton.lightVibrate()
        mapTitle.text = "点圈"
        let center = CLLocationCoordinate2D(latitude: 30.664131, longitude: 104.072893)
        let span = BMKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        _ = BMKCoordinateRegion(center: center, span: span)
        onWhichPage = onPage.map
        onWhichStatus = mapStatus.mainMap
        PinDetailView?.goBottom()
//        searchPinDetailView?.goBottom()
    }
    @IBAction func pressFriendsButton(_ sender: UIButton) {
        //style
        friendsButton.lightVibrate()
        meButton.isUserInteractionEnabled = true
        earthButton.isUserInteractionEnabled = true
        friendsButton.isUserInteractionEnabled = false
        friendBack.backgroundColor = UIColor(red:1.00, green:0.69, blue:0.15, alpha:1.0)
        friendsButton.tintColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
        friendBack.addRoundedCorners()
        earthButton.setDefault()
        earthBack.backgroundColor = .clear
        meButton.setDefault()
        meBack.backgroundColor = .clear
        //animation
        if onWhichPage == onPage.map{
            self.friendsListView!.goRight()
        }
        else if onWhichPage == onPage.myList
        {
            self.friendsListView!.goLeft()
            self.myListView.FromMidToRight()
        }
        onWhichPage = onPage.friendsList
    }
    @IBAction func pressEarthButton(_ sender: UIButton) {
        //style
        earthButton.lightVibrate()
        meButton.isUserInteractionEnabled = true
        earthButton.isUserInteractionEnabled = false
        friendsButton.isUserInteractionEnabled = true
        earthBack.backgroundColor = UIColor(red:1.00, green:0.69, blue:0.15, alpha:1.0)
        let origImage = UIImage(named: "earth");
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        earthButton.setImage(tintedImage, for: .normal)
        earthButton.tintColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
        earthBack.addRoundedCorners()
        meButton.setDefault()
        meBack.backgroundColor = .clear
        friendsButton.setDefault()
        friendBack.backgroundColor = .clear
        //animation
        if onWhichPage == onPage.friendsList{
            self.friendsListView!.FromMidToLeft()
        }
        else if onWhichPage == onPage.myList
        {
            self.myListView.FromMidToRight()
        }

        onWhichPage = onPage.map
    }
    @IBAction func pressMeButton(_ sender: UIButton) {
        //style
        meButton.lightVibrate()
        meButton.isUserInteractionEnabled = false
        earthButton.isUserInteractionEnabled = true
        friendsButton.isUserInteractionEnabled = true
        meBack.backgroundColor = UIColor(red:1.00, green:0.69, blue:0.15, alpha:1.0)
        meButton.tintColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
        meBack.addRoundedCorners()
        earthButton.setDefault()
        earthBack.backgroundColor = .clear
        friendsButton.setDefault()
        friendBack.backgroundColor = .clear
        //animation
        if onWhichPage == onPage.friendsList{
                self.friendsListView!.FromMidToLeft()
                
                self.myListView.goLeft()
        }
        else if onWhichPage == onPage.map
        {
            self.myListView.goLeft()
        }
        onWhichPage = onPage.myList
        
    }

   
    @IBAction func unwindFromSearch(_ sender: UIStoryboardSegue){
    }
    @objc func loadPinFromFriends(notification:Notification){
        let result = notification.object
        let index = result as! Int
        let annArray = _mapView?.annotations
        _mapView?.removeAnnotations(annArray)
        let friendList = UserFunctions().getFriendList()!
        loadPins(id: friendList[index].id)
        mapTitle.text = friendList[index].name + "的地图"
        centerMapViewFromPin(pin: friendList[index].starredPins[0])
        self.onWhichStatus = mapStatus.friendMap
        backToMainMapButton.isHidden = false
        earthButton.sendActions(for: .touchUpInside)
    }
    @objc func loadPinFromMyMap(notification:Notification){
        animationFlag = true
        let annArray = _mapView?.annotations
        _mapView?.removeAnnotations(annArray)
        clusterManager.loadPinsFrom(user: UserFunctions().getMyInfo())
        updateClusters()
        self.myListView?.FromMidToRight()
        onWhichPage = onPage.map
        meButton.isUserInteractionEnabled = true
        meButton.setDefault()
        meBack.backgroundColor = .clear
        mapTitle.text = "我的地图"
        self.onWhichStatus = mapStatus.myMap
        backToMainMapButton.isHidden = false
        earthButton.sendActions(for: .touchUpInside)
    }
    
    @objc func loadSearchResults(notification:Notification){
        animationFlag = true
        let vc = notification.object as! SearchPOIViewController
        let searchAnnotationsResults = vc.pins
        if searchAnnotationsResults.count == 0{
            let alert = UIAlertController(title: "提示", message: "没有找到相关内容", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "好的", style: .default, handler: { action in
                self.dismiss(animated: false)
            }))
            present(alert, animated: true, completion: nil)
            return;
        }
        clusterManager.loadPinsFromResult(pins: searchAnnotationsResults)
        centerMapViewFromPin(pin: searchAnnotationsResults[0])
        onWhichStatus = mapStatus.searchPage
        //设置当前地图的中心点
        backToMainMapButton.isHidden = false
        PinDetailView?.goBottom()
        updateClusters()
    }
    var _mapView: BMKMapView?
    
    //static var stringPath = Bundle.main.path(forResource: "custom_map_config", ofType: "json")
    override func viewDidLoad() {
        //
        backToMainMapButton.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(loadSearchResults), name: NSNotification.Name(rawValue: "loadSearchResults"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadPinFromFriends), name: NSNotification.Name(rawValue: "reloadPin"), object: nil)
        //loading map
        NotificationCenter.default.addObserver(self, selector: #selector(loadPinFromMyMap), name: NSNotification.Name(rawValue: "reloadMyPin"), object: nil)
        //loading my map
        super.viewDidLoad()
        
        let stringPath = Bundle.main.path(forResource: "custom_map_config", ofType: "json")
        BMKMapView.customMapStyle(stringPath)
        _mapView = BMKMapView(frame: CGRect(x: 0, y: 0,
                                            width: self.view.frame.width,
                                            height: self.view.frame.height))
        
        BMKMapView.enableCustomMapStyle(true)
        //        searchBar.layer.borderWidth = 1
        //        searchBar.layer.borderColor = UIColor(red:0.99, green:0.83, blue:0.16, alpha:1.0).cgColor
        mapView.addSubview(_mapView!)
        mapView.sendSubviewToBack(_mapView!)
        //load friends list view
        
        
        let friendsListViewVC = storyboard!.instantiateViewController(withIdentifier: "friendsListView") as! FriendListViewController
        friendsListView = friendsListViewVC.view
        self.view.insertSubview(friendsListViewVC.view!, aboveSubview: mapView)
        self.addChild(friendsListViewVC)
        friendsListView!.frame = CGRect(x: 0 - UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        //load myList view
        friendsListViewVC.recoveryFriendsButton = {
            self.earthButton.sendActions(for: .touchUpInside)
        }
        let myListViewVC = storyboard!.instantiateViewController(withIdentifier: "myListView") as! MyListTableViewController
        myListView = myListViewVC.view
        self.view.insertSubview(myListView, aboveSubview: mapView)
        self.addChild(myListViewVC)
        myListViewVC.recoveryMeButton = {
            self.earthButton.sendActions(for: .touchUpInside)
        }
        myListView.frame = CGRect(x: UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        //load pin detail
        PinDetailViewVC = storyboard!.instantiateViewController(withIdentifier: "PinDetailView") as! PinDetailViewController
        PinDetailView = PinDetailViewVC.view!
        self.addChild(PinDetailViewVC)
        PinDetailView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.view.insertSubview(PinDetailView, at:10)
        let center = CLLocationCoordinate2D(latitude: 30.664131, longitude: 104.072893)
        //设置地图的显示范围（越小越精确）
        let span = BMKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        //设置地图最终显示区域
        let region = BMKCoordinateRegion(center: center, span: span)
        _mapView?.region = region
        _mapView?.zoomLevel = 14
        // 添加朋友标记点(PointAnnotation）
        _mapView!.delegate = self
        earthButton.sendActions(for: .touchUpInside)
        loadMainPins()
    }
    func centerMapViewFromPin(pin:Pin){
        let center = CLLocationCoordinate2D(latitude: pin.coord[0], longitude: pin.coord[1])
        //设置地图的显示范围（越小越精确）
        let span = BMKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        //设置地图最终显示区域
        let region = BMKCoordinateRegion(center: center, span: span)
        _mapView?.region = region
        _mapView?.zoomLevel = 14
    }
    func loadMainPins()
    {
        animationFlag = true
        clusterManager.loadMainMap()
        updateClusters()
    }
    //load pin on map
    var clusterManager = BMKClusterManager()
    func loadPins(id: String)
    {
        animationFlag = true
        clusterManager.loadPinsFrom(user:UserFunctions().getUserInfo(id: id)!)
        updateClusters()
    }
    
    //animation
    var animationFlag = true
    func mapView(_ mapView: BMKMapView!, didAddAnnotationViews views: [Any]!) {
        if animationFlag{
            for aV in views{
                let a = aV as! BMKAnnotationView
                let endFrame = a.frame;
                a.frame = CGRect(x: a.frame.origin.x, y: a.frame.origin.y - 400, width: a.frame.size.width, height: a.frame.size.height)
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationDuration(0.7)
                UIView.setAnimationCurve(.easeInOut)
                a.frame = endFrame
                UIView.commitAnimations()
                animationFlag = false
            }
        }
    }
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation) -> BMKAnnotationView! {
        let mapViewPointReuseIndentifier = "com.Baidu.BMKClusterAnnotation"
        let cluster: ClusterAnnotation = annotation as! ClusterAnnotation
        let annotationView: BMKPinAnnotationView = BMKPinAnnotationView.init(annotation: annotation, reuseIdentifier: mapViewPointReuseIndentifier)
//        if annotationView == nil {
//            annotationView = BMKPinAnnotationView(annotation: annotation, reuseIdentifier: mapViewPointReuseIndentifier)
//        }
        //annotationView?.pinColor = UInt(BMKPinAnnotationColorGreen)
        annotationView.canShowCallout = true //设置气泡可以弹出，默认为NO
        annotationView.rightCalloutAccessoryView = UIButton(type: .infoLight)
         //if annotation.title belongs to Data.friends
        if cluster.ClusterItems[0].pin.isSearchResult == true{
            annotationView.image = UIImage(named:"pin")
            return annotationView
        }
        let reSizePin = CGSize(width: 30, height: 30)
        let reSizeAvatar = CGSize(width: 18, height: 18)
        let avatarName = UserFunctions().getPinsUsers(id: cluster.ClusterItems[0].pinId)?.first!.avatar
        let avatar = UIImage(named:avatarName ?? "")?.reSizeImage(reSize: reSizeAvatar)
        let avatarView = UIImageView(image: avatar)
        avatarView.frame.origin.x = 6
        avatarView.frame.origin.y = 2
        avatarView.layer.cornerRadius = avatarView.frame.height/2
        avatarView.clipsToBounds = true
        let pin = UIImage(named:"NewPin")?.reSizeImage(reSize: reSizePin)
        annotationView.addSubview(avatarView)
        annotationView.image = pin
//        let annotationLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
//        annotationLabel.textColor = UIColor.white
//        annotationLabel.font = UIFont.systemFont(ofSize: 11)
//        annotationLabel.textAlignment = NSTextAlignment.center
//        annotationLabel.isHidden = false
//        annotationLabel.text = String(format: "%ld", cluster.size)
//        annotationLabel.backgroundColor = UIColor.green
//        annotationLabel.alpha = 0.8
//        annotationView.addSubview(annotationLabel)
//
//        if cluster.size == 1 {
//            annotationLabel.isHidden = true
//            annotationView.pinColor = UInt(BMKPinAnnotationColorRed)
//        }
//        if cluster.size > 20 {
//            annotationLabel.backgroundColor = UIColor.red
//        } else if (cluster.size > 10) {
//            annotationLabel.backgroundColor = UIColor.purple
//        } else if (cluster.size > 5) {
//            annotationLabel.backgroundColor = UIColor.blue
//        } else {
//            annotationLabel.backgroundColor = UIColor.green
//        }
//        annotationView.bounds = CGRect(x: 0, y: 0, width: 22, height: 22)
//        annotationView.isDraggable = true
       // annotationView.annotation = annotation
        return annotationView
    }
    
    func mapView(_ mapView: BMKMapView!, didSelect view: BMKAnnotationView!) {
        let cluster: ClusterAnnotation = view.annotation as! ClusterAnnotation
        let vc  = PinDetailViewVC as! PinDetailViewController
        vc.clusterItems = cluster.ClusterItems
        vc.loadPins()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // cluster manager
   
    var clusterZoom: Int = 0
    func mapViewDidFinishLoading(_ mapView: BMKMapView!) {
        updateClusters()
    }
    
    func updateClusters() {
        objc_sync_enter(clusterManager.clusterCaches)
        clusterZoom = Int(_mapView!.zoomLevel)
        var clusters: [ClusterAnnotation] = clusterManager.clusterCaches[clusterZoom - 3] as! [ClusterAnnotation]
        
        if clusters.count > 0 {
            _mapView!.removeAnnotations(_mapView?.annotations)
            _mapView!.addAnnotations(clusters)
        } else {
            DispatchQueue.global().async {
                let array = self.clusterManager.getClusters(zoomLevel: CGFloat(self.clusterZoom))
                DispatchQueue.main.async {
                    for(_, item) in array.enumerated() {
                        let annotation = ClusterAnnotation()
                        annotation.coordinate = item.coordinate
                        annotation.size = item.size
                        annotation.ClusterItems = Array(item.clusterAnnotations.values)
                        annotation.title = String(format: "我是%ld个", item.size)
                        clusters.append(annotation)
                    }
                   
                    self._mapView!.removeAnnotations(self._mapView?.annotations)
                    self._mapView!.addAnnotations(clusters )
                }
            }
        }
        objc_sync_exit(clusterManager.clusterCaches)

    }
    func mapView(_ mapView: BMKMapView!, onDrawMapFrame status: BMKMapStatus!) {
        if clusterZoom != 0 && clusterZoom != UInt(mapView.zoomLevel) {
            updateClusters()
        }
    }
    
}
