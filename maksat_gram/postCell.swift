//
//  postCell.swift
//  maksat_gram
//
//  Created by Maksat Zhazbayev on 3/10/19.
//  Copyright © 2019 Maksat Zhazbayev. All rights reserved.
//

import UIKit

class postCell: UITableViewCell
{
    /////Constants/////
    
    @IBOutlet weak var pictureView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    
   //////////////////////
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
