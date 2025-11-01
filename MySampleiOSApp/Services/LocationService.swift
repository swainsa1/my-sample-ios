//
//  LocationService.swift
//  MySampleiOSApp
//
//  Created on 2025-11-01.
//

import Foundation
import MapKit

class LocationService {
    // Apple Valley, MN 55124 coordinates
    static let appleValleyCenter = CLLocationCoordinate2D(
        latitude: 44.7319,
        longitude: -93.2177
    )

    // Police stations within 5 miles of Apple Valley, MN 55124
    static func getPoliceStations() -> [PoliceStation] {
        return [
            PoliceStation(
                name: "Apple Valley Police Department",
                address: "7100 147th St W, Apple Valley, MN 55124",
                coordinate: CLLocationCoordinate2D(latitude: 44.7319, longitude: -93.2177),
                phone: "(952) 953-2700"
            ),
            PoliceStation(
                name: "Rosemount Police Department",
                address: "2875 145th St W, Rosemount, MN 55068",
                coordinate: CLLocationCoordinate2D(latitude: 44.7394, longitude: -93.1258),
                phone: "(651) 322-2000"
            ),
            PoliceStation(
                name: "Eagan Police Department",
                address: "3830 Pilot Knob Rd, Eagan, MN 55122",
                coordinate: CLLocationCoordinate2D(latitude: 44.8041, longitude: -93.1666),
                phone: "(651) 675-5700"
            ),
            PoliceStation(
                name: "Lakeville Police Department",
                address: "20025 Holyoke Ave, Lakeville, MN 55044",
                coordinate: CLLocationCoordinate2D(latitude: 44.6497, longitude: -93.2427),
                phone: "(952) 985-4600"
            ),
            PoliceStation(
                name: "Burnsville Police Department",
                address: "100 Civic Center Pkwy, Burnsville, MN 55337",
                coordinate: CLLocationCoordinate2D(latitude: 44.7677, longitude: -93.2777),
                phone: "(952) 895-4600"
            )
        ]
    }

    // Calculate distance in miles between two coordinates
    static func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
        let fromLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let toLocation = CLLocation(latitude: to.latitude, longitude: to.longitude)
        let meters = fromLocation.distance(from: toLocation)
        return meters * 0.000621371 // Convert meters to miles
    }

    // Filter stations within radius
    static func stationsWithinRadius(center: CLLocationCoordinate2D, radiusMiles: Double) -> [PoliceStation] {
        return getPoliceStations().filter { station in
            distance(from: center, to: station.coordinate) <= radiusMiles
        }
    }
}
