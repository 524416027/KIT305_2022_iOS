//
//  HistoryTableViewCell.swift
//  assignment3
//
//  Created by mobiledev on 20/5/2022.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet var labelMode: UILabel!
    @IBOutlet var labelRepeatTime: UILabel!
    @IBOutlet var labelStartTime: UILabel!
    @IBOutlet var labelEndTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
