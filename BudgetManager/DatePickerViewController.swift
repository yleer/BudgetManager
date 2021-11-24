//
//  DatePickerViewController.swift
//  BudgetManager
//
//  Created by Yundong Lee on 2021/11/24.
//

import UIKit

class DatePickerViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIPickerView!
    var chosenYear = 1
    var chosenMonth = 2
    
    
    let year: [Int] = Array(2000...2030)
    let month: [Int] = Array(1...12)
    var buttonActionHandler: (() -> ())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.delegate = self
        datePicker.dataSource = self
        
        print(chosenYear)
        print(chosenMonth)
        
        let yearIndex = year.firstIndex(of: chosenYear)!
        let monthIndex = month.firstIndex(of: chosenMonth)!
        
        datePicker.selectRow(yearIndex, inComponent: 0, animated: false)
        datePicker.selectRow(monthIndex, inComponent: 1, animated: false)
    }
    
    
    @IBAction func dismissButtonClicked(_ sender: UIButton) {
        buttonActionHandler!()
        dismiss(animated: true, completion: nil)
        
    }
}

extension DatePickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            chosenYear = year[row]
        }
        
        if component == 1{
            chosenMonth = month[row]
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return year.count
        }else {
            return month.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(year[row]) 년"
        }else{
            return "\(month[row]) 월"
        }
    }
}
