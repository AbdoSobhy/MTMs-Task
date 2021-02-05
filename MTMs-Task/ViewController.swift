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
    @IBOutlet weak var mapVIew: MKMapView!
    @IBOutlet weak var requestView: UIView!
    @IBOutlet weak var requestViewHeightConstent: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUi()
        getRequestData()
    }
    @IBAction func menuBtnWasPressed(_ sender: Any) {
        
    }
    
    func setupUi(){
        requestViewHeightConstent.constant = 0
        requestView.isHidden = true
    }

    func getRequestData(){
        let db = Firestore.firestore()
        db.collection("Requests").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting Requests: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let requestData = document.data()
                    
                    print("\(requestData)")
                }
            }
        }
    }
}

