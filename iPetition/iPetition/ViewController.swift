//
//  ViewController.swift
//  iPetition
//
//  Created by Christopher Endress on 11/2/23.
//

import UIKit

class ViewController: UITableViewController {
  
  var petitions = [Petition]()
  var filteredText: String?
  var filteredPetitions = [Petition]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filterButtonTapped))
    navigationItem.leftBarButtonItem = searchButton
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(creditsTapped))
    
    let urlString: String
    
    if navigationController?.tabBarItem.tag == 0 {
      urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
    } else {
      urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
    }
    
    if let url = URL(string: urlString) {
      if let data = try? Data(contentsOf: url) {
        self.parse(json: data)
        return
      }
    }
    
    showError()
  }
  
  func showError() {
    let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "OK", style: .default))
    present(ac, animated: true)
  }
  
  func parse(json: Data) {
    let decoder = JSONDecoder()
    if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
      petitions = jsonPetitions.results
      tableView.reloadData()
    }
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return petitions.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
    if indexPath.row < filteredPetitions.count {
      let petition = filteredPetitions[indexPath.row]
      cell.textLabel?.text = petition.title
      cell.detailTextLabel?.text = petition.body
    } else {
      let petition = petitions[indexPath.row]
      cell.textLabel?.text = petition.title
      cell.detailTextLabel?.text = petition.body
    }
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = DetailVC()
    vc.detailItem = petitions[indexPath.row]
    navigationController?.pushViewController(vc, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
  
  @objc func creditsTapped() {
    let ac = UIAlertController(title: "Credits", message: "The data comes from White House petitions api.", preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "OK", style: .default))
    present(ac, animated: true)
  }
  
  @objc func filterButtonTapped() {
    let ac = UIAlertController(title: "Filter Petitions", message: "Enter a keyword to filter petitions", preferredStyle: .alert)
    
    ac.addTextField { textField in
      textField.placeholder = "Enter a keyword"
    }
    
    let filterAction = UIAlertAction(title: "Filter", style: .default) { [weak self] _ in
      if let text = ac.textFields?.first?.text {
        self?.filteredText = text
        self?.filterPetitions()
      }
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    
    ac.addAction(filterAction)
    ac.addAction(cancelAction)
    
    present(ac, animated: true)
  }
  
  func filterPetitions() {
    if let text = filteredText, !text.isEmpty {
      filteredPetitions = petitions.filter { petition in
        return petition.title.localizedCaseInsensitiveContains(text) || petition.body.localizedCaseInsensitiveContains(text)
      }
    } else {
      filteredPetitions = petitions
    }
    
    tableView.reloadData()
  }
  
}

