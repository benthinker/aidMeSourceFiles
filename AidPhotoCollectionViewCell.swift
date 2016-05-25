//
//  AidPhotoCollectionViewCell.swift
//  AidMe
//
//  Created by Ben Siso on 12/03/2016.
//  Copyright © 2016 Ben Siso. All rights reserved.
//

import UIKit

class AidPhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView! { didSet {
        image.frame.size = self.frame.size
       // Cell properties :
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.layer.cornerRadius = 4.0
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = true
        }}
    
    
    
}
