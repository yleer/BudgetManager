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
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    var task: BudgetModel?
    let localRealm = try! Realm()
    var handler : (() -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        priceTextField.delegate = self
        
        deleteButton.setTitle("", for: .normal)
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
        let alertVC = UIAlertController(title: "해당 내역을 삭제하시겠습니까?", message: "삭제하면 되돌릴 수 없습니다", preferredStyle: .alert)
        
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
        try! localRealm.write {
            if var newPrice = priceTextField.text, let newContent = contentTextField.text {
                task?.content = newContent
                
                newPrice = newPrice.replacingOccurrences(of: ",", with: "")
                if newPrice.contains("원"){
                    if let moneyIndex = newPrice.firstIndex(of: "원"){
                        if task?.income == nil{
                            task?.spending = Int(String(newPrice[..<moneyIndex]))!
                        }else{
                            task?.income = Int(String(newPrice[..<moneyIndex]))!
                        }
                    }
                }else{
                    if task?.income == nil{
                        if newPrice != ""{
                            task?.spending = Int(newPrice)!
                        }
                        
                    }else{
                        if newPrice != ""{
                            task?.income = Int(newPrice)!
                        }
                        
                    }
                }
            }
        }
        handler!()
        dismiss(animated: true)
    }
    
    
    // MARK: not implemnted -> later need to make category changanle.
    @IBAction func categoryImageButtonClicked(_ sender: UIButton) {
    }
}

extension DetailViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let currentText = textField.text, let moneyIndex = currentText.firstIndex(of: "원"){
            
            textField.text = Int(String(currentText[..<moneyIndex]))?.formatIntToString()
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let currentText = textField.text{
            
            if currentText != ""{
                textField.text = (Int(currentText)?.formatIntToString())! + "원"
            }
            
        }
    }
    
    // 택스트필드에 숫자만 들어가게 하는거
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
