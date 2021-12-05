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
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var todayTotalSpendingLabel: UILabel!
    @IBOutlet weak var remainingMoneyLabel: UILabel!
    
    
    var selectedDate: String = ""
    let localRealm = try! Realm()
    var tasks: Results<BudgetModel>!
    
  
    var filterdTasks: Results<BudgetModel>!{
        didSet{
            var spentMoney = 0
            var remainingMoney = 0
            var totalSpent = 0
            
            filterdTasks.forEach {
                if let spent = $0.spending{
                    spentMoney = spentMoney + spent
                }
            }

            todayTotalSpendingLabel.text = "오늘 쓴 금액 : \(spentMoney.formatIntToString())"
            
            tasks.forEach {
                if let income = $0.income {
                    remainingMoney = remainingMoney + income
                }
                
                if let spent = $0.spending {
                    totalSpent = totalSpent + spent
                }
            }
       
            remainingMoney = remainingMoney - totalSpent

            remainingMoneyLabel.text = "남은 금액 : \(remainingMoney.formatIntToString())"
            historyCollectionView.reloadData()
        }
    }
        
    func getToday() {
        selectedDate = DateFormatter().toYearMonthDayString(date: Date())
        getDateFromDB()
    }
    
    func getDateFromDB() {
        tasks = localRealm.objects(BudgetModel.self)
        filterdTasks = tasks.where {
            $0.usedDate == selectedDate
        }
        historyCollectionView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        historyCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        fsCalendarConfigure()
        tabBarConfigure()
        configureButton()
    }
    
    func tabBarConfigure() {
        tabBarController?.tabBar.tintColor = .systemOrange
        tabBarController?.tabBar.unselectedItemTintColor = .black
    }
    
    func configureButton() {
        addButton.setTitle("", for: .normal)
        addButton.layer.cornerRadius = addButton.frame.width / 2
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if selectedDate != ""{
            getDateFromDB()
        }else{
            getToday()
        }
    }
    
    
    func fsCalendarConfigure() {
        topCalendar.appearance.headerMinimumDissolvedAlpha = 0.0
        topCalendar.appearance.headerDateFormat = "YYYY년 M월"
        topCalendar.locale = Locale(identifier: "ko_KR")
        topCalendar.scope = .week
    }

    @IBAction func addButtonClicked(_ sender: UIButton) {
        guard let vc =  self.storyboard?.instantiateViewController(withIdentifier: "AddExpenseViewController") as?  AddExpenseViewController else { return }
        
        vc.modalPresentationStyle = .fullScreen
        print(selectedDate)
        vc.dateToAdd = selectedDate
        vc.handler = {
            self.filterdTasks = self.tasks.where {
                $0.usedDate == self.selectedDate
            }
        }
        present(vc, animated: true, completion: nil)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = filterdTasks[indexPath.item]
        
        let sb = UIStoryboard(name: "CalendarSB", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        vc.task = item
        vc.handler = {
            self.tasks = self.localRealm.objects(BudgetModel.self)
            self.filterdTasks = self.tasks.where {
                $0.usedDate == self.selectedDate
            }
            
            self.historyCollectionView.reloadData()
            
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
            cell.priceLabel.text = "지출"
            cell.remainingHistoryLabel.text = spending.formatIntToString() + "원"
            
            let paymentImage = item.payment == PaymentMethod.card.rawValue ? UIImage(named: "credit-card") : UIImage(named: "dollar")
            cell.paymentImage.image = paymentImage
    
            
            let image = CategoryData.category[item.category]
            cell.categoryImage.image = image!
            
            cell.categoryImage.isHidden = false
            cell.paymentImage.isHidden = false
        }else{
            
            cell.priceLabel.text = "수입"
            cell.remainingHistoryLabel.text = item.income!.formatIntToString() + "원"
            
            cell.categoryImage.isHidden = true
            cell.paymentImage.isHidden = true
            
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
            ///
            let size = CGSize(width: width, height: width)
            return size
        }
}

extension ViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
 
        selectedDate = DateFormatter().toYearMonthDayString(date: date)
        filterdTasks = tasks.where {
            $0.usedDate == selectedDate
        }
    }
    
//    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
////        let dateFormatter = DateFormatter()
////        dateFormatter.dateFormat = "yyyy-MM-dd"
//////        print(monthTasks)
////        for day in filterdTasks{
////
////            let query = dateFormatter.string(from: date)
////
////            print(day.usedDate, query)
////            if query == day.usedDate{
////                return 1
////            }
////        }
//        return 1
//    }
}



