//
//  ExpenceCell.swift
//  Partners
//
//  Created by Maya on 29/06/2022.
//

import UIKit

class ExpenceCell: UITableViewCell {
    
    static let identifier = "expence_cell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ExpenceCell", bundle: nil)
    }
    
    
    @IBOutlet weak var cell_LBL_title: UILabel!
    @IBOutlet weak var cell_LBL_paidby: UILabel!
    @IBOutlet weak var cell_LBL_date: UILabel!
    @IBOutlet weak var cell_LBL_expence: UILabel!
    
    func configure(with title:String, paidby:String, date:String, expence:String){
        cell_LBL_title.text = title
        cell_LBL_paidby.text = paidby
        cell_LBL_date.text = date
        cell_LBL_expence.text = expence
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
