//
//  MyListTableViewController.swift
//  pinie
//
//  Created by ziyuan Shan on 5/2/19.
//  Copyright © 2019 Rui Jin. All rights reserved.
//

import UIKit

class MyListTableViewController: UITableViewController {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var usernameText: UILabel!
    @IBOutlet weak var myMapButton: UIButton!
    @IBOutlet weak var myProfileButton: UIButton!
    @IBOutlet weak var myIconCollectView: UICollectionView!
    @IBOutlet weak var myMapView: UIView!
    @IBOutlet weak var myProfileView: UIView!
    @IBOutlet weak var myIconView: UIView!
    @IBOutlet var myTableView: UITableView!
    @IBOutlet weak var contentView1: UIView!
    @IBOutlet weak var contentView2: UIView!
    @IBOutlet weak var contentView3: UIView!
    var recoveryMeButton:(()->())?
    var userInfo = UserFunctions().getMyInfo()
    override func viewDidLoad() {
        super.viewDidLoad()
      
//        let bg_img = UIImageView(image: UIImage(named: "noname"))
//        bg_img.frame = self.myTableView.frame
//        self.myTableView.backgroundView = bg_img
        self.view.layer.contents = UIImage(named:"noname.png")?.cgImage
        self.avatarImage.image = UIImage(named:userInfo.avatar)
        self.avatarImage.layer.cornerRadius = self.avatarImage.frame.height/2
    
        self.usernameText.text = userInfo.name
        
        self.myMapButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        self.myProfileButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        self.myMapView.addRoundedCorners()
        self.myProfileView.addRoundedCorners()
        self.myIconView.addRoundedCorners()
        self.myMapView.addShadowCorner()
        self.myProfileView.addShadowCorner()
        self.myIconView.addShadowCorner()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @IBAction func mapButtonTapped(_ sender: Any) {
        self.myMapButton.showsTouchWhenHighlighted = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:"reloadMyPin"), object:nil)
    }
    
    @IBAction func profileButtonTapped(_ sender: Any) {
    }
    
    
    var direction = ""
    @IBAction func handlePan(_ recognizer: UIPanGestureRecognizer){
        guard let recognizerView = recognizer.view else{
            return
        }
        let translation = recognizer.translation(in: view)
        if translation.x > 0 {
            direction = "right"
        }
        else if translation.x < 0 {
            direction = "left"
        }
        if recognizer.state == .changed{
            if recognizerView.center.x + translation.x >= UIScreen.main.bounds.width/2{
                recognizerView.center.x += translation.x
            }
            recognizer.setTranslation(.zero, in: view)
        }
        if recognizer.state == .ended{
            print("end")
            print(direction)
            if direction == "left"{
                self.view.goLeft()
            }
            else{
                self.view.FromMidToRight()
                recoveryMeButton?()
            }
        }
    }
}
