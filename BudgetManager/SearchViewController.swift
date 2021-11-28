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
    
    let localRealm = try! Realm()
    var tasks: Results<BudgetModel>!
    var filteredTasks: Results<BudgetModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
}

extension SearchViewController: UISearchBarDelegate {
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        print(searchBar.text)
    }
}



extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
    
    
}
