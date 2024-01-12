//
//  ViewController.swift
//  SecretSwift
//
//  Created by Christopher Endress on 1/11/24.
//

import LocalAuthentication
import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var secret: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Nothing to see here"
    
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
    
  }
  
  @objc func lockApp() {
    saveSecretMessage()
    secret.isHidden = true
    title = "Nothing to see here"
    navigationItem.rightBarButtonItem = nil
  }
  
  @IBAction func authenticateTapped(_ sender: UIButton) {
    let context = LAContext()
    var error: NSError?
    
    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
      let reason = "Identify yourself!"
      
      context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
        DispatchQueue.main.async {
          if success {
            self?.unlockSecretMessage()
          } else {
            self?.requestPassword()
          }
        }
      }
    } else {
      requestPassword()
    }
  }
  
  func requestPassword() {
    let ac = UIAlertController(title: "Enter Password", message: nil, preferredStyle: .alert)
    ac.addTextField { textField in
      textField.isSecureTextEntry = true
      textField.placeholder = "Enter password"
    }
    
    ac.addAction(UIAlertAction(title: "Done", style: .default) { [weak self] _ in
      guard let textField = ac.textFields?.first, let password = textField.text, !password.isEmpty else { return }
      if self?.isPasswordCorrect(password) == true {
        self?.unlockSecretMessage()
      } else {
        self?.showAuthenticationFailedAlert()
      }
    })
    
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    present(ac, animated: true)
  }
  
  func isPasswordCorrect(_ password: String) -> Bool {
    return password == KeychainWrapper.standard.string(forKey: "Password")
  }
  
  func showAuthenticationFailedAlert() {
    let ac = UIAlertController(title: "Authentication Failed", message: "Wrong password. Please try again.", preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "OK", style: .default))
    present(ac, animated: true)
  }
  
  @objc func adjustForKeyboard(notification: Notification) {
    guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    
    let keyboardScreenEnd = keyboardValue.cgRectValue
    let keyboardViewEndFrame = view.convert(keyboardScreenEnd, from: view.window)
    
    if notification.name == UIResponder.keyboardWillHideNotification {
      secret.contentInset = .zero
    } else {
      secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
    }
    
    secret.scrollIndicatorInsets = secret.contentInset
    
    let selectedRange = secret.selectedRange
    secret.scrollRangeToVisible(selectedRange)
  }
  
  func unlockSecretMessage() {
    secret.isHidden = false
    title = "Secret stuff!"
    
    secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(lockApp))
  }
  
  @objc func saveSecretMessage() {
    guard secret.isHidden == false else { return }
    
    KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
    secret.resignFirstResponder()
    secret.isHidden = true
    title = "Nothing to see here"
  }
  
}
