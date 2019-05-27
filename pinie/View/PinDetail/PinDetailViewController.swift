//
//  PinDetailViewController.swift
//  pinie
//
//  Created by ziyuan Shan on 5/4/19.
//  Copyright © 2019 Rui Jin. All rights reserved.
//

import UIKit

class PinDetailViewController: UIViewController{
    
    var status = false
    var pins = [Pin]()
    var clusterItems = [ClusterItem]()
    @IBAction func unwind(_ sender: UIStoryboardSegue){
    }
    @IBOutlet weak var panGesture: UIPanGestureRecognizer!
    @IBOutlet weak var pinDetailCollectionView: UICollectionView!
    @IBAction func closeButton(_ sender: UIButton) {
        self.view.goBottom()
        panGesture.isEnabled = true
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        self.status = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let cell = self.pinDetailCollectionView.visibleCells[0] as? PinDetailCollectionViewCell
            cell?.pinDetailScrollView.contentOffset = CGPoint.zero
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pinDetailCollectionView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        // Do any additional setup after loading the view.
    }
    var direction = ""
    @IBAction func handlePin(_ recognizer: UIPanGestureRecognizer) {
        guard let recognizerView = recognizer.view else{
            return
        }
       
        let translation = recognizer.translation(in: view)
        //recognizerView.center.x += translation.x
        if translation.y > 0 {
            direction = "down"
        }
        else if translation.y < 0 {
            direction = "up"
        }
        if recognizer.state == .changed{
            if recognizerView.center.y + translation.y >= UIScreen.main.bounds.height/2{
                recognizerView.center.y += translation.y
            }
            recognizer.setTranslation(.zero, in: view)
        }
        if recognizer.state == .ended{
            if direction == "up"{
                if(recognizerView.frame.origin.y > UIScreen.main.bounds.height/2)
                {
                    recognizerView.goMid()
                }
                else
                {
                    recognizerView.goTop()
                    panGesture.isEnabled = false
                    self.status = true
                    pinDetailCollectionView.reloadData()
                }
            }
            else if direction == "down"{
                if(recognizerView.frame.origin.y < UIScreen.main.bounds.height/2)
                {
                    recognizerView.goMid()
                }
                else
                {
                    recognizerView.goBottom()
                    dismiss(animated: true)
                }
            }
        }
    }
    func loadPins(){
        self.view.goMid()
        pins.removeAll()
        for item in clusterItems{
            pins.append(item.pin)
        }
        pinDetailCollectionView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is PinDetailGalleryViewViewController
        {
            let vc = segue.destination as? PinDetailGalleryViewViewController
            let cell = pinDetailCollectionView.visibleCells[0]
            let indexPath = pinDetailCollectionView.indexPath(for: cell)
            vc?.pin = pins[indexPath!.row]
        }
        if segue.destination is UINavigationController
        {
            let vc = segue.destination as? UINavigationController
            let addPinVC = vc?.topViewController as! AddPinViewController
            let cell = pinDetailCollectionView.visibleCells[0]
            let indexPath = pinDetailCollectionView.indexPath(for: cell)
            addPinVC.pinInfo = pins[indexPath!.row]
        }
    }
}

extension PinDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pins.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if pins[indexPath.row].isSearchResult{
            let cell = pinDetailCollectionView.dequeueReusableCell(withReuseIdentifier: "SearchPinDetailCell", for: indexPath) as! SearchPinDetailCollectionViewCell
            let pinInfo = pins[indexPath.row]
            let url = URL(string: pins[indexPath.row].images[0])
            do {
                if url != nil{
                    let data = try Data(contentsOf: url!)
                    let image = UIImage(data: data)
                    cell.galleryImage.image = image
                }
            }catch let err {
                print("Error : \(err.localizedDescription)")
            }
            
            cell.titleLabel.text = pinInfo.title
            cell.address.text = pinInfo.details[0].descriptionText
            if self.status{
                cell.searchPinDetailScrollView.isScrollEnabled = true
            }
            else{
                cell.searchPinDetailScrollView.isScrollEnabled = false
            }
            return cell
        }
        else{
            let cell = pinDetailCollectionView.dequeueReusableCell(withReuseIdentifier: "pinDetailCell", for: indexPath) as! PinDetailCollectionViewCell
            let userInfo = UserFunctions().getPinsUsers(id: clusterItems[indexPath.row].pinId)?.first
            let pinInfo = UserFunctions().getPinInfo(id: clusterItems[indexPath.row].pinId)
            
            // szy added
            if let pin1 = pinInfo{
                cell.pinInfo  = pin1
            }
            
            cell.avatar_before.image = UIImage(named:(userInfo?.avatar)!)
            let url = URL(string: pins[indexPath.row].images[0])
            do {
                if url != nil{
                    let data = try Data(contentsOf: url!)
                    let image = UIImage(data: data)
                    cell.galleryImage.image = image
                }
            }catch let err {
                print("Error : \(err.localizedDescription)")
            }
            
            cell.pinTitle.text = pinInfo?.title
            cell.pinSubtitle.text = pinInfo?.subTitle
            if self.status{
                cell.pinDetailScrollView.isScrollEnabled = true
            }
            else{
                cell.pinDetailScrollView.isScrollEnabled = false
            }
            
            //cell.constraints.removeAll()
            cell.commentTableView.removeConstraints(cell.commentTableView.constraints)
            cell.attributeTableView.removeConstraints(cell.attributeTableView.constraints)
           
            cell.attributeTableConstraint()
            cell.setAttributeHieght()
            cell.commentTableConstraint()
            cell.setCommentHieght()
            cell.setCommentShowBtn()
            cell.commentTableView.reloadData()//  not s ure!
            cell.attributeTableView.reloadData()
            
            cell.pinDetailScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + CGFloat((pinInfo?.comments.count)! * 44 + (pinInfo?.attributes.count)! * 44))

            return cell
        }
    }
}

