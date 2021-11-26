//
//  AddExpenseViewController.swift
//  BudgetManager
//
//  Created by Yundong Lee on 2021/11/18.
//

import UIKit
import PhotosUI
import RealmSwift

class AddExpenseViewController: UIViewController{

    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var contentTextField: UITextField!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var expenseSegment: UISegmentedControl!
    @IBOutlet weak var paymentSegment: UISegmentedControl!
    
    var selectedCategotyIndex: Int?
    var dateToAdd: String?
    
    let localRealm = try! Realm()
    
    var handler: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    let category = ["식료", "교육", "장보기", "의류", "의료", "교통", "레져", "여가", "여행", "기타" ]
    @IBAction func categoryButtonClicked(_ sender: UIButton) {
        guard let vc =  self.storyboard?.instantiateViewController(withIdentifier: "CategoryPopUpViewController") as?  CategoryPopUpViewController else { return }
    
        vc.buttonActionHandler = {
            self.selectedCategotyIndex = vc.selectedButton
            self.categoryButton.setTitle(self.category[self.selectedCategotyIndex!], for: .normal)
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
    
    @IBAction func cancelButtonCLicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    // MARK: UX 생각좀 해야될듯
    @IBAction func saveButtonClicked(_ sender: UIBarButtonItem) {
        if let selectIndex = selectedCategotyIndex,
        let date = dateToAdd,
        let prcieString = priceTextField.text,
        let price = Int(prcieString),
        let content = contentTextField.text
        {
            let catogry = category[selectIndex]
            
            var  payment = ""
            if paymentSegment.selectedSegmentIndex == 0 {
                payment = PaymentMethod.cash.rawValue
            }else{
                payment = PaymentMethod.card.rawValue
            }
            
            if expenseSegment.selectedSegmentIndex == 0 {
                let task = BudgetModel(usedDate: date, category: catogry, content: content, payment: payment, income: nil, spending: price)
                try! localRealm.write {
                    localRealm.add(task)
                }
            }else{
                let task = BudgetModel(usedDate: date, category: catogry, content: content, payment: payment, income: price, spending: nil)
                try! localRealm.write {
                    localRealm.add(task)
                }
            }
            handler!()
            dismiss(animated: true, completion: nil)
        }
    }
    
    
 
    @IBAction func addImageButtonClicked(_ sender: UIBarButtonItem) {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        let pickerView = PHPickerViewController(configuration: configuration)
        pickerView.delegate = self
        present(pickerView, animated: true, completion: nil)
    }
    
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        // MARK: 여기 값으로 segment 컨트롤.
        print(sender.selectedSegmentIndex)
    }
}

extension AddExpenseViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            
            itemProvider.loadObject(ofClass: UIImage.self) {(image, error) in
                DispatchQueue.main.async {
                    self.selectedImage.image = image as? UIImage
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
        print("ADf")
    }
}


enum PaymentMethod : String {
    case card
    case cash
}
