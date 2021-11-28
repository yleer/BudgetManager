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
        
    func getToday() {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
    
        selectedDate = dateFormatter.string(from: today)
        tasks = localRealm.objects(BudgetModel.self)
        filterdTasks = tasks.where {
            $0.usedDate == selectedDate
        }
        historyCollectionView.reloadData()
//        print(localRealm.configuration.fileURL)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fsCalendarConfigure()
        historyCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        addButton.setTitle("", for: .normal)
        addButton.layer.cornerRadius = addButton.frame.width / 2
        getToday()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if selectedDate != ""{
            tasks = localRealm.objects(BudgetModel.self)
            filterdTasks = tasks.where {
                $0.usedDate == selectedDate
            }
            historyCollectionView.reloadData()
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
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        if let spending =  item.spending {
            cell.priceLabel.text = "지출"
            let result = numberFormatter.string(for: (spending))!
            cell.remainingHistoryLabel.text = result + "원"
            switch item.payment{
            case PaymentMethod.card.rawValue:
                cell.paymentImage.image = UIImage(named: "credit-card")
            case PaymentMethod.cash.rawValue:
                cell.paymentImage.image = UIImage(named: "dollar")
            default:
                print("not good")
            }
            
            
            if item.category == "식료"{
                cell.categoryImage.image = UIImage(named: "diet")
            }else if item.category == "교육"{
                cell.categoryImage.image = UIImage(named: "education (1)")
            }else if item.category == "장보기"{
                cell.categoryImage.image = UIImage(named: "grocery-cart")
            }else if item.category == "의류"{
                cell.categoryImage.image = UIImage(named: "laundry")
            }else if item.category == "의료"{
                cell.categoryImage.image = UIImage(named: "pills")
            }else if item.category == "교통"{
                cell.categoryImage.image = UIImage(named: "vehicles")
            }else if item.category == "레져"{
                cell.categoryImage.image = UIImage(named: "")
            }else if item.category == "여가"{
                cell.categoryImage.image = UIImage(named: "watching-tv")
            }else if item.category == "여행"{
                cell.categoryImage.image = UIImage(named: "baggage")
            }
            else if item.category == "기타"{
                cell.categoryImage.image = UIImage(named: "more")
            }
            
            
            cell.categoryImage.isHidden = false
            cell.paymentImage.isHidden = false
        }else{
            cell.priceLabel.text = "수입"
            let result = numberFormatter.string(for: (item.income!))!
            
            cell.categoryImage.isHidden = true
            cell.paymentImage.isHidden = true
            cell.remainingHistoryLabel.text = result + "원"
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
////        print(monthTasks)
//        for day in filterdTasks{
//
//            let query = dateFormatter.string(from: date)
//
//            print(day.usedDate, query)
//            if query == day.usedDate{
//                return 1
//            }
//        }
        return 1
    }
}


