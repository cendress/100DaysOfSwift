//
//  ViewController.swift
//  SelfieShare
//
//  Created by Christopher Endress on 1/2/24.
//

import MultipeerConnectivity
import UIKit

class ViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate {
  
  var images = [UIImage]()
  
  var peerID = MCPeerID(displayName: UIDevice.current.name)
  var mcSession: MCSession?
  var mcAdvertiserAssistant: MCAdvertiserAssistant?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Selfie Share"
    
    let camera = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
    let compose = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(composeButtonTapped(_:)))
    navigationItem.rightBarButtonItems = [camera, compose]
    
    let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
    let search = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonTapped))
    navigationItem.leftBarButtonItems = [add, search]
    
    mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
    mcSession?.delegate = self
  }
  
  @objc func searchButtonTapped() {
    guard let mcSession = mcSession else { return }
    
    var peerMessage = "Connected Users:\n"
    if mcSession.connectedPeers.isEmpty {
      peerMessage += "No users are currently connected"
    } else {
      for peer in mcSession.connectedPeers {
        peerMessage += "- \(peer.displayName)\n"
      }
    }
    
    let ac = UIAlertController(title: "Connected Devices", message: peerMessage, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "OK", style: .default))
    present(ac, animated: true)
  }
  
  @objc func composeButtonTapped(_ sender: UIBarButtonItem) {
    sendTextMessage()
  }
  
  func sendTextMessage(_ message: String? = nil) {
    let ac = UIAlertController(title: "Send Message", message: nil, preferredStyle: .alert)
    ac.addTextField { textField in
      textField.text = message
      textField.placeholder = "Enter a message"
    }
    
    ac.addAction(UIAlertAction(title: "Send", style: .default, handler: {  [weak self, weak ac] _ in
      guard let text = ac?.textFields?[0].text, let mcSession = self?.mcSession, !mcSession.connectedPeers.isEmpty else { return }
      
      let messageData = Data(text.utf8)
      do {
        try mcSession.send(messageData, toPeers: mcSession.connectedPeers, with: .reliable)
      } catch {
        let errorMessage = UIAlertController(title: "Error Sending Message", message: error.localizedDescription, preferredStyle: .alert)
        errorMessage.addAction(UIAlertAction(title: "OK", style: .default))
        self?.present(errorMessage, animated: true)
      }
    }))
    
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    present(ac, animated: true)
  }
  
  func showReceivedMessageAlert(message: String) {
    let ac = UIAlertController(title: "Message Received", message: nil, preferredStyle: .alert)
    ac.addTextField { textField in
      textField.placeholder = "Reply here"
    }
    
    let reply = UIAlertAction(title: "Reply", style: .default) { [weak self, weak ac] _ in
      guard let text = ac?.textFields?[0].text else { return }
      self?.sendTextMessage(text)
    }
    
    let cancel = UIAlertAction(title: "Cancel", style: .cancel)
    
    ac.addAction(cancel)
    ac.addAction(reply)
    present(ac, animated: true)
  }
  
  func startHosting(action: UIAlertAction) {
    guard let mcSession = mcSession else { return }
    mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-project25", discoveryInfo: nil, session: mcSession)
    mcAdvertiserAssistant?.start()
  }
  
  func joinSession(action: UIAlertAction) {
    guard let mcSession = mcSession else { return }
    let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session: mcSession)
    mcBrowser.delegate = self
    present(mcBrowser, animated: true)
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return images.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
    
    if let imageView = cell.viewWithTag(1000) as? UIImageView {
      imageView.image = images[indexPath.item]
    }
    
    return cell
  }
  
  @objc func importPicture() {
    let picker = UIImagePickerController()
    picker.allowsEditing = true
    picker.delegate = self
    present(picker, animated: true)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[.editedImage] as? UIImage else { return }
    dismiss(animated: true)
    
    images.insert(image, at: 0)
    collectionView.reloadData()
    
    guard let mcSession = mcSession else { return }
    
    if mcSession.connectedPeers.count > 0 {
      if let imageData = image.pngData() {
        do {
          try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
        } catch {
          let ac = UIAlertController(title: "Send Error", message: error.localizedDescription, preferredStyle: .alert)
          ac.addAction(UIAlertAction(title: "OK", style: .default))
          present(ac, animated: true)
        }
      }
    }
  }
  
  @objc func showConnectionPrompt() {
    let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
    ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    present(ac, animated: true)
  }
  
  func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    
  }
  
  func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    
  }
  
  func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    
  }
  
  func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
    dismiss(animated: true)
  }
  
  func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
    dismiss(animated: true)
  }
  
  func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    switch state {
    case .connected:
      print("Connected: \(peerID.displayName)")
      
    case .connecting:
      print("Connecting: \(peerID.displayName)")
      
    case .notConnected:
      print("Not connected: \(peerID.displayName)")
      DispatchQueue.main.async { [weak self] in
        self?.didDisconnect(peerName: peerID.displayName)
      }
      
    @unknown default:
      print("Unknown state received: \(peerID.displayName)")
    }
  }
  
  func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
    DispatchQueue.main.async { [weak self] in
      if let text = String(data: data, encoding: .utf8), text.hasPrefix("Text:") {
        let messageText = text.replacingOccurrences(of: "Text:", with: "")
        self?.showReceivedMessageAlert(message: messageText)
      } else if let image = UIImage(data: data) {
        self?.images.insert(image, at: 0)
        self?.collectionView.reloadData()
      }
    }
  }
  
  func didDisconnect(peerName: String) {
    let ac = UIAlertController(title: "\(peerName) Disconnected", message: nil, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "OK", style: .default))
    present(ac, animated: true)
  }
  
}

