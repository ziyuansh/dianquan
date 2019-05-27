//
//  PinDetailCollectionViewCell.swift
//  pinie
//
//  Created by ziyuan Shan on 5/4/19.
//  Copyright © 2019 Rui Jin. All rights reserved.
//

import UIKit
import RealmSwift
class PinDetailCollectionViewCell:UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    var pinInfo = Pin()
    
    @IBOutlet weak var commentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var attributeTableView: UITableView!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var pinDetailScrollView: UIScrollView!
    @IBOutlet weak var avatar_before: UIImageView!
    @IBOutlet weak var galleryImage: UIImageView!
    @IBOutlet weak var galleryView: UIView!
    @IBOutlet weak var pinTitle: UILabel!
    @IBOutlet weak var pinSubtitle: UILabel!
    @IBOutlet weak var avatarCommentView: UIView!
    @IBOutlet weak var moreImageButton: UIButton!
    @IBOutlet weak var showCommentTextFieldButton:  UIButton!
    @IBOutlet weak var avatarAndAttributeTableGroupView: UIView!
    var attributeTableViewHeight:CGFloat = 0;
    var commentTableViewHeight:CGFloat = 0;
    
    @IBAction func showCommentTextFieldButtonTapped(_ sender: Any) {
        self.commentTextField.isHidden = false
        self.commentTextField.becomeFirstResponder()
        self.commentTextField.text = ""
    }
    
    @IBAction func pressMoreImageButton(_ sender: UIButton) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        self.attributeTableView.delegate = self
        self.attributeTableView.dataSource = self
        self.commentTableView.isScrollEnabled = false
        self.commentTableView.delegate = self
        self.commentTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == attributeTableView {
            return pinInfo.attributes.count
        }
        return pinInfo.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == attributeTableView{
            let cell = attributeTableView.dequeueReusableCell(withIdentifier: "attribute", for: indexPath) as! AttributeTableViewCell
            let attribute = pinInfo.attributes[indexPath.row]
            cell.attributeLabel.text = attribute.attribute
            cell.informationLabel.text = attribute.infomation
            cell.selectionStyle = .none
            return cell
        }
        let cell = commentTableView.dequeueReusableCell(withIdentifier: "comment", for: indexPath) as! CommentTableViewCell
        let comment = pinInfo.comments[indexPath.row]
        cell.userNameLabel.text = UserFunctions().getUserInfo(id: comment.sender)!.name
        let avatar = UserFunctions().getUserInfo(id: comment.sender)!.avatar
        cell.avaterImage.image =  UIImage(named:  avatar)
        cell.timestampLabel.text =
        Date().timeAgoDisplay(timeStamp: pinInfo.comments[indexPath.row].timeStamp)
            //String(Date().getCurrentTimeStamp())
        if comment.receiver == ""{
            
        }else{
            cell.contentLabel.text = "@" + UserFunctions().getUserInfo(id: comment.receiver)!.name  + " " + comment.content
             //USE '!' MAYBE WILL CAUSE SOME PROBLEM, DISCUSSION NEEDED
        }
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if tableView == commentTableView{
            self.commentTextField.isHidden = false
            self.commentTextField.becomeFirstResponder()
            let comment = pinInfo.comments[indexPath.row]
            self.commentTextField.text = "@" + UserFunctions().getUserInfo(id: comment.sender)!.name + " "
        }
    }
    
    
    override func awakeFromNib() {
        
        self.commentTextField.delegate = self
        self.commentTextField.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeShown(note:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        galleryImageConstraint()
        avatarCommentViewConstraint()
        
        
        pinDetailScrollView.isScrollEnabled = false
//        self.pinDetailScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)// + CGFloat(pinInfo.comments.count * 44 + 50))

        
        galleryImage.layer.cornerRadius = 15
        moreImageButton.addRoundedCorners()
        pinDetailScrollView.layer.cornerRadius = 15
        pinDetailScrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        avatar_before.layer.cornerRadius = avatar_before.frame.height/2
        avatar_before.clipsToBounds = true
        pinSubtitle.numberOfLines = 2;
        pinSubtitle.adjustsFontSizeToFitWidth = true;
        pinSubtitle.minimumScaleFactor = 0.5;
       // setCommentShowBtn()
       
    }
    
    //Change Button Position????????
    func setCommentShowBtn(){
        showCommentTextFieldButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: showCommentTextFieldButton, attribute: .top, relatedBy: .equal, toItem: commentTableView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: showCommentTextFieldButton, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: commentTableView, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: 0).isActive = true
//        let rectOfCellInTableView = commentTableView.rectForRow(at: NSIndexPath(row: pinInfo.comments.count - 1, section: 1) as IndexPath)
//        print(rectOfCellInTableView)
//        let rectOfCellInSuperview = commentTableView.convert(rectOfCellInTableView, to: commentTableView.superview)
//        print(rectOfCellInSuperview)
//        self.showCommentTextFieldButton.frame.origin = CGPoint(x: rectOfCellInSuperview.origin.x + UIScreen.main.bounds.width*0.8 - self.showCommentTextFieldButton.frame.width , y: rectOfCellInSuperview.origin.y + CGFloat(pinInfo.comments.count * 44))

    }
    
    
    @objc func handleTap(touch: UITapGestureRecognizer){
        let touchPoint = touch.location(in: self)
        //print(touchPoint.x)
        let view = touch.view
        let subview = view?.hitTest(touchPoint, with: nil)
        if subview?.superview?.superview == commentTableView{
             touch.cancelsTouchesInView = false
        }else{
        }
        
        self.endEditing(true)
        self.commentTextField.isHidden = true
    }

    @objc func keyboardWillBeShown(note: Notification){
        let userInfo = note.userInfo
        let keyboardFrame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.height, right: 0.0)
        pinDetailScrollView.contentInset = contentInset
        pinDetailScrollView.scrollIndicatorInsets = contentInset
        pinDetailScrollView.scrollRectToVisible(commentTextField.frame, animated: true)
    }
    
    @objc func keyboardWillBeHidden(note:Notification){
        let contentInset = UIEdgeInsets.zero
        pinDetailScrollView.contentInset = contentInset
        pinDetailScrollView.scrollIndicatorInsets = contentInset
    }
    
    func commentTableConstraint(){
        commentTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: commentTableView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: pinDetailScrollView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: commentTableView, attribute: .top, relatedBy: .equal, toItem: avatarAndAttributeTableGroupView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: commentTableView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.width*0.8).isActive = true
    }
    
    func setCommentHieght(){
        //commentTableView.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint(item: commentTableView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: CGFloat(pinInfo.comments.count * 44)).isActive = true
    }
    func setAttributeHieght(){
         let constraints = NSLayoutConstraint(item: attributeTableView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: CGFloat(pinInfo.attributes.count * 44))
        constraints.isActive = true
    }
    
    func attributeTableConstraint(){
        attributeTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: attributeTableView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: pinDetailScrollView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: attributeTableView, attribute: .top, relatedBy: .equal, toItem: avatarCommentView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: attributeTableView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.width*0.8).isActive = true
        
    }
    
    func galleryImageConstraint(){
        galleryView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: galleryView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: pinDetailScrollView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: galleryView, attribute: .top, relatedBy: .equal, toItem: pinDetailScrollView, attribute: .top, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: galleryView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.width*0.94).isActive = true
        NSLayoutConstraint(item: galleryView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.height*0.28).isActive = true
        
    }
    
    func avatarCommentViewConstraint(){
        avatarCommentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: avatarCommentView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: pinDetailScrollView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: avatarCommentView, attribute: .top, relatedBy: .equal, toItem: galleryImage, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: avatarCommentView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.width*0.94).isActive = true
        NSLayoutConstraint(item: avatarCommentView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.height*0.13).isActive = true
    }
}

extension PinDetailCollectionViewCell:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.isHidden = true
        return true
    }
}
