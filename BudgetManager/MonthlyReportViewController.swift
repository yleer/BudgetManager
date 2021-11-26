//
//  MonthlyReportViewController.swift
//  BudgetManager
//
//  Created by Yundong Lee on 2021/11/18.
//

import UIKit
import RealmSwift
import Charts

class MonthlyReportViewController: UIViewController {

    @IBOutlet weak var monthButton: UIButton!
    @IBOutlet weak var barChart: BarChartView!
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var totalIncome: UILabel!
    @IBOutlet weak var usedPercentage: UIProgressView!
    
    
    let localRealm = try! Realm()
    var tasks: Results<BudgetModel>!
    var monthSpending = 0
    var monthIncome = 0
    
    var monthTasks: Results<BudgetModel>!{
        didSet{
            monthSpending = 0
            monthIncome = 0
            for task in monthTasks{
                if let income = task.income{
                    monthIncome += income
                }else{
                    monthSpending += task.spending!
                }
            }
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let result = numberFormatter.string(for: monthIncome)!
            totalIncome.text = "\(result)원"
            
//            pv.progressTintColor = UIColor.green
//            pv.trackTintColor = UIColor.white
            usedPercentage.progress = Float(Float(monthSpending) / Float(monthIncome))
            
            
            print("monthincome",monthIncome)
            print("monthoutcome",monthSpending)
        }
    }
    
    
    func pieChartUpdate() {
        
        var categories: [Int] = [0,0,0,0,0,0,0,0,0,0]
        for task in monthTasks{
            if task.spending != nil{
                if task.category == "식료"{
                    categories[0] += task.spending!
                }else if task.category == "교육"{
                    categories[1] += task.spending!
                }else if task.category == "장보기"{
                    categories[2] += task.spending!
                }else if task.category == "의류"{
                    categories[3] += task.spending!
                }else if task.category == "의료"{
                    categories[4] += task.spending!
                }else if task.category == "교통"{
                    categories[5] += task.spending!
                }else if task.category == "레져"{
                    categories[6] += task.spending!
                }else if task.category == "여가"{
                    categories[7] += task.spending!
                }else if task.category == "여행"{
                    categories[8] += task.spending!
                }
                else if task.category == "기타"{
                    categories[9] += task.spending!
                }
            }
        }
        
        let entry1 = PieChartDataEntry(value: Double(categories[0]), label: "식료")
        let entry2 = PieChartDataEntry(value: Double(categories[1]), label: "교육")
        let entry3 = PieChartDataEntry(value: Double(categories[2]), label: "장보기")
        let entry4 = PieChartDataEntry(value: Double(categories[3]), label: "의료")
        let entry5 = PieChartDataEntry(value: Double(categories[4]), label: "의료")
        let entry6 = PieChartDataEntry(value: Double(categories[5]), label: "교통")
        let entry7 = PieChartDataEntry(value: Double(categories[6]), label: "레져")
        let entry8 = PieChartDataEntry(value: Double(categories[7]), label: "여가")
        let entry9 = PieChartDataEntry(value: Double(categories[8]), label: "여행")
        let entry10 = PieChartDataEntry(value: Double(categories[9]), label: "기타")
        
        let dataSet = PieChartDataSet(entries: [entry1, entry2, entry3, entry4, entry5, entry6, entry7, entry8, entry9, entry10], label: "Widget Types")
        let data = PieChartData(dataSet: dataSet)
        dataSet.colors = ChartColorTemplates.joyful()
        print(categories)
        pieChart.data = data

        pieChart.notifyDataSetChanged()
    }
    
    
    
    var chosenDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tasks = localRealm.objects(BudgetModel.self)
        let today = Date()
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM"
        let query = dateFormatter2.string(from: today)
        chosenDate = query
        monthTasks = tasks.where {
            $0.usedDate.contains(query)
        }
        
        pieChartUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tasks = localRealm.objects(BudgetModel.self)
        let today = Date()
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM"
        let query = dateFormatter2.string(from: today)
        chosenDate = query
        monthTasks = tasks.where {
            $0.usedDate.contains(query)
        }
        
        pieChartUpdate()
    }
    
    @IBAction func monthButtonClicked(_ sender: UIButton) {
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "DatePickerViewController") as? DatePickerViewController else { return }
        
        let today = Date()
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM"
        let query = dateFormatter2.string(from: today)
        let stopIndex = query.firstIndex(of: "-")
        
        let a = query.index(after: stopIndex!)
        vc.chosenYear = Int(query[..<stopIndex!])!
        vc.chosenMonth = Int(query[a...])!
        
        
        
        vc.buttonActionHandler = {
            self.chosenDate = "\(vc.chosenYear)-\(vc.chosenMonth)"
            
            let date = "\(vc.chosenYear)년 \(vc.chosenMonth)월"
            self.monthButton.setTitle(date, for: .normal)
            self.monthTasks = self.tasks.where {
                $0.usedDate.contains(self.chosenDate)
            }
        }
    
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
}
