//
//  PictureVC.swift
//  iPicture
//
//  Created by Christopher Endress on 11/19/23.
//

import UIKit

class PictureVC: UIViewController {
  @IBOutlet var imageView: UIImageView!
  var selectedImage: UIImage?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    imageView.image = selectedImage
  }
  
}
