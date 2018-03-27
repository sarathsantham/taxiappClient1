//
//  RideHistoryViewCellTableViewCell.swift
//  EQTaxi
//
//  Created by Equator Technologies on 01/03/18.
//  Copyright © 2018 Equator Technologies. All rights reserved.
//

import UIKit

class RideHistoryViewCellTableViewCell: UITableViewCell {
    @IBOutlet var lbl_ridefare: UILabel!
    @IBOutlet var lbl_drop: UILabel!
    @IBOutlet var lbl_pickup: UILabel!
    @IBOutlet var lbl_time: UILabel!
    @IBOutlet var ibi_date: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
