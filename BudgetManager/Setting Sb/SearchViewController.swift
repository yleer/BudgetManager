//
//  SearchViewController.swift
//  BudgetManager
//
//  Created by Yundong Lee on 2021/11/24.
//

import UIKit
import RealmSwift
class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchedTableView: UITableView!
    
    private let localRealm = try! Realm()
    private var tasks: Results<BudgetModel>!
    private var filteredTasks: Results<BudgetModel>!
    override func viewDidLoad() {
        super.viewDidLoad()
        tasks = localRealm.objects(BudgetModel.self)
        filteredTasks = localRealm.objects(BudgetModel.self)
        let nibName = UINib(nibName: "ExpenseTableViewCell", bundle: nil)
        searchedTableView.register(nibName, forCellReuseIdentifier: "ExpenseTableViewCell")
        self.navigationController?.navigationBar.tintColor = .systemOrange
    }
    private var query = ""
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text{
            query = text
            if query == "" {
                filteredTasks = tasks
            }else{
                filteredTasks = tasks.where {
                    $0.content.contains(query)
                }
            }
            
            searchedTableView.reloadData()
        }
    }
    
}



extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = filteredTasks[indexPath.item]
        
        let sb = UIStoryboard(name: "CalendarSB", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        vc.task = row
        vc.handler = {
            self.tasks = self.localRealm.objects(BudgetModel.self)
//            self.filteredTasks = self.tasks.where {
//                $0.content.contains(self.query)
//            }
            self.searchedTableView.reloadData()
        }
        searchedTableView.reloadData()
 
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseTableViewCell", for: indexPath) as? ExpenseTableViewCell else { return UITableViewCell() }
        
        let row = filteredTasks[indexPath.row]
        
        
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
        
        
//        cell.contentLabel.text = row.content
//        cell.dateLabel.text = row.usedDate
//
//        if let income = row.income{
//            cell.priceLabel.text = income.formatIntToString()
//            cell.incomeLabel.isHidden = false
//        }else{
//            cell.incomeLabel.isHidden = true
//            cell.priceLabel.text = row.spending?.formatIntToString()
//
//
//            if row.payment == "cash"{
//                cell.paymentLabel.image =
//            }else{
//                cell.paymentLabel.image =
//            }
//
//            cell.categoryImage.image =
//
//
//
//
//        }
    }
    
    
}
