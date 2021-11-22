//
//  AddExpenseViewController.swift
//  BudgetManager
//
//  Created by Yundong Lee on 2021/11/18.
//

import UIKit
import RealmSwift

class AddExpenseViewController: UIViewController{

    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var contentTextField: UITextField!
    
    var selectedCategotyIndex: Int?
    var dateToAdd: String?
    @IBOutlet weak var expenseSegment: UISegmentedControl!
    @IBOutlet weak var paymentSegment: UISegmentedControl!
    let localRealm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dateToAdd)
    }

    
    @IBAction func categoryButtonClicked(_ sender: UIButton) {
        guard let vc =  self.storyboard?.instantiateViewController(withIdentifier: "CategoryPopUpViewController") as?  CategoryPopUpViewController else { return }
        
        
        vc.buttonActionHandler = {
            self.selectedCategotyIndex = vc.selectedButton
        }
        
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: false, completion: nil)
    }
    
    @IBAction func reciptButtonClicked(_ sender: UIButton) {
        
        let alertVC = UIAlertController(title: "영수증으로 내역을 첨부하시겠습니까?", message: "", preferredStyle: .alert)
        
        let fromGallaryButton = UIAlertAction(title: "갤러리", style: .default, handler: nil)
        let fromCameraButton = UIAlertAction(title: "카메라", style: .default, handler: nil)
        
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertVC.addAction(fromCameraButton)
        alertVC.addAction(fromGallaryButton)
        alertVC.addAction(cancelButton)
        
       present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func closeButtonClicked(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    // MARK: UX 생각좀 해야될듯
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        if let selectIndex = selectedCategotyIndex,
        let catogry = SpendingCategory(rawValue: selectIndex),
        let date = dateToAdd,
        let prcieString = priceTextField.text,
        let price = Int(prcieString),
        let content = contentTextField.text
        {
            var  payment = ""
            if paymentSegment.selectedSegmentIndex == 0 {
                payment = PaymentMethod.cash.rawValue
            }else{
                payment = PaymentMethod.card.rawValue
            }
            
            if expenseSegment.selectedSegmentIndex == 0 {
                let task = BudgetModel(usedDate: date, category: catogry.rawValue, content: content, payment: payment, income: nil, spending: price)
                try! localRealm.write {
                    localRealm.add(task)
                }
            }else{
                let task = BudgetModel(usedDate: date, category: catogry.rawValue, content: content, payment: payment, income: price, spending: nil)
                try! localRealm.write {
                    localRealm.add(task)
                }
            }
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        // MARK: 여기 값으로 segment 컨트롤.
        print(sender.selectedSegmentIndex)
    }
}

enum PaymentMethod : String {
    case card
    case cash
}
