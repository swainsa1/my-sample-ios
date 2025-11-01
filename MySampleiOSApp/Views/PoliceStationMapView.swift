//
//  PoliceStationMapView.swift
//  MySampleiOSApp
//
//  Created on 2025-11-01.
//

import SwiftUI
import MapKit

struct PoliceStationMapView: View {
    @ObservedObject var viewModel: LoginViewModel
    @State private var region: MKCoordinateRegion
    @State private var policeStations: [PoliceStation] = []
    @State private var selectedStation: PoliceStation?

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel

        // Initialize region centered on Apple Valley, MN
        let center = LocationService.appleValleyCenter
        _region = State(initialValue: MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
        ))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Map View
                Map(coordinateRegion: $region, annotationItems: policeStations) { station in
                    MapAnnotation(coordinate: station.coordinate) {
                        VStack(spacing: 0) {
                            Image(systemName: "shield.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                                .padding(8)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                                .onTapGesture {
                                    selectedStation = station
                                }

                            Image(systemName: "arrowtriangle.down.fill")
                                .font(.caption)
                                .foregroundColor(.blue)
                                .offset(y: -5)
                        }
                    }
                }
                .edgesIgnoringSafeArea(.all)

                // Top info banner
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Police Stations")
                                .font(.headline)
                                .fontWeight(.bold)
                            Text("Apple Valley, MN 55124 (5 mile radius)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        Text("\(policeStations.count)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 4)
                    .padding()

                    Spacer()
                }

                // Bottom station details sheet
                if let station = selectedStation {
                    VStack {
                        Spacer()

                        StationDetailView(station: station) {
                            selectedStation = nil
                        }
                        .transition(.move(edge: .bottom))
                    }
                }
            }
            .navigationTitle("Nearby Police Stations")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Logout") {
                        viewModel.logout()
                    }
                    .foregroundColor(.red)
                }
            }
            .onAppear {
                loadPoliceStations()
            }
        }
    }

    private func loadPoliceStations() {
        policeStations = LocationService.stationsWithinRadius(
            center: LocationService.appleValleyCenter,
            radiusMiles: 5.0
        )
    }
}

struct StationDetailView: View {
    let station: PoliceStation
    let onClose: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header with close button
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(station.name)
                        .font(.headline)
                        .fontWeight(.bold)

                    let distance = LocationService.distance(
                        from: LocationService.appleValleyCenter,
                        to: station.coordinate
                    )
                    Text(String(format: "%.1f miles away", distance))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
            }

            Divider()

            // Address
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "mappin.circle.fill")
                    .foregroundColor(.blue)
                    .font(.title3)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Address")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(station.address)
                        .font(.subheadline)
                }
            }

            // Phone
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "phone.circle.fill")
                    .foregroundColor(.green)
                    .font(.title3)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Phone")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(station.phone)
                        .font(.subheadline)
                }
            }

            // Action buttons
            HStack(spacing: 12) {
                Button(action: {
                    if let url = URL(string: "tel:\(station.phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression))") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    HStack {
                        Image(systemName: "phone.fill")
                        Text("Call")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }

                Button(action: {
                    let latitude = station.coordinate.latitude
                    let longitude = station.coordinate.longitude
                    if let url = URL(string: "http://maps.apple.com/?daddr=\(latitude),\(longitude)") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    HStack {
                        Image(systemName: "map.fill")
                        Text("Directions")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 8)
        .padding()
    }
}

#Preview {
    PoliceStationMapView(viewModel: LoginViewModel())
}
