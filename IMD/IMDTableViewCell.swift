//
//  IMDTableViewCell.swift
//  IMD
//
//  Created by Loren Larson on 7/12/17.
//  Copyright © 2017 Loren Larson. All rights reserved.
//

import UIKit

class IMDTableViewCell: UITableViewCell {

    @IBOutlet weak var imdFrequency: UILabel!
    @IBOutlet weak var imdFrequency1: UILabel!
    @IBOutlet weak var imdFrequency2: UILabel!
    @IBOutlet weak var btnChan: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
