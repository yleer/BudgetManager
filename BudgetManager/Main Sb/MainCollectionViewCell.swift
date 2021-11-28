//
//  MainCollectionViewCell.swift
//  BudgetManager
//
//  Created by Yundong Lee on 2021/11/18.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    static let identfier = "MainCollectionViewCell"
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var paymentImage: UIImageView!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var remainingHistoryLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
}
