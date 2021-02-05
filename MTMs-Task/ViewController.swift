//
//  ViewController.swift
//  MTMs-Task
//
//  Created by Abdelrahman Sobhy on 2/5/21.
//

import UIKit
import Firebase
import MapKit

class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var requestView: UIView!
    @IBOutlet weak var sideMeueLayout: NSLayoutConstraint!
    @IBOutlet weak var requestViewHeightConstent: NSLayoutConstraint!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUi()
        getRequestData()
    }
    
    @IBAction func menuBtnWasPressed(_ sender: Any) {
        sideMeueLayout.constant = sideMeueLayout.constant == 0 ? (self.view.frame.size.width * 0.7) : 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    func setupUi(){
        mapView.delegate = self
        self.overrideUserInterfaceStyle = .dark
        requestViewHeightConstent.constant = 0
        requestView.isHidden = true
    }
    
    func showRequest(){
        requestView.isHidden = false
        requestViewHeightConstent.constant = 270
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func getRequestData(){
        let db = Firestore.firestore()
        db.collection("Requests").getDocuments() {[weak self] (querySnapshot, err) in
            if let err = err {
                print("Error getting Requests: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let requestData = document.data()
                    let long = requestData["sourceLongitude"] as? Double ?? 0
                    let lat = requestData["sourceLatitude"] as? Double ?? 0
                    let destLang = requestData["destinationLongitude"] as? Double ?? 0
                    let destLat = requestData["destinationLatitude"] as? Double ?? 0
                    // show route
                    let coordinateOne = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: lat)!, longitude: CLLocationDegrees(exactly: long)!)
                    let coordinateTwo = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: destLat)!, longitude: CLLocationDegrees(exactly: destLang)!)
                    self?.showRouteOnMap(pickupCoordinate: coordinateOne, destinationCoordinate: coordinateTwo)
                    
                }
            }
        }
    }
}

extension ViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.systemBlue
        renderer.lineWidth = 8.0
        return renderer
        
        
    }
        
    func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        
        let request = MKDirections.Request()
        let annotation = MKPointAnnotation()
        let destAnnotation = MKPointAnnotation()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .any
        annotation.coordinate = pickupCoordinate
        annotation.title = ""
        mapView.addAnnotation(annotation)
        destAnnotation.coordinate = destinationCoordinate
        mapView.addAnnotation(destAnnotation)
        
        let directions = MKDirections(request: request)
        // get paths
        directions.calculate { [weak self] response, error in
            guard let unwrappedResponse = response else { return }
            
            if let route = unwrappedResponse.routes.first {
                self?.mapView.addOverlay(route.polyline)
                self?.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets.init(top: 180.0, left: 120.0, bottom: 300.0, right: 120.0), animated: true)
                self?.showRequest()
            }
        }
    }
}

