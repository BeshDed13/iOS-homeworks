//
//  MapService.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 01.03.2026.
//

import Foundation
import MapKit
import CoreLocation

protocol MapServiceProtocol: AnyObject {
    
    var currentLocation: CLLocation? { get }
    
    func requestLocation()
    func buildRoute(
        from source: CLLocationCoordinate2D,
        to destination: CLLocationCoordinate2D,
        completion: @escaping (MKRoute?) -> Void
    )
}

final class MapService: NSObject {
    
    private let locationManager = CLLocationManager()
    private(set) var currentLocation: CLLocation?
    
}

extension MapService: MapServiceProtocol {
    
    func requestLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func buildRoute(
        from source: CLLocationCoordinate2D,
        to destination: CLLocationCoordinate2D,
        completion: @escaping (MKRoute?) -> Void
    ) {
        let sourcePlacemark = MKPlacemark(coordinate: source)
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: sourcePlacemark)
        request.destination = MKMapItem(placemark: destinationPlacemark)
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            completion(response?.routes.first)
        }
    }
}

extension MapService: CLLocationManagerDelegate {
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        currentLocation = locations.last
    }
}
