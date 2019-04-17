//
//  placesVC.swift
//  Parse Foursquare Clone
//
//  Created by Peter Jenkin on 17/04/2019.
//  Copyright © 2019 Peter Jenkin. All rights reserved.
//

import UIKit
import Parse

class placesVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    }
    
    
}
