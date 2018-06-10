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
        
        @IBOutlet weak var theMap: MKMapView!
        @IBOutlet weak var theLabel: UILabel!
        
        var manager:CLLocationManager!
        var myLocations: [CLLocation] = []
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            //Setup our Location Manager
            manager = CLLocationManager()
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestAlwaysAuthorization()
            manager.startUpdatingLocation()
            
            //Setup our Map View
            theMap.delegate = self
            theMap.mapType = MKMapType.satellite
            theMap.showsUserLocation = true
        }
        
        func locationManager(manager:CLLocationManager, didUpdateLocations locations:[AnyObject]) {
            theLabel.text = "\(locations[0])"
            myLocations.append(locations[0] as! CLLocation)
            
            let spanX = 0.007
            let spanY = 0.007
            var newRegion = MKCoordinateRegion(center: theMap.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
            theMap.setRegion(newRegion, animated: true)
            
            if (myLocations.count > 1){
                var sourceIndex = myLocations.count - 1
                var destinationIndex = myLocations.count - 2
                
                let c1 = myLocations[sourceIndex].coordinate
                let c2 = myLocations[destinationIndex].coordinate
                var a = [c1, c2]
                var polyline = MKPolyline(coordinates: &a, count: a.count)
                theMap.add(polyline)
            }
        }
        
        func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
            
            if overlay is MKPolyline {
                var polylineRenderer = MKPolylineRenderer(overlay: overlay)
                polylineRenderer.strokeColor = UIColor.blue
                polylineRenderer.lineWidth = 4
                return polylineRenderer
            }
            return nil
        }
}
