//
//  ViewController.swift
//  Hangman
//
//  Created by Christopher Endress on 11/10/23.
//

import UIKit

class ViewController: UIViewController {
  var scoreLabel: UILabel!
  var livesRemainingLabel: UILabel!
  var wordLabel: UILabel!
  var letterInput: UITextField!
  var submitButton: UIButton!
  
  var score = 0
  var livesRemaining = 4
  var hiddenText = ""
  
  var word: String {
    return "WORD"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    loadGame()
    livesRemaining = word.count
    
    submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
  }
  
  private func configureUI() {
    view.backgroundColor = .black
    
    scoreLabel = UILabel()
    scoreLabel.translatesAutoresizingMaskIntoConstraints = false
    scoreLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    scoreLabel.textColor = .white
    scoreLabel.textAlignment = .center
    scoreLabel.text = "Score: \(score)"
    view.addSubview(scoreLabel)
    
    livesRemainingLabel = UILabel()
    livesRemainingLabel.translatesAutoresizingMaskIntoConstraints = false
    livesRemainingLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    livesRemainingLabel.textColor = .systemRed
    livesRemainingLabel.textAlignment = .center
    livesRemainingLabel.text = "Lives Remaining: \(livesRemaining)"
    view.addSubview(livesRemainingLabel)
    
    wordLabel = UILabel()
    wordLabel.translatesAutoresizingMaskIntoConstraints = false
    wordLabel.font = UIFont.boldSystemFont(ofSize: 24)
    wordLabel.textColor = .systemBlue
    wordLabel.textAlignment = .center
    wordLabel.text = hiddenText
    view.addSubview(wordLabel)
    
    letterInput = UITextField()
    letterInput.translatesAutoresizingMaskIntoConstraints = false
    letterInput.font = UIFont.systemFont(ofSize: 18)
    letterInput.borderStyle = .roundedRect
    letterInput.backgroundColor = .white
    letterInput.layer.cornerRadius = 5
    letterInput.placeholder = "Enter a letter"
    view.addSubview(letterInput)
    
    submitButton = UIButton()
    submitButton.translatesAutoresizingMaskIntoConstraints = false
    submitButton.setTitle("Submit", for: .normal)
    submitButton.backgroundColor = .systemGreen
    submitButton.layer.cornerRadius = 10
    submitButton.layer.shadowColor = UIColor.black.cgColor
    submitButton.layer.shadowOffset = CGSize(width: 0, height: 2)
    submitButton.layer.shadowOpacity = 0.5
    submitButton.layer.shadowRadius = 4
    submitButton.setTitleColor(.white, for: .normal)
    view.addSubview(submitButton)
    
    NSLayoutConstraint.activate([
      scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      scoreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      scoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      
      livesRemainingLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 20),
      livesRemainingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      livesRemainingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      
      wordLabel.topAnchor.constraint(equalTo: livesRemainingLabel.bottomAnchor, constant: 20),
      wordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      wordLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      
      letterInput.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 20),
      letterInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      letterInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      
      submitButton.topAnchor.constraint(equalTo: letterInput.bottomAnchor, constant: 20),
      submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      submitButton.heightAnchor.constraint(equalToConstant: 50)
    ])
  }
  
  private func loadGame() {
    score = 0
    livesRemaining = word.count
    hiddenText = String(repeating: "?", count: word.count)
    
    if let wordLabel = wordLabel {
      wordLabel.text = hiddenText
    }
  }
  
  @objc private func submitButtonTapped() {
    guard let validInput = letterInput.text, validInput.count == 1 else {
      presentAlert(title: "Invalid Guess", message: "Please enter a one letter guess")
      letterInput.text = ""
      return
    }
    
    guard validInput.rangeOfCharacter(from: CharacterSet.letters) != nil else {
      presentAlert(title: "Invalid Guess", message: "Please enter a letter")
      letterInput.text = ""
      return
    }
    
    let inputLetter = validInput.uppercased()
    var newHiddenText = ""
    var foundMatch = false
    var correctGuessCount = 0
    
    for (index, letter) in word.enumerated() {
      if String(letter) == inputLetter {
        newHiddenText += inputLetter
        foundMatch = true
        correctGuessCount += 1
      } else {
        let hiddenLetterIndex = hiddenText.index(hiddenText.startIndex, offsetBy: index)
        newHiddenText += String(hiddenText[hiddenLetterIndex])
      }
    }
    
    if foundMatch {
      hiddenText = newHiddenText
      wordLabel.text = hiddenText
      score += correctGuessCount
      scoreLabel.text = "Score: \(score)" 
      checkForWin()
    } else {
      livesRemaining -= 1
      livesRemainingLabel.text = "Lives Remaining: \(livesRemaining)"
      checkForLose()
    }
    
    letterInput.text = ""
  }
  
  private func presentAlert(title: String, message: String) {
    let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "OK", style: .default))
    present(ac, animated: true)
  }
  
  
  private func checkForWin() {
    if hiddenText == word {
      let ac = UIAlertController(title: "Congratulations!", message: "You guessed the word!", preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "Play Again", style: .default) { [weak self] _ in
        self?.resetGame()
      })
      present(ac, animated: true)
    }
  }
  
  private func checkForLose() {
    if livesRemaining == 0 {
      let ac = UIAlertController(title: "Game Over", message: "You've run out of lives!", preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "Try Again", style: .default) { [weak self] _ in
        self?.resetGame()
      })
      present(ac, animated: true)
    }
  }
  
  private func resetGame() {
    score = 0
    livesRemaining = word.count
    hiddenText = String(repeating: "?", count: word.count)
    wordLabel.text = hiddenText
    scoreLabel.text = "Score: \(score)"
    livesRemainingLabel.text = "Lives Remaining: \(livesRemaining)"
  }
  
}

