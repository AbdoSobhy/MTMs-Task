//
//  ViewController.swift
//  MTMs-Task
//
//  Created by Abdelrahman Sobhy on 2/5/21.
//

import UIKit
import MapKit

class RequestMapVC: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var requestView: UIView!
    @IBOutlet weak var sideMeueLayout: NSLayoutConstraint!
    @IBOutlet weak var requestViewHeightConstent: NSLayoutConstraint!
    @IBOutlet weak var clintNameLbl: UILabel!
    @IBOutlet weak var destLbl: UILabel!
    
    let viewModel = RequestMapViewModel()
    
    let locationManger = CLLocationManager()
    var counter = 0

    private var requestModel: RequestModel? {
        didSet{
            setupLocationManger()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUi()
        viewModel.getRequestData { [weak self] requestModel in self?.requestModel = requestModel}
    }
    
    @IBAction func menuBtnWasPressed(_ sender: Any) {
        sideMeueLayout.constant = sideMeueLayout.constant == 0 ? (self.view.frame.size.width * 0.7) : 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func setupLocationManger(){
        locationManger.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManger.delegate = self
            locationManger.desiredAccuracy = kCLLocationAccuracyBest
            locationManger.startUpdatingLocation()
        }
    }
    
    func setupUi(){
        mapView.delegate = self
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .dark
        }
        requestViewHeightConstent.constant = 0
        requestView.isHidden = true
    }
    
    func showRequest(clintName: String){
        requestView.isHidden = false
        requestViewHeightConstent.constant = 270
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        clintNameLbl.text = clintName
    }
    
    func setDistance(_ locations: [CLLocation]) -> String {
       if let longitude = requestModel?.sourceLongitude, let latitude = requestModel?.sourceLatitude {
           let distance = locations.last?.distance(from: CLLocation(latitude: latitude, longitude: longitude)).binade
           let speed = " | " + (locations.last?.speed.description ?? "--") + " " + "M/S"
           return String(format: "%.1f", distance ?? 0.0) + " " + "Meters" + speed
       } else {
        return ""
       }
    }
}


extension RequestMapVC: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.systemBlue
        renderer.lineWidth = 8.0
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")
        if annotation.title != "" {
            annotationView.glyphText = "A"
            annotationView.markerTintColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        } else {

        }
        annotationView.animatesWhenAdded = true
        return annotationView
    }
    
    func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        guard counter < 1 else {return}
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
                
                self?.showRequest(clintName: self?.requestModel?.clientName ?? "")
                self?.counter += 1
            }
        }
    }
}
extension RequestMapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentCoordinate = manager.location?.coordinate {
            if let lat = requestModel?.sourceLatitude, let long = requestModel?.sourceLongitude {
                let destCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                self.showRouteOnMap(pickupCoordinate: currentCoordinate, destinationCoordinate: destCoordinate)
                self.destLbl.text = setDistance(locations)
            }
        }
    }
    
}

