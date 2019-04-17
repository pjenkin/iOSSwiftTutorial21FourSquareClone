//
//  locationVC.swift
//  Parse Foursquare Clone
//
//  Created by Peter Jenkin on 17/04/2019.
//  Copyright © 2019 Peter Jenkin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class locationVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!

    var manager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
/*
        // checking
        let latitude : CLLocationDegrees = 50
        let longitude : CLLocationDegrees = -4
        
        let location : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let span : MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        
        let region : MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(region, animated: true)
 */
        mapView.delegate = self
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest   // NB battery drain - also km, 100m, 10m, 3km, ....
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()                     // immediately start locating

        // set map up to recognize long-presses to make annotation of location
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(locationVC.pressGesture(gestureRecognizer: )))
        recognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(recognizer)
        
    }

    @objc func pressGesture(gestureRecognizer: UIGestureRecognizer)     // NB @objc
    {
        if gestureRecognizer.state == UIGestureRecognizerState.began
        {
            let touches = gestureRecognizer.location(in: self.mapView)
            //let coordinates = self.mapView.convert(<#T##point: CGPoint##CGPoint#>, toCoordinateFrom: <#T##UIView?#>)
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates     // use user touches on map
            annotation.title = "annotation title here"
            annotation.subtitle = "type of the place"
            
            self.mapView.addAnnotation(annotation)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func saveBtnClicked(_ sender: Any) {
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)     // use *location* parameter when updated
        
        manager.stopUpdatingLocation()             // location obtained - map can now pan freely
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)      // 'zoom' 0.05 pretty average
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    
    // NB relatively recent way of adding notations to map - else no subtitles - from StackOverflow somewhere
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // if the annotation concerned is coming from a phone's location, don't annotate in this way (useful in directions-to/from situation)
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "myAnnotation"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        // reuse just the 1 annotation view (good for memory resources)
        
        if pinView == nil
        {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.pinTintColor = UIColor.red
            
            
            let button = UIButton(type: .detailDisclosure)      // .detailDisclosure == UIButton.detailDisclosure
            pinView?.rightCalloutAccessoryView = button
        }
        else    // if pinView already existent (already defined, and reused)
        {
            pinView?.annotation = annotation
        }
        return pinView
    }

    
}
