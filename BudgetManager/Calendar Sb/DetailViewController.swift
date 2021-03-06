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
    
    @IBOutlet weak var showImageButton: UIButton!
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
        
        
        if let income = task?.income{
            categoryImageButton.isHidden = true
            paymentImageButton.isHidden = true
            titleLabel.text = "수익"
            priceTextField.text = income.formatIntToString() + "원"
        }else{
            titleLabel.text = "지출"
            categoryImageButton.setTitle(task?.category, for: .normal)
            paymentImageButton.setTitle(task?.payment, for: .normal)
            priceTextField.text = task!.spending!.formatIntToString() + "원"
            
        }
        dateLabel.text = task?.usedDate
        contentTextField.text = task?.content
        
        let imageName = "\(task!.uuid).jpg"
        
        if let directory = getDoucmentDirectory() {
            let imageUrl = URL(fileURLWithPath: directory).appendingPathComponent(imageName)
            if FileManager.default.fileExists(atPath: imageUrl.path) {
                
                showImageButton.isHidden = false
            }else {
                showImageButton.isHidden = true
                
            }
            
        }
    }
    
    @IBAction func closeButtonClicked(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func seePictureButtonClicked(_ sender: UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailImageViewController") as? DetailImageViewController  else { return }
        
        vc.content = contentTextField.text
        vc.price = priceTextField.text
        vc.tittle = titleLabel.text
        
        let imageName = "\(task!.uuid).jpg"

        if let image = loadImageFromDocumentDirectory(imageName: imageName) {
            vc.image = image
        }
        
//        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    private func getDoucmentDirectory() -> String? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let path = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let dirctoryPath = path.first{
            return dirctoryPath
        }
        return nil
    }
    
    private func loadImageFromDocumentDirectory(imageName: String) -> UIImage? {
        
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let path = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let dirctoryPath = path.first{
            let imageUrl = URL(fileURLWithPath: dirctoryPath).appendingPathComponent(imageName)
            if FileManager.default.fileExists(atPath: imageUrl.path) {
                print("good")
                return UIImage(contentsOfFile: imageUrl.path)
            }else {
                print("bad")
                return nil
            }
        }
        
        return nil
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
