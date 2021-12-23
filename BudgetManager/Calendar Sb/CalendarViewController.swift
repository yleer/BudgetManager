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
     
    @IBOutlet weak var currentMonthIncome: UILabel!
    @IBOutlet weak var currentMonthSpending: UILabel!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var expenseTableView: UITableView!
    
    private var selectedDate: String = ""
    private let localRealm = try! Realm()
    private var tasks: Results<BudgetModel>!
    private var monthTasks: Results<BudgetModel>!
    {
        didSet{
            calendarView.reloadData()
        }
    }
    
    private var chosenDayTasks: Results<BudgetModel>!
    
    
    private func updateLabels() {
        var spending = 0
        var income = 0
        for task in monthTasks{
            if let earn = task.income{
                income = income + earn
            }else{
                spending = spending + task.spending!
            }
        }
        
        currentMonthIncome.text = "이번달 총 수익 : \(income.formatIntToString())원"
        currentMonthSpending.text = "이번달 총 지출 : \(spending.formatIntToString())원"
    
        expenseTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        if calendarView.selectedDate == nil {
            selectedDate = DateFormatter().toYearMonthDayString(date: Date())
            
            let query = DateFormatter().toYearMonthString(date: Date())
            
            tasks = localRealm.objects(BudgetModel.self)
            chosenDayTasks = tasks.where {
                $0.usedDate == selectedDate
            }
            monthTasks = tasks.where {
                $0.usedDate.contains(query)
            }

            updateLabels()
            
        }else{
            selectedDate = DateFormatter().toYearMonthDayString(date: calendarView.selectedDate!)
            
            tasks = localRealm.objects(BudgetModel.self)
            chosenDayTasks = tasks.where {
                $0.usedDate == selectedDate
            }
 
            let query = DateFormatter().toYearMonthString(date: calendarView.selectedDate!)

            monthTasks = tasks.where {
                $0.usedDate.contains(query)
            }
            updateLabels()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: "ExpenseTableViewCell", bundle: nil)
        expenseTableView.register(nibName, forCellReuseIdentifier: "ExpenseTableViewCell")
        configureCalendarView()
    }
    
    private func configureCalendarView() {
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
        
        selectedDate = DateFormatter().toYearMonthDayString(date: date)
        chosenDayTasks = tasks.where {
            $0.usedDate == selectedDate
        }
        expenseTableView.reloadData()
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let query = DateFormatter().toYearMonthString(date: calendar.currentPage)

        monthTasks = tasks.where {
            $0.usedDate.contains(query)
        }
        updateLabels()
    }
    
    
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        for day in monthTasks{
            let query = DateFormatter().toYearMonthDayString(date: date)
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
        
        if let income = row.income{
            cell.categoryImage.isHidden = true
            cell.paymentLabel.isHidden = true
            cell.incomeLabel.isHidden = false
            
            cell.priceLabel.text = "\(income.formatIntToString())원"
            
        }else{
            cell.categoryImage.isHidden = false
            cell.paymentLabel.isHidden = false
            cell.incomeLabel.isHidden = true
            
            cell.priceLabel.text = "\(row.spending!.formatIntToString())원"
            cell.categoryImage.image = CategoryData.category[row.category]!
            
            let paymentImage = row.payment == PaymentMethod.card.rawValue ? UIImage(named: "credit-card") : UIImage(named: "dollar")
            cell.paymentLabel.image = paymentImage
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
            self.calendarView.reloadData()
        }
        
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
}
