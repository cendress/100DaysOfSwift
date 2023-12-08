//
//  ScriptManager.swift
//  Extension
//
//  Created by Christopher Endress on 12/8/23.
//

import Foundation

class ScriptManager {
  static let shared = ScriptManager()
  private let defaults = UserDefaults.standard
  private let scriptsKey = "SavedScripts"
  
  func saveScript(_ script: Script) {
    var scripts = loadScripts()
    if let index = scripts.firstIndex(where: { $0.name == script.name }) {
      scripts[index] = script
    } else {
      scripts.append(script)
    }
    saveScripts(scripts)
  }
  
  func loadScripts() -> [Script] {
    guard let data = defaults.data(forKey: scriptsKey) else { return [] }
    let decoder = JSONDecoder()
    return (try? decoder.decode([Script].self, from: data)) ?? []
  }
  
  private func saveScripts(_ scripts: [Script]) {
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(scripts) {
      defaults.set(encoded, forKey: scriptsKey)
    }
  }
}
