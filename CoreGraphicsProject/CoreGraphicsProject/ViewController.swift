//
//  ViewController.swift
//  CoreGraphicsProject
//
//  Created by Christopher Endress on 1/7/24.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var imageView: UIImageView!
  var currentDrawType = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    drawRectangle()
  }
  
  @IBAction func redrawTapped(_ sender: UIButton) {
    currentDrawType += 1
    
    if currentDrawType > 6 {
      currentDrawType = 0
    }
    
    switch currentDrawType {
    case 0:
      drawRectangle()
      
    case 1:
      drawCircle()
      
    case 2:
      drawCheckerboard()
      
    case 3:
      drawRotatedSquares()
      
    case 4:
      drawLines()
      
    case 5:
      drawImagesAndText()
      
    case 6:
      drawEmoji()
      
    default:
      break
    }
  }
  
  func drawEmoji() {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
    
    let image = renderer.image { ctx in
      let faceRect = CGRect(x: 106, y: 106, width: 300, height: 300)
      ctx.cgContext.setFillColor(UIColor.yellow.cgColor)
      ctx.cgContext.addEllipse(in: faceRect)
      ctx.cgContext.drawPath(using: .fill)
      
      let eyeRectLeft = CGRect(x: 176, y: 196, width: 50, height: 70)
      let eyeRectRight = CGRect(x: 286, y: 196, width: 50, height: 70)
      ctx.cgContext.setFillColor(UIColor.black.cgColor)
      ctx.cgContext.addEllipse(in: eyeRectLeft)
      ctx.cgContext.addEllipse(in: eyeRectRight)
      ctx.cgContext.drawPath(using: .fill)
      
      let smileRect = CGRect(x: 176, y: 260, width: 160, height: 100)
      ctx.cgContext.addEllipse(in: smileRect)
      ctx.cgContext.clip()
      ctx.cgContext.addRect(smileRect)
      ctx.cgContext.drawPath(using: .fill)
    }
    
    imageView.image = image
  }
  
  func drawRectangle() {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
    
    let image = renderer.image { context in
      let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
      
      context.cgContext.setFillColor(UIColor.red.cgColor)
      context.cgContext.setStrokeColor(UIColor.black.cgColor)
      context.cgContext.setLineWidth(10)
      
      context.cgContext.addRect(rectangle)
      context.cgContext.drawPath(using: .fillStroke)
    }
    
    imageView.image = image
  }
  
  func drawImagesAndText() {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
    
    let image = renderer.image { context in
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.alignment = .center
      
      let attrs: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 36),
        .paragraphStyle: paragraphStyle
      ]
      
      let string = "The best-laid schemes o '\nmice an' men gang aft agley"
      
      let attributedString = NSAttributedString(string: string, attributes: attrs)
      attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
      
      let mouse = UIImage(named: "mouse")
      mouse?.draw(at: CGPoint(x: 300, y: 150))
    }
    
    imageView.image = image
  }
  
  func drawLines() {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
    
    let image = renderer.image { context in
      context.cgContext.translateBy(x: 256, y: 256)
      
      var first = true
      var length: CGFloat = 256
      
      for _ in 0..<256 {
        context.cgContext.rotate(by: .pi / 2)
        
        if first {
          context.cgContext.move(to: CGPoint(x: length, y: 50))
          first = false
        } else {
          context.cgContext.addLine(to: CGPoint(x: length, y: 50))
        }
        
        length *= 0.99
      }
      
      context.cgContext.setStrokeColor(UIColor.systemTeal.cgColor)
      context.cgContext.strokePath()
    }
    
    imageView.image = image
  }
  
  func drawRotatedSquares() {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
    
    let image = renderer.image { context in
      context.cgContext.translateBy(x: 256, y: 256)
      
      let rotations = 16
      let amount = Double.pi / Double(rotations)
      
      for _ in 0 ..< rotations {
        context.cgContext.rotate(by: CGFloat(amount))
        context.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
      }
      
      context.cgContext.setStrokeColor(UIColor.black.cgColor)
      context.cgContext.strokePath()
    }
    
    imageView.image = image
  }
  
  func drawCheckerboard() {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
    
    let image = renderer.image { context in
      context.cgContext.setFillColor(UIColor.black.cgColor)
      
      for row in 0..<8 {
        for col in 0..<8 {
          if (row + col) % 2 == 0 {
            context.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
          }
        }
      }
    }
    
    imageView.image = image
  }
  
  func drawCircle() {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
    
    let image = renderer.image { context in
      let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
      
      context.cgContext.setFillColor(UIColor.red.cgColor)
      context.cgContext.setStrokeColor(UIColor.black.cgColor)
      context.cgContext.setLineWidth(10)
      
      context.cgContext.addEllipse(in: rectangle)
      context.cgContext.drawPath(using: .fillStroke)
    }
    
    imageView.image = image
  }
  
}

