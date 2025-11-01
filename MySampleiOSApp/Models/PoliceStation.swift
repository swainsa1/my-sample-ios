//
//  PoliceStation.swift
//  MySampleiOSApp
//
//  Created on 2025-11-01.
//

import Foundation
import MapKit

struct PoliceStation: Identifiable {
    let id = UUID()
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    let phone: String

    var annotation: PoliceStationAnnotation {
        PoliceStationAnnotation(station: self)
    }
}

class PoliceStationAnnotation: NSObject, MKAnnotation {
    let station: PoliceStation

    var coordinate: CLLocationCoordinate2D {
        station.coordinate
    }

    var title: String? {
        station.name
    }

    var subtitle: String? {
        station.address
    }

    init(station: PoliceStation) {
        self.station = station
        super.init()
    }
}
