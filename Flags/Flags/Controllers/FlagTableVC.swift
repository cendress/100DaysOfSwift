//
//  FlagTableVC.swift
//  Flags
//
//  Created by Christopher Endress on 10/23/23.
//

import UIKit

class FlagTableVC: UITableViewController {
  
  let flags = [
  "Estonia", "France", "the US", "the UK", "Poland", "Russia", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Spain"
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  // MARK: - Table view datasource methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    flags.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "FlagCell", for: indexPath)
    cell.textLabel?.text = flags[indexPath.row]
    
    if let image = UIImage(named: flags[indexPath.row]) {
      cell.imageView?.image = image
    }
    return cell
  }
  
  
  //MARK: - Table view delegate methods
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
    if let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailVC {
      detailVC.selectedImage = flags[indexPath.row]
      navigationController?.pushViewController(detailVC, animated: true)
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
  
  
}
