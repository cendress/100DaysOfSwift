//
//  ViewController.swift
//  CapitalCities
//
//  Created by Christopher Endress on 11/29/23.
//

import MapKit
import UIKit

class ViewController: UIViewController, MKMapViewDelegate {
  @IBOutlet weak var mapView: MKMapView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Map Type", style: .plain, target: self, action: #selector(selectMapType))
    navigationItem.rightBarButtonItem?.tintColor = .black
    
    let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics")
    let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
    let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
    let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
    let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
    
    mapView.addAnnotations([london, oslo, paris, rome, washington])
    
  }
  
  @objc func selectMapType() {
    let ac = UIAlertController(title: "Select Map Type", message: nil, preferredStyle: .actionSheet)
    
    ac.addAction(UIAlertAction(title: "Standard", style: .default, handler: mapTypeChanged))
    ac.addAction(UIAlertAction(title: "Satellite", style: .default, handler: mapTypeChanged))
    ac.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: mapTypeChanged))
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    
    present(ac, animated: true)
  }
  
  private func mapTypeChanged(action: UIAlertAction) {
    guard let title = action.title else { return }
    
    switch title {
    case "Standard":
      mapView.mapType = .standard
    case "Satellite":
      mapView.mapType = .satellite
    case "Hybrid":
      mapView.mapType = .hybrid
    default:
      break
    }
  }
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard annotation is Capital else { return nil }
    
    let identifier = "Capital"
    
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
      
      if annotationView == nil {
        annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        annotationView?.canShowCallout = true
        annotationView?.tintColor = .systemBlue
        
        let btn = UIButton(type: .detailDisclosure)
        annotationView?.rightCalloutAccessoryView = btn
      } else {
        annotationView?.annotation = annotation
      }
      
      return annotationView
  }
  
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    guard let capital = view.annotation as? Capital else { return }
    
    let wikipediaURL = "https://en.wikipedia.org/wiki/\(capital.title ?? "")"
    
    if let webVC = storyboard?.instantiateViewController(withIdentifier: "WebVC") as? WebVC {
      webVC.urlString = wikipediaURL
      navigationController?.pushViewController(webVC, animated: true)
    }
  }
}

