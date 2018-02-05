//
//  ViewController.swift
//  MapLocation
//
//  Created by Roman on 10/23/16.
//  Copyright © 2016 apple. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    //MARK: Properties and Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    var ismap = true
    
    var pin:CustomPointAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true

        
    }

    

    //MARK: - Actions
    
    //MARK: Location actions
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
     
        ismap = true
        
        
        print("locations = \(location!.coordinate.latitude) \(location!.coordinate.longitude)")
        
        let centre = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: centre, span: MKCoordinateSpan(latitudeDelta: 0.0015, longitudeDelta: 0.0015))
        
        self.mapView.setRegion(region, animated: true)
        pin = CustomPointAnnotation()
        pin.coordinate = centre
        pin.title = "User Location"
        
        if ismap {
            
            mapView.mapType = .Standard
            let camera = MKMapCamera()
            camera.centerCoordinate = mapView.centerCoordinate
            camera.pitch = 80.0
            camera.altitude = 100.0
            mapView.setCamera(camera, animated: true)
            pin.imageName = "cube"

            
        } else {
            
            mapView.camera.pitch = 0.0
            mapView.camera.altitude = 1000.0
            mapView.camera.heading = 0.0
            pin.imageName = "square"

            
        }
        
        mapView.addAnnotation(pin)
        
        
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print("Errors: " + error.localizedDescription)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        print("delegate called")
        
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        
        let annotationIdentifier = "AnnotationIdentifier"
        
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            annotationView!.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }
        let cpa = annotation as! CustomPointAnnotation
        annotationView!.image = UIImage(named:cpa.imageName)
        
        return annotationView
    }
    
    @IBAction func overheadMap(sender: UIButton) {
        
        ismap = false
        mapView.removeAnnotations(mapView.annotations)
        self.locationManager.startUpdatingLocation()

    }
    
    
    @IBAction func flyoverMap(sender: UIButton) {
        ismap = true
        mapView.removeAnnotations(mapView.annotations)
        self.locationManager.startUpdatingLocation()
        
    }

}

class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}




