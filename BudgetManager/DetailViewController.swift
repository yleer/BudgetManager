//
//  DetailViewController.swift
//  BudgetManager
//
//  Created by Yundong Lee on 2021/11/23.
//

import UIKit
import RealmSwift

class DetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryImageButton: UIButton!
    @IBOutlet weak var paymentImageButton: UIButton!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var contentTextField: UITextField!
    
    @IBOutlet weak var containerView: UIView!
    var task: BudgetModel?
    let localRealm = try! Realm()
    var handler : (() -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.layer.cornerRadius = containerView.frame.width / 7
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        
        if let income = task?.income{
            categoryImageButton.isHidden = true
            paymentImageButton.isHidden = true
            titleLabel.text = "수익"
            let result = numberFormatter.string(for: income)!
            priceTextField.text = result + "원"
        }else{
            titleLabel.text = "지출"
            categoryImageButton.setTitle(task?.category, for: .normal)
            paymentImageButton.setTitle(task?.payment, for: .normal)
            let result = numberFormatter.string(for: task?.spending!)!
            priceTextField.text = result + "원"
            
        }
        dateLabel.text = task?.usedDate
        contentTextField.text = task?.content
    }
    
    
    
    @IBAction func deleteButtonClicked(_ sender: UIButton) {
        let alertVC = UIAlertController(title: "영수증으로 내역을 첨부하시겠습니까?", message: "", preferredStyle: .actionSheet)
        
        let deleteButton = UIAlertAction(title: "삭제하시겠습니까?", style: .destructive, handler: {_ in
            
            let taskToDelete = self.task!
            try! self.localRealm.write {
                self.localRealm.delete(taskToDelete)
            }
            self.handler!()
            self.dismiss(animated: true, completion: nil)
        })
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertVC.addAction(deleteButton)
        alertVC.addAction(cancelButton)
        present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func touchedOutside(_ sender: UIButton) {
        dismiss(animated: true)
    }
    @IBAction func categoryImageButtonClicked(_ sender: UIButton) {
    }
}
