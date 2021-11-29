//
//  SettingTableViewController.swift
//  BudgetManager
//
//  Created by Yundong Lee on 2021/11/24.
//

import UIKit
import RealmSwift

class SettingTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        }else {
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController else { return }
            
            navigationController?.pushViewController(vc, animated: true)
        }
        
        
        if indexPath.section == 1 && indexPath.row == 0{
            // 삭제
            let alertVC = UIAlertController(title: "전체 데이터를 삭제하시겠습니까?", message: "", preferredStyle: .actionSheet)
            
            let fromGallaryButton = UIAlertAction(title: "확인", style: .destructive, handler: { _ in
                let realm = try! Realm()
                try! realm.write {
                    realm.deleteAll()
                }
            })
            let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            
            alertVC.addAction(fromGallaryButton)
            alertVC.addAction(cancelButton)
            
            present(alertVC, animated: true, completion: nil)
        }
    }
}
