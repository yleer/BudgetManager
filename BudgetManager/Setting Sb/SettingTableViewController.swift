//
//  SettingTableViewController.swift
//  BudgetManager
//
//  Created by Yundong Lee on 2021/11/24.
//

import UIKit
import Zip
import RealmSwift

class SettingTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func documentDirectoryPath() -> String? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let path = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let directoryPath = path.first{
            return directoryPath
        }else{
            return nil
        }
    }
    
    func backUp() {
        // 4. 백업할 파일에 대한 url 배열
        var urlPaths = [URL]()
 
        // 1. 폴더 위치 확인 (/user/app/ios/appname)
        if let path = documentDirectoryPath(){
            // 2. 백업하고자 하는 파일 url 확인.
            // 이미지 같은 경우 백업 편의성을 위해 폴더에 담는게 좋음.
            let realm = (path as NSString).appendingPathComponent("default.realm")
            
            if FileManager.default.fileExists(atPath: realm){
                // 5. URL 배열에 백업 파일 url 추가
                urlPaths.append(URL(string: realm)!)
            }else{
                print("백업할 파일이 없습니다. ")
            }
            
            // 2. 백업하고자 하는 파일 확인.
        }
        
        //3.  배열에 대한 압축 파일 만들기.
        do {
            let zipFilePath = try Zip.quickZipFiles(urlPaths, fileName: "archive") // Zip
            print("압축경로 \(zipFilePath)")
//            presentActivityViewController()
        }
        catch {
          print("Something went wrong")
        }
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
