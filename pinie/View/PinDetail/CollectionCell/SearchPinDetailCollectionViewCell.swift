//
//  SearchPinDetalCollectionViewCell.swift
//  pinie
//
//  Created by Rui Jin on 5/11/19.
//  Copyright © 2019 Rui Jin. All rights reserved.
//

import UIKit

class SearchPinDetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var galleryView: UIView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var galleryImage: UIImageView!
    
    @IBOutlet weak var addPinButton: UIButton!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchPinDetailScrollView: UIScrollView!
    override func awakeFromNib() {
        galleryImageConstraint()
        infoViewConstraint()
        searchPinDetailScrollView.isScrollEnabled = false
        self.searchPinDetailScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: (self.frame.size.height+10) * CGFloat(UserFunctions().getFriendList()!.count))
        galleryImage.layer.cornerRadius = 15
        moreButton.addRoundedCorners()
        addPinButton.addShadowCorner2()
        searchPinDetailScrollView.layer.cornerRadius = 15
    }
    func galleryImageConstraint(){
        galleryView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: galleryView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: searchPinDetailScrollView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: galleryView, attribute: .top, relatedBy: .equal, toItem: searchPinDetailScrollView, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: galleryView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.width*0.94).isActive = true
        NSLayoutConstraint(item: galleryView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.height*0.28).isActive = true

    }
    func infoViewConstraint(){
        infoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: infoView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: searchPinDetailScrollView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: infoView, attribute: .top, relatedBy: .equal, toItem: galleryImage, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: infoView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.width*0.94).isActive = true
        NSLayoutConstraint(item: infoView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.height*0.12).isActive = true
    }

}
