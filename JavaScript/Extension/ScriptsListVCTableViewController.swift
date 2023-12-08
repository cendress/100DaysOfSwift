//
//  ScriptsListVCTableViewController.swift
//  Extension
//
//  Created by Christopher Endress on 12/8/23.
//

import UIKit

class ScriptsListVCTableViewController: UITableViewController {
  
  var scripts: [Script] = []
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    scripts = ScriptManager.shared.loadScripts()
    tableView.reloadData()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let tableView = UITableView(frame: view.bounds, style: .plain)
    tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    tableView.dataSource = self
    tableView.delegate = self
    view.addSubview(tableView)
    
    scripts = ScriptManager.shared.loadScripts()
    navigationItem.title = "Saved Scripts"
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return scripts.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    cell.textLabel?.text = scripts[indexPath.row].name
    return cell
  }
  
  // MARK: - Table view delegate
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedScript = scripts[indexPath.row]
    NotificationCenter.default.post(name: NSNotification.Name("ScriptSelected"), object: nil, userInfo: ["selectedScript": selectedScript])
    dismiss(animated: true)
  }
  
}
