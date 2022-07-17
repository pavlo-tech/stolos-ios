//
//  MapViewModel.swift
//  stolos
//
//  Created by Pavlo Triantafyllides on 6/25/22.
//

import MapKit

enum MapDetails {
    static let startingLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(
        latitude: 35.8620,
        longitude: 23.3049
    )
    static let defaultSpan: MKCoordinateSpan = MKCoordinateSpan(
        latitudeDelta: 0.05,
        longitudeDelta: 0.05
    )
}


final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion(
        center: MapDetails.startingLocation,
        span: MapDetails.defaultSpan
    )
    
    var locationManager: CLLocationManager?
    
    func checkIfLocationServicesEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            let newMgr = CLLocationManager()
            newMgr.delegate = self
            locationManager = newMgr
        } else {
            print("Tell user to enable location services")
        }
    }
    
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Your location is restricted")
        case .denied:
            print("Your location is denied. Please enable location in settings")
        case .authorizedAlways, .authorizedWhenInUse:
            guard let coordinate = locationManager.location?.coordinate else {
                print("couldn't get location from locationManager")
                return
            }
            
            region = MKCoordinateRegion(
                center: coordinate,
                span: MapDetails.defaultSpan
            )
        @unknown default:
            break
        }
    }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }

}
