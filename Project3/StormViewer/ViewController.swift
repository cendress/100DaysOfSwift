//
//  ViewController.swift
//  StormViewer
//
//  Created by Christopher Endress on 10/16/23.
//

import UIKit

class ViewController: UITableViewController {
  var pictures = [String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let fm = FileManager.default
    let path = Bundle.main.resourcePath!
    let items = try! fm.contentsOfDirectory(atPath: path)
    let sortedItems = items.sorted()
    
    for item in sortedItems {
      if item.hasPrefix("nssl") {
        pictures.append(item)
      }
    }
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    pictures.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "PictureCell", for: indexPath) as? PictureCell {
      let x = indexPath.row
      let y = pictures.count
      cell.textLabel?.text = "Picture \(x) of \(y)"
      cell.cellTitleLabel.font = UIFont.systemFont(ofSize: 25)
      return cell
    } else {
      return UITableViewCell()
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
      vc.selectedImage = pictures[indexPath.row]
      navigationController?.pushViewController(vc, animated: true)
    }
  }
}

