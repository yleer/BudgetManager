//
//  CalendarViewController.swift
//  BudgetManager
//
//  Created by Yundong Lee on 2021/11/18.
//

import UIKit


class CalendarViewController: UIViewController {
//https://github.com/annalizhaz/ChartsForSwiftBasic
 
    @IBOutlet weak var expenseTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        expenseTableView.delegate = self
        expenseTableView.dataSource = self
        
        let nibName = UINib(nibName: "ExpenseTableViewCell", bundle: nil)
        expenseTableView.register(nibName, forCellReuseIdentifier: "ExpenseTableViewCell")
    }
}

extension CalendarViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseTableViewCell", for: indexPath) as? ExpenseTableViewCell else { return UITableViewCell() }
        
        cell.contentLabel.text = "ASdf"
        
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
}
