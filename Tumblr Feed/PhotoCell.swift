//
//  PhotoCell.swift
//  Tumblr Feed
//
//  Created by Pratyush Thapa on 2/1/17.
//  Copyright © 2017 Pratyush Thapa. All rights reserved.
//
import UIKit

class PhotoCell: UITableViewCell {
    
     @IBOutlet weak var photoView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
