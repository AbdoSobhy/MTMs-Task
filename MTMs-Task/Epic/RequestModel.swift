//
//  RequestModel.swift
//  MTMs-Task
//
//  Created by Abdelrahman Sobhy on 2/6/21.
//

import Foundation
class RequestModel {
    let sourceLatitude: Double
    let sourceLongitude: Double
    let destinationLatitude: Double?
    let destinationLongitude: Double?
    let requestDate: Data
    let clientName: String
    let clientPhone: String
    let drivers: [String]
    
    init(sourceLatitude: Double, sourceLongitude: Double, destinationLatitude: Double?, destinationLongitude: Double?, requestDate: Data, clientName: String, clientPhone: String, drivers: [String]) {
        self.sourceLatitude = sourceLatitude
        self.sourceLongitude = sourceLongitude
        self.destinationLatitude = destinationLatitude
        self.destinationLongitude = destinationLongitude
        self.requestDate = requestDate
        self.clientName = clientName
        self.clientPhone = clientPhone
        self.drivers = drivers
    }
}
