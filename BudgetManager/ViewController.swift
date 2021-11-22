//
//  ViewController.swift
//  BudgetManager
//
//  Created by Yundong Lee on 2021/11/17.
//

import UIKit
import RealmSwift
import FSCalendar

class ViewController: UIViewController {

    @IBOutlet weak var historyCollectionView: UICollectionView!
    @IBOutlet weak var topCalendar: FSCalendar!
    var selectedDate: String = ""
    @IBOutlet weak var addButton: UIButton!
    let localRealm = try! Realm()
    var tasks: Results<BudgetModel>!
    var filterdTasks: Results<BudgetModel>!{
        didSet{
            historyCollectionView.reloadData()
            print(filterdTasks.count)
        }
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
    
        selectedDate = dateFormatter.string(from: today)
        tasks = localRealm.objects(BudgetModel.self)
        filterdTasks = tasks.where {
            $0.usedDate == selectedDate
        }
        historyCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fsCalendarConfigure()
        historyCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        addButton.setTitle("", for: .normal)
        addButton.layer.cornerRadius = 15
        addButton.backgroundColor = .green
    }
    
    
    
    func fsCalendarConfigure() {
        topCalendar.appearance.borderRadius = 1
        topCalendar.appearance.headerMinimumDissolvedAlpha = 0.0

        topCalendar.weekdayHeight = 30

        topCalendar.rowHeight = 50
        topCalendar.appearance.headerDateFormat = "YYYY년 M월"
        topCalendar.locale = Locale(identifier: "ko_KR")
        topCalendar.scope = .week
//        topCalendar.scrollEnabled = false
//        topCalendar.pagingEnabled = false
    }

    @IBAction func addButtonClicked(_ sender: UIButton) {
        guard let vc =  self.storyboard?.instantiateViewController(withIdentifier: "AddExpenseViewController") as?  AddExpenseViewController else { return }
        
        vc.modalPresentationStyle = .fullScreen
        print(selectedDate)
        vc.dateToAdd = selectedDate
        present(vc, animated: true, completion: nil)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("dfsg")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterdTasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identfier, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell()}
        
        let item = filterdTasks[indexPath.item]
        
        if let spending =  item.spending {
            cell.priceLabel.text = String(spending)
        }else{
            cell.priceLabel.text = String(item.income!)
        }
        
        
        cell.contentLabel.text = item.content
        
        cell.backgroundColor = .gray
        cell.layer.cornerRadius = 15
        
        return cell
    }
    
     
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 20
        }

        // 옆 간격
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 15
        }

        // cell 사이즈( 옆 라인을 고려하여 설정 )
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

            let width = collectionView.frame.width / 2 - 15 ///  3등분하여 배치, 옆 간격이 1이므로 1을 빼줌


            let size = CGSize(width: width, height: width)
            return size
        }
}

extension ViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        selectedDate = dateFormatter.string(from: date)
        
        filterdTasks = tasks.where {
            $0.usedDate == selectedDate
        }
    }
    
}

extension Date {
    
    func toString(dateFormat format: String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.locale = Locale.current
//        dateFormatter.date(from: <#T##String#>)
        return dateFormatter.string(from: self)
    }
    func a () {
        
        
    }
    
    func toDate(dateFormat format: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.locale = Locale.current
        
        return dateFormatter.date(from: dateFormatter.string(from: self))!
    }
    
    func toStringKST( dateFormat format: String ) -> String {
        return self.toString(dateFormat: format)
    }
    
    func toStringUTC( dateFormat format: String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: self)
    }
}
