//
//  HistoryDetailTableViewCell.swift
//  assignment3
//
//  Created by mobiledev on 20/5/2022.
//

import UIKit

class HistoryDetailTableViewCell: UITableViewCell {

    @IBOutlet var labelAction: UILabel!
    @IBOutlet var labelActionCorrect: UILabel!
    @IBOutlet var labelActionTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
