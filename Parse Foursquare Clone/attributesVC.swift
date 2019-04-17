//
//  attributesVC.swift
//  Parse Foursquare Clone
//
//  Created by Peter Jenkin on 17/04/2019.
//  Copyright © 2019 Peter Jenkin. All rights reserved.
//

import UIKit
import Parse

// global variables - accessible from any view controller (alternative to relying on prepareForSegue for passing data between several view controllers e.g. in annotations within location view)
var globalName = ""
var globalType = ""
var globalAtmosphere = ""
var globalImage = UIImage()

class attributesVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var typeText: UITextField!
    @IBOutlet weak var atmosphereText: UITextField!
    @IBOutlet weak var placeImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        placeImage.isUserInteractionEnabled = true      // allow clicks/taps to work on image
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(attributesVC.selectImage))       // use handler (see below)
        placeImage.addGestureRecognizer(gestureRecognizer)
    }

 

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        // clear-up, to be ready
        globalName = ""
        globalType = ""
        globalAtmosphere = ""
        globalImage = UIImage()
    }
    
    @IBAction func nextBtnClicked(_ sender: Any) {
        
        if nameText.text != "" && typeText.text != "" && atmosphereText.text != ""
        {
            if let selectedImage = placeImage.image     // ... and if an image has lately been picked
            {
                globalName = nameText.text!
                globalType = typeText.text!
                globalAtmosphere = atmosphereText.text!
                globalImage = selectedImage
            }
        }
        
        self.performSegue(withIdentifier: "fromAttributesToLocationVC", sender: nil)
        
        // clear all of the
        nameText.text = ""
        typeText.text = ""
        atmosphereText.text = ""
        self.placeImage.image = UIImage(named: "tapme.png")
    }
    
    @objc func selectImage()
    {
        // selecting image from library
        let picker = UIImagePickerController()
        picker.delegate = self  // required ViewController to subclass UIImagePickerControllerDelegate, UINavigationControllerDelegate
        picker.sourceType = .photoLibrary
        // source could have been from camera; library for demonstration
        picker.allowsEditing = true
        //present(<#T##viewControllerToPresent: UIViewController##UIViewController#>, animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
        present(picker, animated: true, completion: nil)
        // show ImagePicker, animated, no handler function on completion
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?   // workaround to get original image https://stackoverflow.com/a/53219069
        
        // postImage.image = info[UIImagePickerControllerEditedImage] as? UIImage // didn't work as original image slipped through unused - no edited image to use
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage
        {   // NB Any type from dictionary - try to cast to UIImage
            selectedImageFromPicker = editedImage
        }
        else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            selectedImageFromPicker = originalImage
        }
        
        // cautious approach here!
        if let selectedImage = selectedImageFromPicker
        {
            placeImage.image = selectedImage
        }
        
        self.dismiss(animated: true, completion: nil)

    }
    
}
