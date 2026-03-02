//
//  MapViewController.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 01.03.2026.
//

import UIKit
import MapKit

final class MapViewController: UIViewController {
    
    private let mapView = MKMapView()
    private let mapService: MapServiceProtocol
    private var userAnnotations: [MKPointAnnotation] = []
    
    init(mapService: MapServiceProtocol) {
        self.mapService = mapService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupMap()
        mapService.requestLocation()
    }
    
    func setupUI() {
        view.addSubview(mapView)
        mapView.frame = view.bounds
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearAnnotations))
    }
    
    func setupMap() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.mapType = .hybrid
        mapView.isRotateEnabled = true
        mapView.isZoomEnabled = true
        mapView.isPitchEnabled = true
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.showsTraffic = true
        
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handleMapTap(_:))
        )
        mapView.addGestureRecognizer(tapGesture)
    }
    
    private func buildRoute(to destination: CLLocationCoordinate2D) {
        guard let userLocation = mapService.currentLocation else { return }
        
        mapService.buildRoute(
            from: userLocation.coordinate,
            to: destination,
        ) { [weak self] route in
            
            guard let self, let route else { return }
            
            self.mapView.removeOverlays(self.mapView.overlays)
            self.mapView.addOverlay(route.polyline)
            
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            
        }
    }
    
    @objc private func handleMapTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Destination"
        userAnnotations.append(annotation)
        mapView.addAnnotation(annotation)
        buildRoute(to: coordinate)
    }
    
    @objc private func clearAnnotations() {
        mapView.removeAnnotations(userAnnotations)
        mapView.removeOverlays(mapView.overlays)
        userAnnotations.removeAll()
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(
        _ mapView: MKMapView,
        rendererFor overlay: MKOverlay
    ) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .systemGray
        renderer.lineWidth = 5
        return renderer
    }
}
