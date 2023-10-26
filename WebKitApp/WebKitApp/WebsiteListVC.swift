//
//  WebsiteListVC.swift
//  WebKitApp
//
//  Created by Christopher Endress on 10/26/23.
//

import UIKit

class WebsiteListVC: UITableViewController {
  
  var websites = ["hackingwithswift.com", "apple.com"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Choose a Website"
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowWebView" {
      if let viewController = segue.destination as? ViewController, let selectedWebsite = sender as? String {
        viewController.loadWebsite(selectedWebsite)
      }
    }
  }
  
  //MARK: - Table view data source methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    websites.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "WebCell", for: indexPath)
    cell.textLabel?.text = websites[indexPath.row]
    cell.accessoryType = .disclosureIndicator
    return cell
  }
  
  //MARK: - Table view delegate methods
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedWebsite = websites[indexPath.row]
    performSegue(withIdentifier: "ShowWebView", sender: selectedWebsite)
  }
}
