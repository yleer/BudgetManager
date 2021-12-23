//
//  AddExpenseViewController.swift
//  BudgetManager
//
//  Created by Yundong Lee on 2021/11/18.
//

import UIKit
import PhotosUI
import RealmSwift
import SwiftUI
import Firebase

class AddExpenseViewController: UIViewController {

    @IBOutlet weak var recipetButton: UIButton!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var contentTextField: UITextField!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var expenseSegment: UISegmentedControl!
    @IBOutlet weak var paymentSegment: UISegmentedControl!
    
    private let localRealm = try! Realm()
    private var selectedCategotyIndex: Int?
    
    var dateToAdd: String?
    var handler: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        priceTextField.delegate = self
        recipetButton.isHidden = true
    }

    private let category = ["식료", "교육", "장보기", "의류", "의료", "교통", "레져", "여가", "여행", "기타" ]
    
    @IBAction func categoryButtonClicked(_ sender: UIButton) {
        guard let vc =  self.storyboard?.instantiateViewController(withIdentifier: "CategoryPopUpViewController") as?  CategoryPopUpViewController else { return }
    
        vc.buttonActionHandler = {
            self.selectedCategotyIndex = vc.selectedButton
            self.categoryButton.setTitle(self.category[self.selectedCategotyIndex!], for: .normal)
        }
        
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: false, completion: nil)
    }
    
    
    // MARK: 다음에 구현하기.
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
        Analytics.logEvent("Save_button", parameters: nil)
        if let selectIndex = selectedCategotyIndex,
        let date = dateToAdd,
        let prcieString = priceTextField.text,
        let price = Int(prcieString),
        let content = contentTextField.text
        {
            var catogry = ""
            if expenseSegment.selectedSegmentIndex == 0 {
                catogry = category[selectIndex]
            }
            
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
                
                if let image = self.selectedImage.image {
                    let a = "\(task.uuid)"
                    saveImageToDocumentDirectory(imageName: "\(a).jpg", image: image)
                }
            }else{
                let task = BudgetModel(usedDate: date, category: catogry, content: content, payment: payment, income: price, spending: nil)
            
                try! localRealm.write {
                    localRealm.add(task)
                }
                
                if let image = self.selectedImage.image {
                    let a = "\(task.uuid)"
                    saveImageToDocumentDirectory(imageName: "\(a).jpg", image: image)
                }
            }
            handler!()
            dismiss(animated: true, completion: nil)
        }else{
            let alertVC = UIAlertController(title: "필요한 정보를 모두 기입해주세요.", message: "지출을 기입시 지출금과 카테고리를 정해주세요.", preferredStyle: .alert)
            
            let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
            
            let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            
            alertVC.addAction(okButton)
            alertVC.addAction(cancelButton)
            
            present(alertVC, animated: true, completion: nil)
        }
    }
    
    
 
//     MARK: 사진 추가 기능 나중에 추가하자.
    @IBAction func addImageButtonClicked(_ sender: UIBarButtonItem) {
        Analytics.logEvent("Add_images", parameters: nil)
        
        let configuration = PHPickerConfiguration()
        let pickerView = PHPickerViewController(configuration: configuration)
        pickerView.delegate = self
        present(pickerView, animated: true, completion: nil)
    }
    
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        // MARK: 여기 값으로 segment 컨트롤.
        if sender == expenseSegment{
            if expenseSegment.selectedSegmentIndex == 1 {
                selectedCategotyIndex = 100
                categoryButton.setTitle("수익", for: .normal)
                categoryButton.isUserInteractionEnabled = false
            }else{
                selectedCategotyIndex = nil
                categoryButton.setTitle("카테고리", for: .normal)
                categoryButton.isUserInteractionEnabled = true
            }
        }
        
        print(sender.selectedSegmentIndex)
    }
    
    private func saveImageToDocumentDirectory(imageName: String, image: UIImage){
        // 1. 이미지 저장할 경로: 다큐먼트 경로(.documentDirectory) - FileManger가 관리
        // 샌드박스때문에 계속 위치가 바껴서 아래와 같이 경로 얻어옴.
        // ex) /user/ios/wee6app/
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        // 2. 이미지 파일 이름
        // ex) /user/ios/wee6app/image.jpg
        let imageUrl = documentDirectory.appendingPathComponent(imageName)
        
        
        // 3. 이미지 압축 (선택)
        guard let data = image.jpegData(compressionQuality: 0.3) else { return }
        
        // 4. 이미지 저장: 동일한 경로에 저장하게 될 경우, 덮어쓰기 됨
        // 4-1. 이미지 경로 확인.
        if FileManager.default.fileExists(atPath: imageUrl.path){
            
            // 4-2 기존 경로에 있는 이미지 삭제.
            do{
                try FileManager.default.removeItem(at: imageUrl)
                print("이미지 삭제됨.")
            } catch{
                print("이미지 삭제 못했습니다.")
            }
        }
        
        // 5. 이미지를 다큐먼트에 저장
        do{
            try data.write(to: imageUrl)
        } catch{
          print("이미지 저장 못함.")
        }
        
        
    }
}

extension AddExpenseViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) {(image, error) in
                
                guard let image = image as? UIImage else {
                    return
                }
                DispatchQueue.main.async {
                    self.selectedImage.image = image
                }
            }
        }
        
        
        picker.dismiss(animated: true, completion: nil)
        print("ADf")
    }
}


extension AddExpenseViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}

enum PaymentMethod : String {
    case card
    case cash
}
