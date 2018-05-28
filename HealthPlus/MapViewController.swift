//
//  MapViewController.swift
//  HealthPlus
//
//  Created by Tabassum Muntarim on 28/5/18.
//  Copyright © 2018 Jack Huggart. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class MapViewController : UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsPointsOfInterest = true
        mapView.showsUserLocation = true
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
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
