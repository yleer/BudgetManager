//
//  SettingPViewController.swift
//  BudgetManager
//
//  Created by Yundong Lee on 2021/11/30.
//

import UIKit
import RealmSwift

class SettingPViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
       
    }
    

 

}

extension SettingPViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as? SettingTableViewCell else {return UITableViewCell()}
        
        
        
        if indexPath.row == 0 {
            cell.title.text = "검색하기"
        }else if indexPath.row == 1{
            cell.title.text = "전체 데이터 삭제"
        }else{
            cell.title.text = "리뷰 남기기"
        }
        
        
        
        return cell
        
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
            return 3
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController else { return }
            
            navigationController?.pushViewController(vc, animated: true)
        }
        
        
         if indexPath.row == 1{
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
