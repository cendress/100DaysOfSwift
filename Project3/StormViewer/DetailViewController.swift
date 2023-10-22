//
//  DetailViewController.swift
//  StormViewer
//
//  Created by Christopher Endress on 10/17/23.
//

import UIKit

class DetailViewController: UIViewController {
  @IBOutlet var imageView: UIImageView!
  var selectedImage: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = selectedImage
    navigationItem.largeTitleDisplayMode = .never
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    
    if let imageToLoad = selectedImage {
      imageView.image = UIImage(named: imageToLoad)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.hidesBarsOnTap = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.hidesBarsOnTap = false
  }
  
  @objc func shareTapped() {
    guard let safeImage = imageView.image?.jpegData(compressionQuality: 0.8) else {
      print("No image found.")
      return
    }
    
    guard let imageName = selectedImage else {
      print("Image does not have a name.")
      return
    }
    
    let vc = UIActivityViewController(activityItems: [safeImage, imageName], applicationActivities: [])
    vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
    present(vc, animated: true)
  }
  
}
