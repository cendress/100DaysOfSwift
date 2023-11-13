//
//  Person.swift
//  NamesToFaces
//
//  Created by Christopher Endress on 11/12/23.
//

import UIKit

class Person: NSObject {
  var name: String
  var image: String
  
  init(name: String, image: String) {
    self.name = name
    self.image = image
  }
}
