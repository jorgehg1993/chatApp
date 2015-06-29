//
//  messageCell.swift
//  ChatApp
//
//  Created by Jorge Hernandez on 6/15/15.
//  Copyright (c) 2015 Jorge Hernandez. All rights reserved.
//

import UIKit

class messageCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        let width = UIScreen.mainScreen().bounds.width
        
        contentView.frame = CGRectMake(0, 0, width, 100)
        
    }
    
    override func layoutSubviews() {
        profileImageView.frame = CGRectMake(0, 0, 50, 50)
        profileImageView.center = CGPointMake(30, 30)
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
        profileImageView.clipsToBounds = true
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
