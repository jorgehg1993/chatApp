//
//  conversationViewController.swift
//  ChatApp
//
//  Created by Jorge Hernandez on 6/11/15.
//  Copyright (c) 2015 Jorge Hernandez. All rights reserved.
//

import UIKit
import Parse

var otherName = ""
var otherProfileName = ""

class conversationViewController: UIViewController, UIScrollViewDelegate, UITextViewDelegate {

    @IBOutlet weak var resultsScrollView: UIScrollView!
    @IBOutlet weak var frameMessageView: UIView!
    @IBOutlet weak var lineLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    //@IBOutlet weak var blockBtn: UIBarButtonItem!
    
    var scrollViewOriginalY:CGFloat = 0
    var frameMessageOriginalY:CGFloat = 0
    
    let messageLabel = UILabel(frame: CGRectMake(5, 8, 200, 20))
    
    var messageX:CGFloat = 37.0
    var messageY:CGFloat = 26.0
    var frameX:CGFloat = 32.0
    var frameY:CGFloat = 21.0
    var imgX:CGFloat = 3.0
    var imgY:CGFloat = 3.0
    
    var messageArray = [String]()
    var senderArray = [String]()
    
    var myImg:UIImage? = UIImage()
    var otherImg:UIImage? = UIImage()
    
    var resultsImageFiles = [PFFile]()
    var resultsImageFiles2 = [PFFile]()
    
    var isBlocked = false
    
    var blockBtn = UIBarButtonItem()
    var reportBtn = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let width = view.frame.size.width
        let height = view.frame.size.height
        
        resultsScrollView.frame = CGRectMake(0, 64, width, height-114)
        resultsScrollView.layer.zPosition = 20
        frameMessageView.frame = CGRectMake(0, resultsScrollView.frame.maxY, width, 50)
        lineLabel.frame = CGRectMake(0, 0, width, 1)
        messageTextView.frame = CGRectMake(2, 1, self.frameMessageView.frame.size.width-52, 48)
        sendBtn.center = CGPointMake(frameMessageView.frame.size.width-30, 24)
        
        scrollViewOriginalY = self.resultsScrollView.frame.origin.y
        frameMessageOriginalY = self.frameMessageView.frame.origin.y
        
        self.title = otherProfileName
        
        messageLabel.text = "Type a message"
        messageLabel.backgroundColor = UIColor.clearColor()
        messageLabel.textColor = UIColor.lightGrayColor()
        messageTextView.addSubview(messageLabel)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        let tapScrollViewGesture = UITapGestureRecognizer(target: self, action: "didTapScrollView")
        tapScrollViewGesture.numberOfTapsRequired = 1
        resultsScrollView.addGestureRecognizer(tapScrollViewGesture)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getMessageFromParse", name: "getMessage", object: nil)
        blockBtn.title = ""
        
        blockBtn = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("blockUser"))
        reportBtn = UIBarButtonItem(title: "Report", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("reportUser"))
        
        var buttonArray = NSArray(objects: blockBtn, reportBtn)
        self.navigationItem.rightBarButtonItems = buttonArray as [AnyObject]
    }
    
    func getMessageFromParse(){
        refreshResults()
    }
    
    func didTapScrollView(){
        self.view.endEditing(true)
    }
    
    func textViewDidChange(textView: UITextView) {
        
        if (!messageTextView.hasText()){
            self.messageLabel.hidden = false
        }else{
            self.messageLabel.hidden = true
        }
    }

    func textViewDidEndEditing(textView: UITextView) {
        if(!messageTextView.hasText()){
            self.messageLabel.hidden = false
        }
    }
    
    func keyboardWasShown(notification:NSNotification){
        
        let dict:NSDictionary = notification.userInfo!
        let s:NSValue = dict.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let rect:CGRect = s.CGRectValue()
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: {
            
            self.resultsScrollView.frame.origin.y = self.scrollViewOriginalY - rect.height
            self.frameMessageView.frame.origin.y = self.frameMessageOriginalY - rect.height
            
            var bottomOffset:CGPoint = CGPointMake(0, self.resultsScrollView.contentSize.height - self.resultsScrollView.bounds.size.height)
            self.resultsScrollView.setContentOffset(bottomOffset, animated: false)
            }, completion: {
                (finished:Bool) in
        })
        
    }
    
    func keyboardWillHide(notification:NSNotification){
        let dict:NSDictionary = notification.userInfo!
        let s:NSValue = dict.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let rect:CGRect = s.CGRectValue()
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: {
            
            self.resultsScrollView.frame.origin.y = self.scrollViewOriginalY
            self.frameMessageView.frame.origin.y = self.frameMessageOriginalY
            
            var bottomOffset:CGPoint = CGPointMake(0, self.resultsScrollView.contentSize.height - self.resultsScrollView.bounds.size.height)
            self.resultsScrollView.setContentOffset(bottomOffset, animated: false)
            }, completion: {
                (finished:Bool) in
        })
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        var checkQuery = PFQuery(className: "Block")
        checkQuery.whereKey("user", equalTo: otherName)
        checkQuery.whereKey("blocked", equalTo: username)
        var checkedResults = checkQuery.findObjects()
        
        if(checkedResults!.count > 0){
            self.isBlocked = true
        }else{
            self.isBlocked = false
        }
        
        var blockQuery = PFQuery(className: "Block")
        blockQuery.whereKey("user", equalTo: username)
        blockQuery.whereKey("blocked", equalTo: otherName)
        var blockedResults = blockQuery.findObjects()
        
        if(blockedResults!.count > 0){
            self.blockBtn.title = "Unblock"
        }else{
            self.blockBtn.title = "Block"
        }
        
        var query = PFQuery(className: "_User")
        query.whereKey("username", equalTo: username)
        var objects = query.findObjects()
        
        self.resultsImageFiles.removeAll(keepCapacity: false)
        
        for object in objects!{
            self.resultsImageFiles.append(object["photo"] as! PFFile)
            self.resultsImageFiles[0].getDataInBackgroundWithBlock {
                (imageData:NSData?, error:NSError?) -> Void in
                
                if error == nil{
                    self.myImg = UIImage(data: imageData!)
                    
                    var query2 = PFQuery(className: "_User")
                    query2.whereKey("username", equalTo: otherName)
                    var objects2 = query2.findObjects()
                    
                    self.resultsImageFiles2.removeAll(keepCapacity: false)
                    
                    for object2 in objects2! {
                        self.resultsImageFiles2.append(object2["photo"] as! PFFile)
                        
                        self.resultsImageFiles2[0].getDataInBackgroundWithBlock{
                            (imageData:NSData?, error:NSError?) -> Void in
                            
                            if(error == nil){
                                self.otherImg = UIImage(data: imageData!)
                                self.refreshResults()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func refreshResults() {
        
        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        messageX = 37.0
        messageY = 26.0
        frameX = 32.0
        frameY = 21.0
        imgX = 3
        imgY = 3
        
        messageArray.removeAll(keepCapacity: false)
        senderArray.removeAll(keepCapacity: false)
        
        let innerP1 = NSPredicate(format: "sender = %@ AND other = %@", username, otherName)
        var innerQ1:PFQuery = PFQuery(className: "Messages", predicate: innerP1)
        
        let innerP2 = NSPredicate(format: "sender = %@ AND other = %@", otherName, username)
        var innerQ2:PFQuery = PFQuery(className: "Messages", predicate: innerP2)
        
        var query = PFQuery.orQueryWithSubqueries([innerQ1,innerQ2])
        query.addAscendingOrder("createdAt")
        query.findObjectsInBackgroundWithBlock {
            (objects:[AnyObject]?, error:NSError?) -> Void in
            
            if error == nil {
                
                for object in objects! {
                    
                    self.senderArray.append(object.objectForKey("sender") as! String)
                    self.messageArray.append(object.objectForKey("message") as! String)
                    
                }
                
                for subView in self.resultsScrollView.subviews {
                    subView.removeFromSuperview()
                    
                }
                
                for var i = 0; i <= self.messageArray.count-1; i++ {
                    
                    if self.senderArray[i] == username {
                        
                        var messageLbl:UILabel = UILabel()
                        messageLbl.frame = CGRectMake(0, 0, self.resultsScrollView.frame.size.width-94, CGFloat.max)
                        messageLbl.backgroundColor = UIColor(red: 51/255.0, green: 153/255.0, blue: 255/255.0, alpha: 1.0)
                        messageLbl.lineBreakMode = NSLineBreakMode.ByWordWrapping
                        messageLbl.textAlignment = NSTextAlignment.Left
                        messageLbl.numberOfLines = 0
                        messageLbl.font = UIFont(name: "Helvetica Neuse", size: 17)
                        messageLbl.textColor = UIColor.whiteColor()
                        messageLbl.text = self.messageArray[i]
                        messageLbl.sizeToFit()
                        messageLbl.layer.zPosition = 20
                        messageLbl.frame.origin.x = (self.resultsScrollView.frame.size.width - self.messageX) - messageLbl.frame.size.width
                        messageLbl.frame.origin.y = self.messageY
                        self.resultsScrollView.addSubview(messageLbl)
                        self.messageY += messageLbl.frame.size.height + 30
                        
                        var frameLbl:UILabel = UILabel()
                        frameLbl.frame.size = CGSizeMake(messageLbl.frame.size.width+10, messageLbl.frame.size.height+10)
                        frameLbl.frame.origin.x = (self.resultsScrollView.frame.size.width - self.frameX) - frameLbl.frame.size.width
                        frameLbl.frame.origin.y = self.frameY
                        frameLbl.backgroundColor = UIColor(red: 51/255.0, green: 153/255.0, blue: 255/255.0, alpha: 1.0)
                        frameLbl.layer.masksToBounds = true
                        frameLbl.layer.cornerRadius = 10
                        self.resultsScrollView.addSubview(frameLbl)
                        self.frameY += frameLbl.frame.size.height + 20
                        
                        var img:UIImageView = UIImageView()
                        img.image = self.myImg
                        img.frame.size = CGSizeMake(34, 34)
                        img.frame.origin.x = (self.resultsScrollView.frame.size.width - self.imgX) - img.frame.size.width
                        img.frame.origin.y = self.imgY
                        img.layer.zPosition = 30
                        img.layer.cornerRadius = img.frame.size.width/2
                        img.clipsToBounds = true
                        self.resultsScrollView.addSubview(img)
                        self.imgY += frameLbl.frame.size.height + 20
                        
                        self.resultsScrollView.contentSize = CGSizeMake(theWidth, self.messageY)
                        
                    } else {
                        
                        var messageLbl:UILabel = UILabel()
                        messageLbl.frame = CGRectMake(0, 0, self.resultsScrollView.frame.size.width-94, CGFloat.max)
                        messageLbl.backgroundColor = UIColor.groupTableViewBackgroundColor()
                        messageLbl.lineBreakMode = NSLineBreakMode.ByWordWrapping
                        messageLbl.textAlignment = NSTextAlignment.Left
                        messageLbl.numberOfLines = 0
                        messageLbl.font = UIFont(name: "Helvetica Neuse", size: 17)
                        messageLbl.textColor = UIColor.blackColor()
                        messageLbl.text = self.messageArray[i]
                        messageLbl.sizeToFit()
                        messageLbl.layer.zPosition = 20
                        messageLbl.frame.origin.x = self.messageX
                        messageLbl.frame.origin.y = self.messageY
                        self.resultsScrollView.addSubview(messageLbl)
                        self.messageY += messageLbl.frame.size.height + 30
                        
                        var frameLbl:UILabel = UILabel()
                        frameLbl.frame = CGRectMake(self.frameX, self.frameY, messageLbl.frame.size.width+10, messageLbl.frame.size.height+10)
                        frameLbl.backgroundColor = UIColor.groupTableViewBackgroundColor()
                        frameLbl.layer.masksToBounds = true
                        frameLbl.layer.cornerRadius = 10
                        self.resultsScrollView.addSubview(frameLbl)
                        self.frameY += frameLbl.frame.size.height + 20
                        
                        var img:UIImageView = UIImageView()
                        img.image = self.otherImg
                        img.frame = CGRectMake(self.imgX, self.imgY, 34, 34)
                        img.layer.zPosition = 30
                        img.layer.cornerRadius = img.frame.size.width/2
                        img.clipsToBounds = true
                        self.resultsScrollView.addSubview(img)
                        self.imgY += frameLbl.frame.size.height + 20
                        
                        self.resultsScrollView.contentSize = CGSizeMake(theWidth, self.messageY)
                        
                    }
                    
                    var bottomOffset:CGPoint = CGPointMake(0, self.resultsScrollView.contentSize.height - self.resultsScrollView.bounds.size.height)
                    self.resultsScrollView.setContentOffset(bottomOffset, animated: false)
                    
                }
                
            }
            
        }
        
    }

    
    
    @IBAction func sendMessage(sender: AnyObject) {
        
        if(self.isBlocked == true){
            self.showAlert("Blocked", message: "You have been blocked by \(otherName)")
            return
        }
        
        if (self.blockBtn.title == "Unblock"){
            self.showAlert("User blocked", message: "You have blocked this user, unblock to send message")
            return
        }
        
        if (messageTextView.text == ""){
            println("no text")
        }else{
            var messageDBTable = PFObject(className: "Messages")
            messageDBTable["sender"] = username
            messageDBTable["other"] = otherName
            messageDBTable["message"] = self.messageTextView.text
            messageDBTable.saveInBackgroundWithBlock{
                (success:Bool, error: NSError?) -> Void in
                
                if(success == true){
                    
                    var uQuery:PFQuery = PFUser.query()!
                    uQuery.whereKey("username", equalTo: otherName)
                    
                    var user = PFUser.currentUser()!
                    var originalProfile = user["profileName"] as! String
                    var pushQuery:PFQuery = PFInstallation.query()!
                    pushQuery.whereKey("user", matchesQuery: uQuery)
                    
                    var push:PFPush = PFPush()
                    push.setQuery(pushQuery)
                    push.setMessage("\(originalProfile) sent you a message")
                    push.sendPush(nil)
                    println("push sent")
                    
                    println("message sent")
                    self.messageTextView.text = ""
                    self.messageLabel.hidden = false
                    self.refreshResults()
                }
            }
        }
    }
    
    func blockUser() {
        
        if (blockBtn.title == "Block"){
            var addBlock = PFObject(className: "Block")
            addBlock.setObject(username, forKey: "user")
            addBlock.setObject(otherName, forKey: "blocked")
            addBlock.saveInBackground()
            self.blockBtn.title = "Unblock"
            
            self.showAlert("Success", message: "User blocked")
        }else{
            var query:PFQuery = PFQuery(className: "Block")
            query.whereKey("user", equalTo: username)
            query.whereKey("blocked", equalTo: otherName)
            var objects = query.findObjects()
            
            for object in objects! {
                object.deleteInBackground()
            }
            
            self.blockBtn.title = "Block"
            self.showAlert("Success", message: "User unblocked")
        }
    }
    
    func reportUser(){
        
        var addReport = PFObject(className: "Report")
        addReport.setObject(username, forKey: "user")
        addReport.setObject(otherName, forKey: "reported")
        addReport.saveInBackground()
        self.showAlert("Success", message: "Report sent")
    }
    

    func showAlert(title:String, message:String){
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

}
