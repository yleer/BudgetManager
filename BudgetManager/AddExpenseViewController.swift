//
//  AddExpenseViewController.swift
//  BudgetManager
//
//  Created by Yundong Lee on 2021/11/18.
//

import UIKit
import RealmSwift

class AddExpenseViewController: UIViewController{

    
    var selectedCategotyIndex: Int?
    var dateToAdd: String?
    @IBOutlet weak var expenseSegment: UISegmentedControl!
    @IBOutlet weak var paymentSegment: UISegmentedControl!
//    let localRealm = try! Realm()
    
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
    
    @IBAction func saveButtonClicked(_ sender: UIButton) {
//        let task = BudgetModel(usedDate: <#T##Date#>, category: <#T##String#>, content: <#T##String#>, payment: <#T##String#>, income: <#T##Int?#>, spending: <#T##Int?#>)
//        try! localRealm.write {
//            localRealm.add(task)
//        }
        
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        // MARK: 여기 값으로 segment 컨트롤.
        print(sender.selectedSegmentIndex)
    }
    
    
    
}
