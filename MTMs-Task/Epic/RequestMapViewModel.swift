//
//  RequestMapViewModel.swift
//  MTMs-Task
//
//  Created by Abdelrahman Sobhy on 2/6/21.
//

import Foundation
import Firebase

class RequestMapViewModel {
    
    func getRequestData(completionHandler: @escaping (RequestModel) -> Void){
        let db = Firestore.firestore()
        db.collection("Requests").getDocuments() {(querySnapshot, err) in
            if let err = err {
                print("Error getting Requests: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let requestData = document.data()
                    let clientName = requestData["clientName"] as? String ?? ""
                    let clientPhone = requestData["clientPhone"] as? String ?? ""
                    let drivers = requestData["driverKey"] as? [String] ?? []
                    let requestDate = requestData["requestDate"] as? Data ?? Data()
                    let long = requestData["sourceLongitude"] as? Double ?? 0
                    let lat = requestData["sourceLatitude"] as? Double ?? 0
                    let destLong = requestData["destinationLongitude"] as? Double ?? 0
                    let destLat = requestData["destinationLatitude"] as? Double ?? 0
                    let requestObj = RequestModel(sourceLatitude: lat, sourceLongitude: long, destinationLatitude: destLat, destinationLongitude: destLong, requestDate: requestDate, clientName: clientName, clientPhone: clientPhone, drivers: drivers)
                    
                    completionHandler(requestObj)
                    // show route
                }
            }
        }
    }

}
