//
//  ViewController.swift
//  ShoppingList
//
//  Created by Christopher Endress on 11/1/23.
//

import UIKit

class ShoppingListVC: UITableViewController {
  
  var shoppingList = [Item]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let savedData = UserDefaults.standard.data(forKey: "shoppingList"), let decodedList = try? JSONDecoder().decode([Item].self, from: savedData) {
      shoppingList = decodedList
    }
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear List", style: .plain, target: self, action: #selector(removeShoppingList))
    
  }
  
  //MARK: - Table view data source methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return shoppingList.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
    let item = shoppingList[indexPath.row]
    cell.textLabel?.text = item.name
    return cell
  }
  
  //MARK: - Table view delegate methods
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
  
  //MARK: - Objc methods
  
  @objc func addNewItem() {
    let ac = UIAlertController(
      title: "Add New Item",
      message: nil,
      preferredStyle: .alert
    )
    ac.addTextField()
    
    let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
      guard let answer = ac?.textFields?[0].text else { return }
      let newItem = Item(name: answer)
      self?.shoppingList.append(newItem)
      self?.saveShoppingList()
      self?.tableView.reloadData()
    }
    
    ac.addAction(submitAction)
    present(ac, animated: true)
  }
  
  @objc func removeShoppingList() {
    let ac = UIAlertController(
      title: "Clear List",
      message: "Are you sure you'd like to clear all items in the list?",
      preferredStyle: .alert
    )
    
    let submitAction = UIAlertAction(title: "Yes", style: .destructive) { [weak self] action in
      self?.shoppingList.removeAll()
      self?.saveShoppingList()
      self?.tableView.reloadData()
    }
    
    let noAction = UIAlertAction(title: "No", style: .cancel)
    
    ac.addAction(submitAction)
    ac.addAction(noAction)
    present(ac, animated: true)
  }
  
  //MARK: - Swipe action methods
  
  override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
      self?.deleteItem(at: indexPath)
      completionHandler(true)
    }
    
    return UISwipeActionsConfiguration(actions: [deleteAction])
  }
  
  private func deleteItem(at indexPath: IndexPath) {
    if indexPath.row < shoppingList.count {
      shoppingList.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
      saveShoppingList()
    }
  }
  
  //MARK: - Persistence
  
  private func saveShoppingList() {
    if let encodedList = try? JSONEncoder().encode(shoppingList) {
      UserDefaults.standard.setValue(encodedList, forKey: "shoppingList")
    }
  }
}

