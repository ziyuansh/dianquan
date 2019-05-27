//
//  AddPinViewController.swift
//  pinie
//
//  Created by Rui Jin on 5/15/19.
//  Copyright © 2019 Rui Jin. All rights reserved.
//

import UIKit
import TZImagePickerController
import RealmSwift
class AddPinViewController: UIViewController, TZImagePickerControllerDelegate {
    var images = [UIImage]();
    var pinInfo = Pin();
    @IBAction func PressCancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func pressAddButton(_ sender: UIBarButtonItem) {
        let obj = List<Double>()
        print(pinInfo)
        obj.append(pinInfo.coord[0])
        obj.append(pinInfo.coord[1])
        let img = List<String>()
        img.append("https://i.imgur.com/SsJmZ9jl.jpg")
        img.append("https://i.imgur.com/SsJmZ9jl.jpg")
        img.append("https://i.imgur.com/SsJmZ9jl.jpg")
        let commentList1 = List<Comment>()
        let attributeList1 = List<Attribute>()
        let Pin1 = Pin(id:pinInfo.id, title:pinInfo.title, subTitle:mainDescription.text, coord: obj, images: img, icon: "", isStarred: true, comments: commentList1, attributes: attributeList1, timeStamp: Date().getCurrentTimeStamp())
        UserFunctions().addPin(pin: Pin1)
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var mainDescription: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var attributeTableView: UITableView!
    @IBOutlet weak var unlockedPinView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        images.append(UIImage(named:"addPhoto")!)
        self.photoCollectionView.delegate = self
        self.photoCollectionView.dataSource = self
        self.attributeTableView.dataSource = self
        self.attributeTableView.delegate = self
        photoCollectionView.reloadData()
        photoCollectionView.addRoundedCorners()
        mainDescription.addRoundedCorners()
        attributeTableView.addRoundedCorners()
        photoCollectionViewConstraint()
        descriptionViewContraint()
        avatar.makeAvatar(name: "1")
        attributeTableViewConstraint()

    }
    func descriptionViewContraint(){
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: descriptionView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: scrollView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: descriptionView, attribute: .top, relatedBy: .equal, toItem: photoCollectionView, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: descriptionView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.width*0.9).isActive = true
        NSLayoutConstraint(item: descriptionView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: CGFloat(150)).isActive = true
    }
}
//collection view
extension AddPinViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.photoCollectionView.frame.width/3 - 12), height: (self.photoCollectionView.frame.width/3 - 12))
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == photoCollectionView{
            let cell = photoCollectionView.dequeueReusableCell(withReuseIdentifier: "AddPinCollectionCell", for: indexPath) as! AddPhotoCollectionCell
            cell.photoImageView.image = images[indexPath.row]

            return cell
        }
        else{
            let cell = photoCollectionView.dequeueReusableCell(withReuseIdentifier: "AddPinCollectionCell", for: indexPath) as! AddPhotoCollectionCell
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row + 1 == images.count{
            let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let selectFromAblum = UIAlertAction(title: "从相册选择", style: .default, handler:{(UIAlertAction)in
                self.handleAlbum()
            })
            let TakePhoto = UIAlertAction(title: "照相", style: .default, handler: {(UIAlertAction)in
                self.handleTakingPhoto()
            })
            let cancelAction = UIAlertAction(title: "取消", style: .cancel)
            optionMenu.addAction(TakePhoto)
            optionMenu.addAction(selectFromAblum)
            optionMenu.addAction(cancelAction)
            self.present(optionMenu, animated: true, completion: nil)
        }
    }
    func handleTakingPhoto(){
        
    }
    func handleAlbum(){
        let imagePickerVc = TZImagePickerController(maxImagesCount: 9, delegate: self)
        imagePickerVc?.didFinishPickingPhotosHandle = {(photos, assets, true) in
            self.images.remove(at: self.images.count - 1)
            self.images.append(contentsOf: photos!)
            self.images.append(UIImage(named:"addPhoto")!)
            self.photoCollectionView.reloadData()
            let contrains = self.photoCollectionView.constraints
            self.photoCollectionView.removeConstraints(contrains)
            self.photoCollectionViewConstraint()
        }
        present(imagePickerVc!, animated: true)
    }
    func photoCollectionViewConstraint(){
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: photoCollectionView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: scrollView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: photoCollectionView, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: photoCollectionView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.width*0.9).isActive = true
        let rows = Int(((images.count - 1)/3)+1)
        NSLayoutConstraint(item: photoCollectionView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: CGFloat(rows * (Int(self.photoCollectionView.frame.width/3 - 10) + 10))).isActive = true
        
    }
}


//table Attribute view
extension AddPinViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = attributeTableView.dequeueReusableCell(withIdentifier: "attrTableCell", for: indexPath) as! AddPinViewAttributeTableCell
        return cell
    }
    func attributeTableViewConstraint(){
        attributeTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: attributeTableView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: scrollView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: attributeTableView, attribute: .top, relatedBy: .equal, toItem: descriptionView, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: attributeTableView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.width*0.9).isActive = true
        NSLayoutConstraint(item: attributeTableView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: CGFloat(44)).isActive = true
    }
}
