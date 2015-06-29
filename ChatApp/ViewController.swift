//
//  ViewController.swift
//  ChatApp
//
//  Created by Jorge Hernandez on 6/10/15.
//  Copyright (c) 2015 Jorge Hernandez. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var backgroundImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let width = view.frame.size.width
        let height = view.frame.size.height
        
        welcomeLabel.center = CGPointMake(width/2, 130)
        emailTxt.frame = CGRectMake(16, 200, width-32, 30)
        passwordTxt.frame = CGRectMake(16, 240, width-32, 30)
        loginBtn.center = CGPointMake(width/2, 330)
        signupBtn.center = CGPointMake(width/2, height-30)
        backgroundImg.frame = CGRectMake(0, 0, width, height)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func login(sender: AnyObject) {
        
        if(self.emailTxt.text == ""){
            self.showAlert("Username missing", message: "Please provide a username")
            return
        }
        
        if(self.passwordTxt.text == ""){
            self.showAlert("Password missing", message: "Please provide a password")
            return
        }
        
        PFUser.logInWithUsernameInBackground(emailTxt.text, password: passwordTxt.text) {
            (user: PFUser?, error: NSError?) -> Void in
            
            if(user != nil){
                println("log in")
                
                var installation:PFInstallation = PFInstallation.currentInstallation()
                installation["user"] = PFUser.currentUser()
                installation.saveInBackground()
                
                self.performSegueWithIdentifier("login_users_segue" , sender: self)
            }else{
                self.showAlert("Invalid credentials", message: "Username or password is invalid")
            }
            
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.emailTxt.resignFirstResponder()
        self.passwordTxt.resignFirstResponder()
        
        return true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.hidesBackButton = true
    }
    
    func showAlert(title:String, message:String){
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

