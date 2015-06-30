//
//  signupViewController.swift
//  ChatApp
//
//  Created by Jorge Hernandez on 6/10/15.
//  Copyright (c) 2015 Jorge Hernandez. All rights reserved.
//

import UIKit
import Parse

class signupViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var profileTxt: UITextField!
    @IBOutlet weak var signupBtn: UIButton!
    
    // Function that is called when the view has finished loading
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let width = view.frame.size.width
        let height = view.frame.size.height
        
        profileImg.frame = CGRectMake(0, 0, width/3, width/3)
        profileImg.center = CGPointMake(width/2, self.profileImg.frame.height/2 + 80)
        profileImg.layer.cornerRadius = profileImg.frame.size.width/2
        profileImg.clipsToBounds = true
        
        profileBtn.center = CGPointMake(width/2, self.profileImg.frame.maxY + 40)

        emailTxt.frame = CGRectMake(16, 270, width-32, 30)
        passwordTxt.frame = CGRectMake(16, 310, width-32, 30)
        profileTxt.frame = CGRectMake(16, 350, width-32, 30)
        signupBtn.center = CGPointMake(width/2, 410)
        
    }
    
    // Function that get the image from the device's photo library
    @IBAction func addImage(sender: AnyObject) {
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = true
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    // Function that is called when the user finishes picking an image from the library
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        profileImg.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // Function that closes all open keyboards
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        emailTxt.resignFirstResponder()
        passwordTxt.resignFirstResponder()
        profileTxt.resignFirstResponder()
        
        return true
    }
    
    // Function that is called when the view is touched
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    // Function that is called when a text field starts being edited
    func textFieldDidBeginEditing(textField: UITextField) {
        let width = view.frame.size.width
        let height = view.frame.size.height
        
        if(UIScreen.mainScreen().bounds.height == 568){
            if(textField == self.profileTxt){
                UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear,
                    animations: {
                        self.view.center = CGPointMake(width/2, height/2 - 40)
                    },
                    completion: {
                        (finished:Bool) in
                    }
                )
            }
        }
    }
    
    // Function is called when a text field has finished to be edited
    func textFieldDidEndEditing(textField: UITextField) {
        let width = view.frame.size.width
        let height = view.frame.size.height
        
        if(UIScreen.mainScreen().bounds.height == 568){
            if(textField == self.profileTxt){
                UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear,
                    animations: {
                        self.view.center = CGPointMake(width/2, height/2)
                    },
                    completion: {
                        (finished:Bool) in
                    }
                )
            }
        }
    }
    
    // Function that registers a new user in Parse
    @IBAction func signUpUser(sender: AnyObject) {
        var user = PFUser()
        user.username = emailTxt.text
        user.password = passwordTxt.text
        user.email = emailTxt.text
        user["profileName"] = profileTxt.text
        
        let imageData = UIImagePNGRepresentation(self.profileImg.image)
        let imageFile = PFFile(name: "profilePhoto.png", data: imageData)
        
        user["photo"] = imageFile
        
        user.signUpInBackgroundWithBlock{
            (success: Bool, error  : NSError?) -> Void in
            
            if (success){
                println("signup")
                
                var installation:PFInstallation = PFInstallation.currentInstallation()
                installation["user"] = PFUser.currentUser()
                installation.saveInBackground()
                
                self.performSegueWithIdentifier("signup_users_segue", sender: self)
            }else{
                self.showAlert("Sign up failed", message: "Try again later")
            }
        }
    }
    
    // Function that shows an alert to the user
    func showAlert(title:String, message:String){
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

}
