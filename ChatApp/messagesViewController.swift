//
//  messagesViewController.swift
//  ChatApp
//
//  Created by Jorge Hernandez on 6/15/15.
//  Copyright (c) 2015 Jorge Hernandez. All rights reserved.
//

import UIKit
import Parse

class messagesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var resultsTable: UITableView!
    
    var resultsNameArray = [String]()
    var resultsImageFiles = [PFFile]()
    
    var senderArray = [String]()
    var otherArray = [String]()
    var messageArray = [String]()
    
    var sender2Array = [String]()
    var other2Array = [String]()
    var message2Array = [String]()
    
    var sender3Array = [String]()
    var other3Array = [String]()
    var message3Array = [String]()
    
    var results = 0
    var currResult = 0
    
    // Function that is called when the view finishes loading
    override func viewDidLoad() {
        super.viewDidLoad()

        var width = view.frame.size.width
        var height = view.frame.size.height
        
        resultsTable.frame = CGRectMake(0, 0, width, height-64)
    }
    
    // Function that is called when the view appears in the screen
    override func viewDidAppear(animated: Bool) {
        self.resultsNameArray.removeAll(keepCapacity: false)
        self.resultsImageFiles.removeAll(keepCapacity: false)
        
        self.senderArray.removeAll(keepCapacity: false)
        self.otherArray.removeAll(keepCapacity: false)
        self.messageArray.removeAll(keepCapacity: false)
        
        self.sender2Array.removeAll(keepCapacity: false)
        self.other2Array.removeAll(keepCapacity: false)
        self.message2Array.removeAll(keepCapacity: false)
        
        self.sender3Array.removeAll(keepCapacity: false)
        self.other3Array.removeAll(keepCapacity: false)
        self.message3Array.removeAll(keepCapacity: false)
        
        println("USERNAME = " + username)
        let setPredicate = NSPredicate(format: "sender = %@ OR other = %@", username, username)
        var query:PFQuery = PFQuery(className: "Messages", predicate: setPredicate)
        query.addDescendingOrder("createdAt")
        
        query.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]?, error:NSError?) -> Void in
            
            if error == nil {
                for object in objects!{
                    self.senderArray.append(object.objectForKey("sender") as! String)
                    self.otherArray.append(object.objectForKey("other") as! String)
                    self.messageArray.append(object.objectForKey("message") as! String)
                }
                
                for (var i=0; i <= self.senderArray.count - 1; i++) {
                    if (self.senderArray[i] == username){
                        self.other2Array.append(self.otherArray[i])
                    }else{
                        self.other2Array.append(self.senderArray[i])
                    }
                    
                    self.message2Array.append(self.messageArray[i])
                    self.sender2Array.append(self.senderArray[i])
                }
                
                for (var j = 0; j<=self.other2Array.count - 1 ; j++) {
                    var isFound = false
                    for var k = 0; k <= self.other3Array.count - 1; k++ {
                        
                        if(self.other3Array[k] == self.other2Array[j]){
                            isFound = true
                        }
                    }
                    
                    if isFound == false {
                        self.other3Array.append(self.other2Array[j])
                        self.message3Array.append(self.message2Array[j])
                        self.sender3Array.append(self.sender2Array[j])
                    }
                }
                
                self.results = self.other3Array.count
                self.currResult = 0
                self.fetchResults()
                
            }else {
                
            }
        }
    }

    // Function that gets the messages received
    func fetchResults(){
        
        if(currResult < results){
            var queryF = PFUser.query()
            queryF?.whereKey("username", equalTo: self.other3Array[currResult])
            var objects = queryF?.findObjects()
            
            for object in objects!{
                self.resultsNameArray.append(object.objectForKey("profileName") as! String)
                self.resultsImageFiles.append(object.objectForKey("photo") as! PFFile)
                
                self.currResult = self.currResult + 1
                self.fetchResults()
                
                self.resultsTable.reloadData()
            }
        }
    }
    
    // Function that sets the number of rows avaliable in the table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsNameArray.count
    }
    
    // Function that sets the height of each of the rows in a table view
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    // Function that is called when creating the table view
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:messageCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! messageCell
        
        cell.nameLabel.text = self.resultsNameArray[indexPath.row]
        cell.messageLabel.text = self.message3Array[indexPath.row]
        cell.usernameLabel.text = self.other3Array[indexPath.row]
        
        resultsImageFiles[indexPath.row].getDataInBackgroundWithBlock{
            (imageData: NSData?, error: NSError?) -> Void in
            
            if (error == nil){
                let image = UIImage(data: imageData!)
                cell.profileImageView.image = image
                
            }
        }
        
        return cell
    }

    // Function that is called when a row is selected in a table
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath) as! messageCell
        
        otherName = cell.usernameLabel.text!
        otherProfileName = cell.nameLabel.text!
        self.performSegueWithIdentifier("messages_conversation_segue", sender: self)
    }
    
}
