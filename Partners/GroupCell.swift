//
//  GroupCell.swift
//  Partners
//
//  Created by Maya on 28/06/2022.
//

import UIKit

class GroupCell: UITableViewCell {
    
    static let identifier = "group_cell"
    
    static func nib() -> UINib {
        return UINib(nibName: "GroupCell", bundle: nil)
    }
    
    @IBOutlet weak var cell_LBL_title: UILabel!
    
    public func configure(with title:String){
        cell_LBL_title.text = title
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
