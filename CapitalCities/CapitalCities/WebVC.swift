//
//  WebVC.swift
//  CapitalCities
//
//  Created by Christopher Endress on 11/30/23.
//

import UIKit
import WebKit

class WebVC: UIViewController {
  @IBOutlet weak var webView: WKWebView!
  
  var urlString: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let urlString = urlString, let url = URL(string: urlString) {
      let request = URLRequest(url: url)
      webView.load(request)
    }
  }
  
}
