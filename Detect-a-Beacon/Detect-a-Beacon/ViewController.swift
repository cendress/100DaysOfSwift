//
//  ViewController.swift
//  Detect-a-Beacon
//
//  Created by Christopher Endress on 12/15/23.
//

import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
  @IBOutlet weak var distanceReading: UILabel!
  
  var locationManager: CLLocationManager?
  var alertIsShown = false
  var circleView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    locationManager = CLLocationManager()
    locationManager?.delegate = self
    locationManager?.requestAlwaysAuthorization()
    
    view.backgroundColor = .gray
    setupCircleView()
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedAlways {
      if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
        if CLLocationManager.isRangingAvailable() {
          startScanning()
        }
      }
    }
  }
  
  func startScanning() {
    let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
    let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")
    
    locationManager?.startMonitoring(for: beaconRegion)
    locationManager?.startRangingBeacons(in: beaconRegion)
  }
  
  func update(distance: CLProximity) {
    UIView.animate(withDuration: 1) {
      switch distance {
        
      case .far :
        self.view.backgroundColor = .blue
        self.distanceReading.text = "FAR"
        
      case .near :
        self.view.backgroundColor = .orange
        self.distanceReading.text = "NEAR"
        
      case .immediate :
        self.view.backgroundColor = .red
        self.distanceReading.text = "RIGHT HERE"
        
      default:
        self.view.backgroundColor = .gray
        self.distanceReading.text = "UNKNOWN"
      }
      
      self.animateCircle(for: distance)
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
    if let beacon = beacons.first {
      update(distance: beacon.proximity)
      
      if !alertIsShown {
        let ac = UIAlertController(title: "Beacon Detected", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        
        alertIsShown = true
      }
    } else {
      update(distance: .unknown)
    }
  }
  
  func setupCircleView() {
    circleView = UIView(frame: CGRect(x: (view.bounds.width - 256) / 2, y: (view.bounds.height - 256) / 2, width: 256, height: 256))
    circleView.layer.cornerRadius = 128
    circleView.backgroundColor = UIColor.green
    view.addSubview(circleView)
  }
  
  func animateCircle(for distance: CLProximity) {
    var scale: CGFloat = 0.0
    
    switch distance {
    case .far:
      scale = 0.25
    case .near:
      scale = 0.5
    case .immediate:
      scale = 1.0
    default:
      scale = 0.001
    }
    
    UIView.animate(withDuration: 1) {
      self.circleView.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
  }
  
}

