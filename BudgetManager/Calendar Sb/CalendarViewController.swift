//
//  CalendarViewController.swift
//  BudgetManager
//
//  Created by Yundong Lee on 2021/11/18.
//

import UIKit
import FSCalendar
import RealmSwift

class CalendarViewController: UIViewController {
//https://github.com/annalizhaz/ChartsForSwiftBasic
 
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var expenseTableView: UITableView!
    var selectedDate: String = ""
    
    let localRealm = try! Realm()
    var tasks: Results<BudgetModel>!
    var monthTasks: Results<BudgetModel>!
    {
        didSet{
            calendarView.reloadData()
        }
    }
//            var query = ""
//
//
//            monthTasks = tasks.where {
//                $0.usedDate.contains(query)
//            }
//
//            var spending = 0
//            var income = 0
//            for task in monthTasks{
//                if let earn = task.income{
//                    income = income + earn
//                }else{
//                    spending = spending + task.spending!
//                }
//            }
//
//            let numberFormatter = NumberFormatter()
//            numberFormatter.numberStyle = .decimal
//
//            let incomeFormatted = numberFormatter.string(for: income)!
//            let spendingFormatted = numberFormatter.string(for: spending)!
//
//            currentMonthIncome.text = "이번달 총 수익 : \(incomeFormatted)원"
//            currentMonthSpending.text = "이번달 총 지출 : \(spendingFormatted)원"
//        }
//    }
    
    @IBOutlet weak var currentMonthIncome: UILabel!
    @IBOutlet weak var currentMonthSpending: UILabel!
    
    var chosenDayTasks: Results<BudgetModel>!{
        didSet{
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
    
        selectedDate = dateFormatter.string(from: today)
        tasks = localRealm.objects(BudgetModel.self)
        chosenDayTasks = tasks.where {
            $0.usedDate == selectedDate
        }
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM"
        let query = dateFormatter2.string(from: today)
        monthTasks = tasks.where {
            $0.usedDate.contains(query)
        }
        
        var spending = 0
        var income = 0
        for task in monthTasks{
            if let earn = task.income{
                income = income + earn
            }else{
                spending = spending + task.spending!
            }
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let incomeFormatted = numberFormatter.string(for: income)!
        let spendingFormatted = numberFormatter.string(for: spending)!
        
        currentMonthIncome.text = "이번달 총 수익 : \(incomeFormatted)원"
        currentMonthSpending.text = "이번달 총 지출 : \(spendingFormatted)원"
        
        expenseTableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nibName = UINib(nibName: "ExpenseTableViewCell", bundle: nil)
        expenseTableView.register(nibName, forCellReuseIdentifier: "ExpenseTableViewCell")
        
        configureCalendarView()

    }
    
    func configureCalendarView() {
        calendarView.appearance.borderRadius = 3
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0

        calendarView.appearance.headerDateFormat = "YYYY년 M월"
        calendarView.locale = Locale(identifier: "ko_KR")

        calendarView.headerHeight = 30
        calendarView.appearance.headerTitleFont = UIFont.systemFont(ofSize: 22) // 해더 글자
        calendarView.appearance.titleFont = UIFont.systemFont(ofSize: 17) // 날짜
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        selectedDate = dateFormatter.string(from: date)
        chosenDayTasks = tasks.where {
            $0.usedDate == selectedDate
        }
        expenseTableView.reloadData()
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        
        let query = dateFormatter.string(from: calendar.currentPage)

        monthTasks = tasks.where {
            $0.usedDate.contains(query)
        }
        
        var spending = 0
        var income = 0
        for task in monthTasks{
            if let earn = task.income{
                income = income + earn
            }else{
                spending = spending + task.spending!
            }
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let incomeFormatted = numberFormatter.string(for: income)!
        let spendingFormatted = numberFormatter.string(for: spending)!
        
        currentMonthIncome.text = "이번달 총 수익 : \(incomeFormatted)원"
        currentMonthSpending.text = "이번달 총 지출 : \(spendingFormatted)원"
    }
    
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
//        print(monthTasks)
        for day in monthTasks{
            
            let query = dateFormatter.string(from: date)
            
            print(day.usedDate, query)
            if query == day.usedDate{
                return 1
            }
        }
        return 0
    }

}

extension CalendarViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chosenDayTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseTableViewCell", for: indexPath) as? ExpenseTableViewCell else { return UITableViewCell() }
        let row = chosenDayTasks[indexPath.row]
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        
        if let income = row.income{
            let formattedIncome = numberFormatter.string(for: income)!
            cell.priceLabel.text = "\(formattedIncome)원"
            
            cell.categoryImage.isHidden = true
            cell.paymentLabel.isHidden = true
            cell.incomeLabel.isHidden = false
        }else{
            cell.categoryImage.isHidden = false
            cell.paymentLabel.isHidden = false
            cell.incomeLabel.isHidden = true
            let formattedSpending = numberFormatter.string(for: row.spending!)!
            cell.priceLabel.text = "\(formattedSpending)원"
            
            if row.category == "식료"{
                cell.categoryImage.image = UIImage(named: "diet")
            }else if row.category == "교육"{
                cell.categoryImage.image = UIImage(named: "education (1)")
            }else if row.category == "장보기"{
                cell.categoryImage.image = UIImage(named: "grocery-cart")
            }else if row.category == "의류"{
                cell.categoryImage.image = UIImage(named: "laundry")
            }else if row.category == "의료"{
                cell.categoryImage.image = UIImage(named: "pills")
            }else if row.category == "교통"{
                cell.categoryImage.image = UIImage(named: "vehicles")
            }else if row.category == "레져"{
                cell.categoryImage.image = UIImage(named: "")
            }else if row.category == "여가"{
                cell.categoryImage.image = UIImage(named: "watching-tv")
            }else if row.category == "여행"{
                cell.categoryImage.image = UIImage(named: "baggage")
            }
            else if row.category == "기타"{
                cell.categoryImage.image = UIImage(named: "more")
            }
            
            switch row.payment{
            case PaymentMethod.card.rawValue:
                cell.paymentLabel.image = UIImage(named: "credit-card")
            case PaymentMethod.cash.rawValue:
                cell.paymentLabel.image = UIImage(named: "dollar")
            default:
                print("not good")
            }
        }
        
        cell.dateLabel.text = row.usedDate
        cell.contentLabel.text = row.content
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController  else { return }
        let row = chosenDayTasks[indexPath.row]
        vc.task = row
        vc.handler = {
            self.tasks = self.localRealm.objects(BudgetModel.self)
            self.chosenDayTasks = self.tasks.where {
                $0.usedDate == self.selectedDate
            }
            self.expenseTableView.reloadData()
        }
        
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
}
