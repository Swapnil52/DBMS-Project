//
//  menuItemCell.swift
//  McDonald's Online
//
//  Created by Swapnil Dhanwal on 04/04/2017.
//  Copyright © 2017 Swapnil Dhanwal. All rights reserved.
//

import UIKit

class menuItemCell: UITableViewCell {

    @IBOutlet weak var paddingView: UIView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    @IBOutlet weak var plusOutlet: UIButton!
    
    @IBOutlet weak var minusOutlet: UIButton!
    
    @IBAction func plus(_ sender: Any) {
        
        quantity.text = String(Int(quantity.text!)! + 1)
        
    }
    @IBAction func minus(_ sender: Any) {
        
        
        if (quantity.text != "0")
        {
            
            quantity.text = String(Int(quantity.text!)! - 1)
            
        }
        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
