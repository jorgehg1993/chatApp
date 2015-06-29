//
//  usersViewController.swift
//  ChatApp
//
//  Created by Jorge Hernandez on 6/11/15.
//  Copyright (c) 2015 Jorge Hernandez. All rights reserved.
//

import UIKit
import Parse

var username = ""

class usersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var resultsTable: UITableView!
    
    var resultsUsernameArray = [String]()
    var resultsProfileNameArray = [String]()
    var resultsImageFiles = [PFFile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let width = view.frame.size.width
        let height = view.frame.size.height
        
        resultsTable.frame = CGRectMake(0, 0, width, height)
        
        let messagesBarBtn = UIBarButtonItem(title: "Messages", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("messagesBtn_click"))
        let groupBarBtn = UIBarButtonItem(title: "Group", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("groupBtn_click"))
        
        var buttonArray = NSArray(objects: messagesBarBtn, groupBarBtn)
        self.navigationItem.rightBarButtonItems = buttonArray as [AnyObject]
        
        username = PFUser.currentUser()!.username!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func messagesBtn_click(){
        println("messages")
        
        self.performSegueWithIdentifier("goToMessagesVC_FromUsers", sender: self)
    }
    
    func groupBtn_click(){
        println("group")
        
        self.performSegueWithIdentifier("goToGroupVC_FromUsersVC", sender: self)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        resultsUsernameArray.removeAll(keepCapacity: false)
        
        resultsProfileNameArray.removeAll(keepCapacity: false)
        
        resultsImageFiles.removeAll(keepCapacity: false)
        
        let predicate = NSPredicate(format: "username != '" + username + "'")
        var query = PFQuery(className: "_User", predicate: predicate)
        
        if let results = query.findObjects(){
            for result in results {
                self.resultsUsernameArray.append(result.username as String!)
                self.resultsProfileNameArray.append(result["profileName"] as! String)
                self.resultsImageFiles.append(result["photo"] as! PFFile)
                self.resultsTable.reloadData()
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.hidesBackButton = true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath) as! ResultsCell
        
        otherName = cell.usernameLabel.text!
        otherProfileName = cell.profileNameLabel.text!
        self.performSegueWithIdentifier("users_conversation_segue", sender: self)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsUsernameArray.count
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:ResultsCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! ResultsCell
        
        cell.usernameLabel.text = self.resultsUsernameArray[indexPath.row]
        cell.profileNameLabel.text = self.resultsProfileNameArray[indexPath.row]
        
        resultsImageFiles[indexPath.row].getDataInBackgroundWithBlock{
            (imageData: NSData?, error: NSError?) -> Void in
            
            if(error == nil){
                let image = UIImage(data: imageData!)
                cell.profileImg.image = image
            }
        }
        
        return cell
    }
    
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOut()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
