//
//  CategoryPopUpViewController.swift
//  BudgetManager
//
//  Created by Yundong Lee on 2021/11/19.
//

import UIKit
import SwiftUI

class CategoryPopUpViewController: UIViewController {

    @IBOutlet var buttons: [UIButton]!
    
    var buttonActionHandler: (() -> ())?
    var selectedButton: Int?
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dismissButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissButton.setTitle("", for: .normal)
        containerView.layer.cornerRadius = containerView.frame.width / 5
    }

    @IBAction func buttonClicked(_ sender: UIButton) {
        selectedButton = buttons.firstIndex(of: sender)
        buttonActionHandler?()
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func touchOutside(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
}


enum SpendingCategory : Int {
    case food
    case education
    case grocery
    case cloth
    case medicine
    case transportation
    case leisure
    case lifeStyle
    case trip
    case etc    
}
