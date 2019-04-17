//
//  ViewController.swift
//  Parse Foursquare Clone
//
//  Created by Peter Jenkin on 17/04/2019.
//  Copyright © 2019 Peter Jenkin. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
/*
         // check write - REM out once done once
        let object = PFObject(className: "SouthparkCharacters")
        object["name"] = "Cartman"
        object["age"] = 8
        object["haircolour"] = "Brown"
        object.saveInBackground{(success, error) in
            if error != nil
            {
                print(error?.localizedDescription)      // log
            }
            else
            {
                print("Object/record has been formed")
            }
        }
*/
/*
        // check write
        let object = PFObject(className: "SouthparkCharacters")
        object["name"] = "Kenny"
        object["age"] = 9
        object["haircolour"] = "Blond"
        object.saveInBackground{(success, error) in
            if error != nil
            {
                print(error?.localizedDescription)      // log
            }
            else
            {
                print("Object/record has been formed")
            }
        }
*/
        // test query
        let query = PFQuery(className: "SouthparkCharacters")
        query.findObjectsInBackground {(character, error) in    // default usage: (objects, error)
            if error != nil
            {
                print(error?.localizedDescription)  // log
            }
            else
            {
                print(character)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

