//
//  ViewController.swift
//  Parse Foursquare Clone
//
//  Created by Peter Jenkin on 17/04/2019.
//  Copyright © 2019 Peter Jenkin. All rights reserved.
//

import UIKit
import Parse

class signUpVC: UIViewController {

    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
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
/*
        // check query
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
 */

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signInBtnClicked(_ sender: Any) {
        
        if usernameText.text != "" && passwordText.text != ""
        {
            PFUser.logInWithUsername(inBackground: usernameText.text!, password: passwordText.text!)
                {(user, error)
                    in
                    if error != nil
                    {
                        let alert = UIAlertController(title:"Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                        
                        let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                        
                        alert.addAction(okButton)
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                    else
                    {
                        UserDefaults.standard.set(self.usernameText.text!, forKey: "userLoggedIn")
                        UserDefaults.standard.synchronize()
                        
                        print("\(user?.username) signed-in")       // log
                        // self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                        // cf rememberLogin in AppDelegate - check if user already logged-in
                        let delegate :AppDelegate = UIApplication.shared.delegate as! AppDelegate
                        
                        delegate.rememberLogin()
                    }

            }
        }
    }
    
    @IBAction func signUpBtnClicked(_ sender: Any) {
        
        // validate login details given
        if usernameText.text != "" && passwordText.text != ""
        {
            let user = PFUser()
            user.username = usernameText.text
            user.password = passwordText.text    // username and password mandatory - other fields could be user["somefield"] = x
            
            user.signUpInBackground(block: {(success, error) in
                if error != nil
                {
                    let alert = UIAlertController(title:"Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    
                    let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    
                    alert.addAction(okButton)
                    
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    UserDefaults.standard.set(self.usernameText.text!, forKey: "userLoggedIn")
                    UserDefaults.standard.synchronize()
                    
                    print("User record written")        // log
                    // self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                    // cf rememberLogin in AppDelegate - check if user already logged-in
                    let delegate :AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    
                    delegate.rememberLogin()
                }
            })
        }
        
    }
}

