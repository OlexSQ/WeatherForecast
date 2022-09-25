//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by Mac on 25.09.2022.
//

import Foundation
import CoreLocation

protocol LocationManager {
    var updateLocation: ((String) -> Void)? { get set }
    func getCurrentUserLocation()
}

class LocationManagerImplementation: NSObject, LocationManager, CLLocationManagerDelegate {
    private var manager: CLLocationManager?
    
    var updateLocation: ((String) -> Void)?
    
    func getCurrentUserLocation() {
        manager = CLLocationManager()
        manager?.delegate = self
        manager?.requestAlwaysAuthorization()
        manager?.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let coordinates = "&lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)"
            updateLocation?(coordinates)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("In class LocationManagerImplementation we got \(error.localizedDescription)")
    }
}
