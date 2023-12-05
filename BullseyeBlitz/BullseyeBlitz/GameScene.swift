//
//  GameScene.swift
//  BullseyeBlitz
//
//  Created by Christopher Endress on 12/5/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
  var targetSize = [150, 100, 50, 200]
  var scoreLabel: SKLabelNode!
  var score = 0 {
    didSet {
      scoreLabel.text = "Score: \(score)"
    }
  }
  
  var gameTimer: Timer?
  var timeRemaining = 60 {
    didSet {
      if timeRemaining < 1 {
        gameTimer?.invalidate()
        gameTimer = nil
        gameOver()
      }
    }
  }
  
  override func didMove(to view: SKView) {
    let background = SKSpriteNode(imageNamed: "background")
    background.size = self.size
    background.position = CGPoint(x: size.width / 2, y: size.height / 2)
    background.zPosition = -1
    addChild(background)
    
    scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    scoreLabel.text = "Score: 0"
    scoreLabel.position = CGPoint(x: 10, y: size.height - 30)
    scoreLabel.horizontalAlignmentMode = .left
    scoreLabel.fontSize = 20
    addChild(scoreLabel)
    
    gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
      self?.timeRemaining -= 1
    }
    
    let rowHeight = size.height / 4
    
    for i in 1...3 {
      let row = SKNode()
      row.position = CGPoint(x: frame.midX, y: CGFloat(i) * rowHeight)
      addChild(row)
      
      let waitAction = SKAction.wait(forDuration: 2.0)
      let spawnAction = SKAction.run { [weak self] in
        self?.createTarget(isGoodTarget: Bool.random(), inRow: row, rowIndex: i)
      }
      
      let sequenceAction = SKAction.sequence([waitAction, spawnAction])
      let repeatAction = SKAction.repeatForever(sequenceAction)
      row.run(repeatAction)
    }
  }
  
  func createTarget(isGoodTarget: Bool, inRow row: SKNode, rowIndex: Int) {
    let target = SKSpriteNode(imageNamed: isGoodTarget ? "goodTarget" : "badTarget")
    target.name = isGoodTarget ? "goodTarget" : "badTarget"
    target.size = CGSize(width: targetSize.randomElement() ?? 150, height: targetSize.randomElement() ?? 150)
    let startX = rowIndex % 2 == 0 ? -target.size.width / 2 : size.width + target.size.width / 2
    target.position = CGPoint(x: startX, y: 0)
    target.zRotation = 0
    row.addChild(target)
    
    let moveX = rowIndex % 2 == 0 ? size.width + target.size.width : -size.width - target.size.width
    let moveAction = SKAction.moveBy(x: moveX, y: 0, duration: 5.0)
    let removeAction = SKAction.removeFromParent()
    let sequenceAction = SKAction.sequence([moveAction, removeAction])
    target.run(sequenceAction)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    let nodesAtPoint = nodes(at: location)
    
    for node in nodesAtPoint {
      if node.name == "goodTarget" {
        score += 1
      } else if node.name == "badTarget" {
        score -= 1
      }
    }
  }
  
  func gameOver() {
    let gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
    gameOverLabel.text = "Game Over! Score: \(score)"
    gameOverLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
    gameOverLabel.fontSize = 30
    addChild(gameOverLabel)
    
    removeAllActions()
    children.forEach { $0.removeAllActions() }
  }
  
  override func update(_ currentTime: TimeInterval) {
    
  }
}
