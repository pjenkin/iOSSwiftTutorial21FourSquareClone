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
    
    // arrays for holding all place details
    var nameArray = [String]()
    var typeArray = [String]()
    var atmosphereArray = [String]()
    var imageArray = [PFFileObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
        
        mapView.delegate = self
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest   // NB battery drain - also km, 100m, 10m, 3km, ....
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()                     // immediately start locating
        
        print(chosenPlace)
        
        // get details of selected place, from server db
        findPlaceFromServer()

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
    
    func findPlaceFromServer()
    {
        let query = PFQuery(className: "Places")
        query.whereKey("name", equalTo: self.chosenPlace)
        print("ChosenPlace\(self.chosenPlace)")
        query.findObjectsInBackground{(objects, error) in
            if error != nil
            {
                // 1. declare an alert dialogue, 2. declare an 'ok' button, 3. add button to dialogue, 4. show dialogue
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                
                alert.addAction(ok)
                
                self.present(alert, animated: true, completion: nil)
            }
            else        // if query went ok, loop through
            {
                // first, clear out
                self.nameArray.removeAll(keepingCapacity: false)
                self.typeArray.removeAll(keepingCapacity: false)
                self.atmosphereArray.removeAll(keepingCapacity: false)
                self.imageArray.removeAll(keepingCapacity: false)
                
                // loop through, calling them objects this time not places, for no particular reason
                for object in objects!
                {
                    print("")
                    self.nameArray.append(object.object(forKey: "name") as! String)
                    self.typeArray.append(object.object(forKey: "type") as! String)
                    self.atmosphereArray.append(object.object(forKey: "atmosphere") as! String)
                    self.imageArray.append(object.object(forKey: "image") as! PFFileObject)
                    // populate each field array with this record's values
                    
                    self.nameText.text = "Name: \(String(describing:self.nameArray.last!))"
                    self.typeText.text = "Name: \(String(describing:self.typeArray.last!))"
                    self.atmosphereText.text = "Name: \(String(describing:self.atmosphereArray.last!))"
                    // self.placeName.text = "Name: \(self.nameArray.last)"
                
            }
        }

            
        }
    }

}
