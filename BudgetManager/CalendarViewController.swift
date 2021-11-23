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
    
    @IBOutlet weak var currentMonthIncome: UILabel!
    @IBOutlet weak var currentMonthSpending: UILabel!
    
    var chosenDayTasks: Results<BudgetModel>!{
        didSet{
            print(chosenDayTasks)
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        expenseTableView.delegate = self
        expenseTableView.dataSource = self
        
        let nibName = UINib(nibName: "ExpenseTableViewCell", bundle: nil)
        expenseTableView.register(nibName, forCellReuseIdentifier: "ExpenseTableViewCell")
        configureCalendarView()
    }
    
    func configureCalendarView() {
        calendarView.appearance.borderRadius = 3
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0

        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.backgroundColor = UIColor(red: 242, green: 231, blue: 20, alpha: 0.5)
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

}

extension CalendarViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chosenDayTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseTableViewCell", for: indexPath) as? ExpenseTableViewCell else { return UITableViewCell() }
        let row = chosenDayTasks[indexPath.row]
        
        if let income = row.income{
            cell.priceLabel.text = "\(income)원"
        }else{
            cell.priceLabel.text = "\(row.spending!)원"
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
        vc.dateTmp = row.usedDate
        vc.contentTmp = row.content

        if let income = row.income{
            // 수입.
            vc.incomeTmp = "\(income)원"

        }else{
            // 지출.
            vc.spendingTmp = "\(row.spending!)원"
            vc.categoryTitleTmp = row.category
        }
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
