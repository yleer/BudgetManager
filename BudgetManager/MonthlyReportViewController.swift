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
    
    let localRealm = try! Realm()
    var tasks: Results<BudgetModel>!
    var monthTasks: Results<BudgetModel>!{
        didSet{
            print(monthTasks)
        }
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
