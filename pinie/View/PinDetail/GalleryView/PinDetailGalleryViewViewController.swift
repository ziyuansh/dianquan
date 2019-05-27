//
//  PinDetailGalleryViewViewController.swift
//  pinie
//
//  Created by Rui Jin on 5/8/19.
//  Copyright © 2019 Rui Jin. All rights reserved.
//

import UIKit

class PinDetailGalleryViewViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var galleryImages: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    var pin:Pin!
    var frame = CGRect(x:0,y:0,width:0,height:0)
    override func viewDidLoad() {
        let images = pin.images
        super.viewDidLoad()
        for index in 0..<images.count{
            frame.origin.x = self.imageScrollView.frame.size.width * CGFloat(index)
            frame.size = self.imageScrollView.frame.size
            let imgView = UIImageView(frame:frame)
            let url = URL(string: images[index])
            do {
                let data = try Data(contentsOf: url!)
                let image = UIImage(data: data)
                imgView.image = image
            }catch let err {
                print("Error : \(err.localizedDescription)")
            }
            imgView.contentMode = .scaleAspectFit
            self.imageScrollView.addSubview(imgView)
            
        }
        self.imageScrollView.contentSize = CGSize(width:(self.imageScrollView.frame.size.width * CGFloat(images.count)), height:self.imageScrollView.frame.size.height)
        self.imageScrollView.delegate = self
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
