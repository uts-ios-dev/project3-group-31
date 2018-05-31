//
//  MapViewController.swift
//  HealthPlus
//
//  Created by Tabassum Muntarim on 29/5/18.
//  Copyright © 2018 Alex Tsimboukis. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class MapViewController : UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let sourceLocation = CLLocationCoordinate2D(latitude: -33.865143, longitude: 151.209900)//Sydney, NSW Geographic location
        let destinationLocation = CLLocationCoordinate2D(latitude: -33.865200, longitude: 151.209999)
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "Start"
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "Finish"
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }

        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )

        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
    }
    //Override the Update location function, so that I can act whenever iOS updates the map with my new location
    func locationManager(_ _manager : CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        //Set to the whole area of the map shows 500 by 500
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
        mapView.setRegion(coordinateRegion, animated: true)
        //Set my current location using a 2d point so I can being drawing with it.
        let currLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        locationManager.stopUpdatingLocation()
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    

}
