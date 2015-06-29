//
//  ResultsCell.swift
//  ChatApp
//
//  Created by Jorge Hernandez on 6/11/15.
//  Copyright (c) 2015 Jorge Hernandez. All rights reserved.
//

import UIKit

class ResultsCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let width = UIScreen.mainScreen().bounds.width
        
        contentView.frame = CGRectMake(0, 0, width, 100)
        
        profileNameLabel.center = CGPointMake(200, 55)
    }

    override func layoutSubviews() {
        profileImg.frame = CGRectMake(0, 0, 80, 80)
        profileImg.center = CGPointMake(60, 60)
        profileImg.layer.cornerRadius = profileImg.frame.size.width/2
        profileImg.clipsToBounds = true
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
