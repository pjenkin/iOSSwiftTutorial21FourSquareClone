//
//  placesVC.swift
//  Parse Foursquare Clone
//
//  Created by Peter Jenkin on 17/04/2019.
//  Copyright © 2019 Peter Jenkin. All rights reserved.
//

import UIKit
import Parse

class placesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // declare the usual array(s) for (looking up) sequences of data to show in a table, in this case places
    var placeNameArray = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromServer()         // remember to call for data!

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(placesVC.getDataFromServer), name: NSNotification.Name(rawValue: "newPlace"), object: nil)
        // notification observer, looking out for a newly saved record & segue from locationVC
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
    
    // mandatory 2 table view delegate functions
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        // cell.textLabel?.text = "checking setup"
        cell.textLabel?.text = placeNameArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 10       // 10 to check at first
        
        return placeNameArray.count         // as many rows as there are places
    }
    
    
    @IBAction func logOutBtnClicked(_ sender: Any) {
        PFUser.logOutInBackground { (error) in
            if error != nil
            {
                let alert = UIAlertController(title:"Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                
                let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                
                alert.addAction(okButton)
                
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                // wipe UserDefaults state memory of log-in
                UserDefaults.standard.removeObject(forKey: "userLoggedIn")
                UserDefaults.standard.synchronize()
                
                // reset entry point
                let signUpController = self.storyboard?.instantiateViewController(withIdentifier: "signUpVC") as! signUpVC
                let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                
                delegate.window?.rootViewController = signUpController
                
                delegate.rememberLogin()
            }
            // pasted in after first alert code written
        }
    }
    
    @IBAction func addBtnClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "fromPlacesToAttributesVC", sender: nil)
    }
    
    
    // bespoke function for downloading data from a server (e.g. a db on Parse server)
    @objc func getDataFromServer()        // NB @objc
    {
        let query = PFQuery(className: "Places")
        query.findObjectsInBackground {(places, error) in       // places actually Parse objects
                if error != nil
                {
                    // 1. declare an alert dialogue, 2. declare an 'ok' button, 3. add button to dialogue, 4. show dialogue
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    
                    let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    
                    alert.addAction(ok)
                    
                    self.present(alert, animated: true, completion: nil)
                }
                else        // if record written ok
                {
                    print("places have been queried from server")      // log
                    
                    self.placeNameArray.removeAll(keepingCapacity: false)
                    
                    for place in places!    // for each place...
                    {
                        self.placeNameArray.append(place.object(forKey: "name") as! String)
                        // ... append entire place to array
                    }
                    self.tableView.reloadData()
                }
        }
    }
    
}
