//
//  groupViewController.swift
//  ChatApp
//
//  Created by Jorge Hernandez on 6/15/15.
//  Copyright (c) 2015 Jorge Hernandez. All rights reserved.
//

import UIKit
import Parse

class groupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var resultsTable: UITableView!
    
    var resultsNameArray = Set([""])
    var resultsNameArray2 = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var width = view.frame.size.width
        var height = view.frame.size.height
        
        resultsTable.frame = CGRectMake(0, 0, width, height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        groupConversationTitle = ""
        
        self.resultsNameArray.removeAll(keepCapacity: false)
        self.resultsNameArray2.removeAll(keepCapacity: false)
        
        var query = PFQuery(className: "GroupMessages")
        query.addAscendingOrder("group")
        query.findObjectsInBackgroundWithBlock{
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if(error == nil){
                for object in objects!{
                    self.resultsNameArray.insert(object.objectForKey("group") as! String)
                    self.resultsNameArray2 = Array(self.resultsNameArray)
                    
                    self.resultsTable.reloadData()
                    
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsNameArray2.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:groupCell = tableView.dequeueReusableCellWithIdentifier("groupCell") as! groupCell
        
        cell.groupNameLabel.text = resultsNameArray2[indexPath.row]
        
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath) as! groupCell
        
        groupConversationTitle = resultsNameArray2[indexPath.row]
        
        self.performSegueWithIdentifier("goToGroupConversation_FromGroupVC", sender: self)
    }
    
    @IBAction func addGroup(sender: AnyObject) {
        
        var alert = UIAlertController(title: "New Group", message: "Type the name of the group", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler {
            (textField) -> Void in
            
        }
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
            
            println("ok pressed")
            let textF = alert.textFields![0] as! UITextField
            println(textF.text)
            
            var groupMesssageObj = PFObject(className: "GroupMessages")
            
            let theUser:String = PFUser.currentUser()!.username!
            
            groupMesssageObj["sender"] = theUser
            groupMesssageObj["message"] = "\(theUser) created a new Group"
            groupMesssageObj["group"] = textF.text
            
            groupMesssageObj.save()
            println("group created")
            
            groupConversationTitle = textF.text
            self.performSegueWithIdentifier("goToGroupConversation_FromGroupVC", sender: self)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in
            println("cancel pressed")
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
