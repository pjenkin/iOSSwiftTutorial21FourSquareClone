//
//  detailsVC.swift
//  Parse Foursquare Clone
//
//  Created by Peter Jenkin on 17/04/2019.
//  Copyright © 2019 Peter Jenkin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Parse

class detailsVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    // NB both image and map in this view, so some code copied from locationVC
    
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var typeText: UILabel!
    @IBOutlet weak var atmosphereText: UILabel!
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    
    var manager = CLLocationManager()
    var chosenPlace = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
        
        mapView.delegate = self
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest   // NB battery drain - also km, 100m, 10m, 3km, ....
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()                     // immediately start locating
        
        print(chosenPlace)

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
