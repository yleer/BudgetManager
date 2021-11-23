//
//  DetailViewController.swift
//  BudgetManager
//
//  Created by Yundong Lee on 2021/11/23.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryImageButton: UIButton!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var contentTextField: UITextField!
    
    var titleTmp: String?
    var dateTmp: String?
    var contentTmp: String?
    
    var categoryTitleTmp: String?
    var incomeTmp: String?
    var spendingTmp: String?
    
    var task : BudgetModel?
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = titleTmp
        dateLabel.text = dateTmp
        contentTextField.text = contentTmp
        
        if let income = incomeTmp{
            priceTextField.text = income
        }else{
            priceTextField.text = spendingTmp
            categoryImageButton.setTitle(categoryTitleTmp, for: .normal)
        }

    }
    
    @IBAction func deleteButtonClicked(_ sender: UIButton) {
        print("df")
        
    }
    
    @IBAction func touchedOutside(_ sender: UIButton) {
        dismiss(animated: true)
    }
    @IBAction func categoryImageButtonClicked(_ sender: UIButton) {
    }
    
}
