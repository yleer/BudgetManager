//
//  DetailImageViewController.swift
//  BudgetManager
//
//  Created by Yundong Lee on 2021/12/07.
//

import UIKit

class DetailImageViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!

    
    var tittle: String?
    var price: String?
    var image: UIImage?
    var content: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = tittle!
        priceLabel.text = price!
        contentLabel.text = content!
        if let image = image {
            imageView.image = image
        }

     
    }
    

}
