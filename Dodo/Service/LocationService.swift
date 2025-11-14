//
//  LocationService.swift
//  Dodo
//
//  Created by Rishat Zakirov on 30.10.2024.
//

import UIKit
import CoreLocation

protocol ILocationService {
    func fetchCurrentLocation(completion: @escaping (CLLocation) -> Void)
}

class LocationService: NSObject, ILocationService {

    private var locationManager = CLLocationManager()
    var onLocationFetched: ((CLLocation) -> Void)?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    func fetchCurrentLocation(completion: @escaping (CLLocation) -> Void) {
        locationManager.startUpdatingLocation()
        onLocationFetched = completion
    }
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            print("When user did not yet determined")
        case .restricted:
            print("Restricted by parental control")
        case .denied:
            print("When user select option Don't Allow")
        case .authorizedAlways:
            print("When user select option Allow While Using App or Allow O")
        case .authorizedWhenInUse:
            print("When user select option Allow While Using App or Allow O")
        @unknown default:
            print("default")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        guard let location = locations.last else {return}
        
        print("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
        
        locationManager.stopUpdatingLocation()
        
        onLocationFetched?(location)
    }
}
