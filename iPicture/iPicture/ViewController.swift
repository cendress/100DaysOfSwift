//
//  ViewController.swift
//  iPicture
//
//  Created by Christopher Endress on 11/19/23.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  var pictures = [Picture]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPicture))
    loadPictures()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    pictures.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PictureCell", for: indexPath)
    let picture = pictures[indexPath.row]
    cell.textLabel?.text = picture.name
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let vc = storyboard?.instantiateViewController(withIdentifier: "PictureVC") as? PictureVC {
      let picture = pictures[indexPath.row]
      let imagePath = getDocumentsDirectory().appendingPathComponent(picture.filename).path
      vc.selectedImage = UIImage(contentsOfFile: imagePath)
      navigationController?.pushViewController(vc, animated: true)
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    80
  }
  
  @objc func addPicture() {
    let picker = UIImagePickerController()
    picker.sourceType = .photoLibrary
    picker.delegate = self
    picker.allowsEditing = true
    present(picker, animated: true)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[.editedImage] as? UIImage else { return }
    let imageName = UUID().uuidString
    let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
    
    if let jpegData = image.jpegData(compressionQuality: 0.8) {
      try? jpegData.write(to: imagePath)
    }
    
    dismiss(animated: true) {
      let ac = UIAlertController(title: "Write Caption", message: "Write a caption for the picture.", preferredStyle: .alert)
      ac.addTextField()
      ac.addAction(UIAlertAction(title: "Submit", style: .default) { [weak self] _ in
        guard let caption = ac.textFields?[0].text else { return }
        let picture = Picture(name: caption, filename: imageName)
        self?.pictures.append(picture)
        self?.save()
        self?.tableView.reloadData()
      })
      self.present(ac, animated: true)
    }
  }
  
  func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
  
  func save() {
    let encoder = JSONEncoder()
    let defaults = UserDefaults.standard
    
    if let savedData = try? encoder.encode(pictures) {
      defaults.set(savedData, forKey: "SavedPictures")
    } else {
      print("Failed to save pictures.")
    }
  }
  
  func loadPictures() {
    let decoder = JSONDecoder()
    let defaults = UserDefaults.standard
    
    if let savedPictures = defaults.object(forKey: "SavedPictures") as? Data {
      if let decodedPictures = try? decoder.decode([Picture].self, from: savedPictures) {
        pictures = decodedPictures
      }
    }
  }
  
  
  //create table view
  //create a right bar button item for users to add a picture
  //use image picker controller method for users to take pictures or select them on device
  //use a uialertcontroller right after the user selects an image to store a caption
  //save the image and caption with user defaults
  //when the caption is tapped it goes to a new view controller that displays the image
  
  
}

