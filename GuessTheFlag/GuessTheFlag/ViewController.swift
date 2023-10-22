//
//  ViewController.swift
//  GuessTheFlag
//
//  Created by Christopher Endress on 10/19/23.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet var button1: UIButton!
  @IBOutlet var button2: UIButton!
  @IBOutlet var button3: UIButton!
  
  var countries = [String]()
  var score = 0
  var correctAnswer = 0
  var questionNumber = 0
  
  let scoreLabel = UILabel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    countries += ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "the UK", "the US"]
    
    button1.layer.borderWidth = 1
    button2.layer.borderWidth = 1
    button3.layer.borderWidth = 1
    
    button1.layer.borderColor = UIColor.lightGray.cgColor
    button2.layer.borderColor = UIColor.lightGray.cgColor
    button3.layer.borderColor = UIColor.lightGray.cgColor
    
    askQuestion()
  }
  
  func askQuestion(action: UIAlertAction! = nil) {
    questionNumber += 1
    countries.shuffle()
    correctAnswer = Int.random(in: 0...2)
    
    button1.setImage(UIImage(named: countries[0]), for: .normal)
    button2.setImage(UIImage(named: countries[1]), for: .normal)
    button3.setImage(UIImage(named: countries[2]), for: .normal)
    
    button1.titleLabel?.text = countries[0]
    button2.titleLabel?.text = countries[1]
    button3.titleLabel?.text = countries[2]
    
    title = countries[correctAnswer].uppercased()
    
    scoreLabel.text = "Score: \(score)"
    scoreLabel.sizeToFit()
    let scoreBarButtonItem = UIBarButtonItem(customView: scoreLabel)
    navigationItem.rightBarButtonItem = scoreBarButtonItem
  }
  
  @IBAction func buttonTapped(_ sender: UIButton) {
    var title: String
    
    if sender.tag == correctAnswer {
      title = "Correct"
      score += 1
    } else {
      if let selectedCountry = sender.titleLabel?.text {
        title = "Wrong, that is \(selectedCountry)"
      } else {
        title = "Wrong but couldn't determine the country."
      }
    }
    
    if questionNumber >= 10 {
      let finalAC = UIAlertController(title: "Game Ended", message: "Your final score is \(score)/10", preferredStyle: .alert)
      finalAC.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
        self.restartGame()
      }))
      present(finalAC, animated: true)
    } else {
      let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
      present(ac, animated: true)
    }
  }
  
  func restartGame() {
    score = 0
    askQuestion()
  }
}
