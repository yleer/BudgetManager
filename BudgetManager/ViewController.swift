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
    @IBOutlet weak var todayTotalSpendingLabel: UILabel!
    @IBOutlet weak var remainingMoneyLabel: UILabel!
    var tasks: Results<BudgetModel>!
    
  
    var filterdTasks: Results<BudgetModel>!{
        didSet{
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let price = 12345678
            let result = numberFormatter.string(for: price)!

            
            var spentMoney = 0
            for filterdTask in filterdTasks{
                if let spending = filterdTask.spending{
                    spentMoney = spentMoney + spending
                }
            }
            todayTotalSpendingLabel.text = "오늘 쓴 금액 : \(numberFormatter.string(for: spentMoney)!)"
            
            var remainingMoney = 0
            var totalSpent = 0
            for allTask in tasks{
                if let income = allTask.income{
                    remainingMoney = remainingMoney + income
                }
                if let spent = allTask.spending{
                    totalSpent = totalSpent + spent
                }
            }
            
            remainingMoney = remainingMoney - totalSpent
            remainingMoneyLabel.text = "남은 금액 : \(numberFormatter.string(for: remainingMoney)!)"
            historyCollectionView.reloadData()
            
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
        print(localRealm.configuration.fileURL)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fsCalendarConfigure()
        historyCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        addButton.setTitle("", for: .normal)
        addButton.layer.cornerRadius = addButton.frame.width / 2
//        addButton.backgroundColor = .green
    }
    
    
    
    func fsCalendarConfigure() {
        topCalendar.appearance.borderRadius = 3
        topCalendar.appearance.headerMinimumDissolvedAlpha = 0.0

        
        topCalendar.delegate = self
        topCalendar.dataSource = self
//        topCalendar.calendarHeaderView.setScrollOffset(0, animated: false)
        topCalendar.backgroundColor = UIColor(red: 242, green: 231, blue: 20, alpha: 0.5)
        
        
//        topCalendar.appearance.borderDefaultColor = .black

//        topCalendar.appearance.headerTitleColor = UIColor(red: 65, green: 68, blue: 88, alpha: 0.45)
//        topCalendar.appearance.selectionColor = UIColor(red: 65, green: 68, blue: 88, alpha: 0.45)
        
        
        topCalendar.appearance.headerDateFormat = "YYYY년 M월"
        topCalendar.locale = Locale(identifier: "ko_KR")
        topCalendar.scope = .week
        
        topCalendar.headerHeight = 30
        topCalendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 22) // 해더 글자
        topCalendar.appearance.titleFont = UIFont.systemFont(ofSize: 17) // 날짜

    }
    var events : [Date] = []
    func setUpEvents() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"
        let xmas = formatter.date(from: "2020-12-25")
        let sampledate = formatter.date(from: "2020-08-22")
        events = [xmas!, sampledate!]
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
        
        let item = filterdTasks[indexPath.item]
        
        let sb = UIStoryboard(name: "CalendarSB", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        vc.task = item
        vc.dateTmp = item.usedDate
        vc.contentTmp = item.content

        if let income = item.income{
            // 수입.
            vc.incomeTmp = "\(income)원"

        }else{
            // 지출.
            vc.spendingTmp = "\(item.spending!)원"
            vc.categoryTitleTmp = item.category
        }
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
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
        cell.layer.cornerRadius = cell.frame.width / 5
        
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
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        let a  = dateFormatter.string(from: date)
        
        if self.events.contains(date) {
            print("asd")
            return 1
        }
        else {
            return 0
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

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
