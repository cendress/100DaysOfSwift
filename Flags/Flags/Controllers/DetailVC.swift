//
//  DetailVC.swift
//  Flags
//
//  Created by Christopher Endress on 10/23/23.
//

import UIKit

class DetailVC: UIViewController {
  @IBOutlet var imageView: UIImageView!
  var selectedImage: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    
    imageView.layer.borderWidth = 1
    imageView.layer.borderColor = UIColor.black.cgColor
    
    title = selectedImage
    navigationItem.largeTitleDisplayMode = .never
    
    if let imageToLoad = selectedImage {
      imageView.image = UIImage(named: imageToLoad)
    }
  }
  
  @objc func shareTapped() {
    let message = "Share this photo with your friends."
    
    guard let selectedImage = selectedImage, let image = UIImage(named: selectedImage) else {
      return
    }
    
    let activityVC = UIActivityViewController(activityItems: [image, message], applicationActivities: [])
    activityVC.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
    present(activityVC, animated: true)
  }
}
