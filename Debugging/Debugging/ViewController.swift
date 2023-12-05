//
//  ViewController.swift
//  Debugging
//
//  Created by Christopher Endress on 12/3/23.
//

import UIKit

class ViewController: UIViewController {
var count = 1
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    print("Hello", 1, separator: ",")
    
    for i in 1...100 {
      print("Got number \(i).")
    }
  }
}

