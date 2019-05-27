//
//  FriendListViewController.swift
//  pinie
//
//  Created by Rui Jin on 4/28/19.
//  Copyright © 2019 Rui Jin. All rights reserved.
//

import UIKit

class FriendListViewController: UIViewController {
    @IBOutlet weak var friendListTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var recoveryFriendsButton:(()->())?
    var friendList = UserFunctions().getFriendList()
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.searchBar.barTintColor = UIColor.lightGray
        self.searchBar.layer.borderWidth = 0
        self.view.layer.contents = UIImage(named:"noname.png")?.cgImage
        friendListTable.delegate = self
        friendListTable.dataSource = self
        friendListTable.reloadData()   
        // Do any additional setup after loading the view.
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
            if recognizerView.center.x + translation.x <= UIScreen.main.bounds.width/2{
                recognizerView.center.x += translation.x
            }
            recognizer.setTranslation(.zero, in: view)
        }
        if recognizer.state == .ended{
            if direction == "left"{
                self.view.FromMidToLeft()
                recoveryFriendsButton?()
            }
            else{
                self.view.goRight()
            }
        }
    }

}

extension FriendListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell",for: indexPath) as! FriendViewCell
        cell.name.text = friendList![indexPath.row].name
        let pins = friendList![indexPath.row].pins
        var pinArray = Array(pins)
        pinArray.sort{
            (l:Pin, r:Pin) -> Bool in l.timeStamp > r.timeStamp
        }
        if pins.count > 0 {
            
            cell.newPin.text = "最新: " + pinArray[0].title
            cell.timeAgo.text = Date().timeAgoDisplay(timeStamp: pinArray[0].timeStamp)
        }
         
        cell.loadMap = {
            return indexPath.row
        }
        cell.avatar.image = UIImage(named: friendList![indexPath.row].avatar)
        return cell
    }
}
