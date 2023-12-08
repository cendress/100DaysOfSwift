//
//  ActionViewController.swift
//  Extension
//
//  Created by Christopher Endress on 12/6/23.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController {
  @IBOutlet weak var script: UITextView!
  
  var pageTitle = ""
  var pageURL = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self, selector: #selector(handleScriptSelection(_:)), name: NSNotification.Name("ScriptSelected"), object: nil)
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
    
    let scriptBarButtonItem = UIBarButtonItem(title: "Scripts", style: .plain, target: self, action: #selector(selectScript))
    navigationItem.rightBarButtonItems?.append(scriptBarButtonItem)
    
    let addScriptButton = UIBarButtonItem(title: "Add Script", style: .plain, target: self, action: #selector(addScript))
        navigationItem.rightBarButtonItems?.append(addScriptButton)
    
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    
    if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
      if let itemProvider = inputItem.attachments?.first {
        itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
          guard let itemDictionary = dict as? NSDictionary else { return }
          guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
          self?.pageTitle = javaScriptValues["title"] as? String ?? ""
          self?.pageURL = javaScriptValues["URL"] as? String ?? ""
          
          DispatchQueue.main.async {
            self?.title = self?.pageTitle
          }
        }
      }
    }
    
    if let host = URL(string: pageURL)?.host {
      if let savedScript = UserDefaults.standard.string(forKey: host) {
        script.text = savedScript
      }
    }
  }
  
  @objc func addScript() {
      let alert = UIAlertController(title: "New Script", message: "Enter script details", preferredStyle: .alert)
      alert.addTextField { textField in
          textField.placeholder = "Script Name"
      }
      alert.addTextField { textField in
          textField.placeholder = "Script Content"
        //textField.isScrollEnabled = true
          textField.autocapitalizationType = .none
      }

      let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] _ in
          guard let name = alert.textFields?.first?.text,
                let content = alert.textFields?.last?.text,
                !name.isEmpty else { return }
          let script = Script(name: name, content: content)
          ScriptManager.shared.saveScript(script)
      }

      alert.addAction(saveAction)
      alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
      present(alert, animated: true)
  }
  
  @objc func handleScriptSelection(_ notification: Notification) {
    if let script = notification.userInfo?["selectedScript"] as? Script {
      self.script.text = script.content
    }
  }
  
  @objc func selectScript() {
    let scriptsListVC = ScriptsListVCTableViewController()
    let navController = UINavigationController(rootViewController: scriptsListVC)
    present(navController, animated: true)
    
    let ac = UIAlertController(title: "Select a Script", message: nil, preferredStyle: .actionSheet)
    
    let exampleScripts = ["Script1", "Script2", "Script3", "Script4"]
    for script in exampleScripts {
      ac.addAction(UIAlertAction(title: script, style: .default, handler: chooseScript))
    }
    
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    
    present(ac, animated: true)
  }
  
  func chooseScript(action: UIAlertAction) {
    guard let title = action.title else { return }
    
    switch title {
    case "Script1":
      script.text = "This is a default script for Script1"
    case "Script2":
      script.text = "This is a default script for Script2"
    case "Script3":
      script.text = "This is a default script for Script3"
    default:
      break
    }
  }
  
  @IBAction func done() {
    let defaults = UserDefaults.standard
    
    if let host = URL(string: pageURL)?.host {
      defaults.set(script.text, forKey: host)
    }
    
    let item = NSExtensionItem()
    let argument: NSDictionary = ["customJavaScript": script.text]
    let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
    let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
    item.attachments = [customJavaScript]
    extensionContext?.completeRequest(returningItems: [item])
  }
  
  @objc func adjustForKeyboard(notification: Notification) {
    guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    
    let keyboardScreenEndFrame = keyboardValue.cgRectValue
    let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
    
    if notification.name == UIResponder.keyboardWillHideNotification {
      script.contentInset = .zero
    } else {
      script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
    }
    
    script.scrollIndicatorInsets = script.contentInset
    
    let selectedRange = script.selectedRange
    script.scrollRangeToVisible(selectedRange)
  }
  
}
