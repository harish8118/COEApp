//
//  dashCell.swift
//  COEApp
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 24/07/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit

class dashCell: UITableViewCell {

    @IBOutlet weak var txtLbl: UILabel!
    @IBOutlet weak var menuImg: UIImageView!
    @IBOutlet weak var percLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
