//
//  ExpenseTableViewCell.swift
//  BudgetManager
//
//  Created by Yundong Lee on 2021/11/20.
//

import UIKit

class ExpenseTableViewCell: UITableViewCell {

    @IBOutlet weak var paymentLabel: UIImageView!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    static let identifier = "ExpenseTableViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
