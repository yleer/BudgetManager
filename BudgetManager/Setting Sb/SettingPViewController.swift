//
//  SettingPViewController.swift
//  BudgetManager
//
//  Created by Yundong Lee on 2021/11/30.
//

import UIKit
import MobileCoreServices
import Zip
import RealmSwift

class SettingPViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.navigationBar.isTranslucent = false
       
    }
    
    private func documentDirectoryPath() -> String? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let path = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let directoryPath = path.first{
            return directoryPath
        }else{
            return nil
        }
    }
    
    private func presentActivityViewController() {
        // 압축 파일 경로 가져오기
        let fileName = (documentDirectoryPath()! as NSString).appendingPathComponent("archive4.zip")
        let fileUrl = URL(fileURLWithPath: fileName)
        
        let vc = UIActivityViewController(activityItems: [fileUrl], applicationActivities: [])
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    private func backUp() {
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
                
                // MARK: .jpg로 시작하는 url들 다 urlPaths에 추가해야됨.
                
                do {
                    let result = try FileManager.default.contentsOfDirectory(atPath: path)
        
                    for item in result{
                        if item.contains(".jpg"){
                            
                            let imageUrl = (path as NSString).appendingPathComponent(item)
                            urlPaths.append(URL(string: imageUrl)!)
                        }
                    }
                }catch{
                    print("error")
                }
                
            }else{
                print("백업할 파일이 없습니다. ")
            }
            
            // 2. 백업하고자 하는 파일 확인.
        }
        
        print(urlPaths)
        
        //3.  배열에 대한 압축 파일 만들기.
        do {
            let zipFilePath = try Zip.quickZipFiles(urlPaths, fileName: "archive4") // Zip
            print("압축경로 \(zipFilePath)")
            presentActivityViewController()
        }
        catch {
          print("Something went wrong")
        }
    }
    
}

extension SettingPViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as? SettingTableViewCell else {return UITableViewCell()}
        

        if indexPath.row == 0 {
            cell.title.text = "검색하기"
        }else if indexPath.row == 1{
            cell.title.text = "전체 데이터 삭제"
        }else if indexPath.row == 2{
            cell.title.text = "리뷰 남기기"
        }else if indexPath.row == 3{
            cell.title.text = "백업하기"
        }else{
            cell.title.text = "복구하기"
        }
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
            return 5
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
         }else if indexPath.row == 3{
             
             let alertVC = UIAlertController(title: "전체 데이터를 백업하시겠습니까?", message: "백업을 하면 백업파일이 생성됩니다.", preferredStyle: .actionSheet)
             
             let okButton = UIAlertAction(title: "확인", style: .destructive, handler: { _ in
                 
                 // MARK: back up
                 self.backUp()
             })
             let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
             
             alertVC.addAction(okButton)
             alertVC.addAction(cancelButton)
             present(alertVC, animated: true, completion: nil)
         }else if indexPath.row == 4 {
             
             let alertVC = UIAlertController(title: "데이터를 복원하시겠습니까?", message: "현재의 데이터가 백업데이터로 대체 됩니다.", preferredStyle: .actionSheet)
             
             let okButton = UIAlertAction(title: "확인", style: .destructive, handler: { _ in
                 // MARK: restore
                 let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeArchive as String], in: .import)
                 documentPicker.delegate = self
                 documentPicker.allowsMultipleSelection = false
                 self.present(documentPicker, animated: true, completion: nil)
                
             })
             let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
             
             alertVC.addAction(okButton)
             alertVC.addAction(cancelButton)
             present(alertVC, animated: true, completion: nil)
         }
    }
}
extension SettingPViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        // 복구 2. 선택한 파일의 경로를 가져와야함
        guard let selectedFileUrl = urls.first else { return }
        print(selectedFileUrl)
        
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let sandBoxFileUrl = directory.appendingPathComponent(selectedFileUrl.lastPathComponent)

        // 복구 3. 압축 해제

        if FileManager.default.fileExists(atPath: sandBoxFileUrl.path) {
            // 기존에 복구하고자 하는 zip파일을 다큐멘트에서 가지고 있는 경우, 도큐먼트에 위치한 곳에 unzip하면 됨.
            do{
                let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileUrl = documentDirectory.appendingPathComponent(sandBoxFileUrl.lastPathComponent)
                try Zip.unzipFile(fileUrl, destination: documentDirectory, overwrite: true, password: nil, progress: { progress in
                    print(progress)
                }, fileOutputHandler: { unzippedFile in
                    print(unzippedFile)
                })
                
                
                let alertVC = UIAlertController(title: "복구가 성공했습니다", message: "어플을 끄고 다시 실행해 주세요.", preferredStyle: .alert)
                let cancelButton = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                alertVC.addAction(cancelButton)
                present(alertVC, animated: true, completion: nil)
                
            }catch{
                print("not good ")
            }

        }else{
            // 파일 앱의 zip -> 다큐먼트에 복사.
            do{
                try FileManager.default.copyItem(at: selectedFileUrl, to: sandBoxFileUrl)
                let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileUrl = documentDirectory.appendingPathComponent("archive4.zip")
                try Zip.unzipFile(fileUrl, destination: documentDirectory, overwrite: true, password: nil, progress: { progress in
                    print(progress)
                }, fileOutputHandler: { unzippedFile in
                    print(unzippedFile)
                })
                
                let alertVC = UIAlertController(title: "복구가 성공했습니다", message: "어플을 끄고 다시 실행해 주세요.", preferredStyle: .alert)
                let cancelButton = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                alertVC.addAction(cancelButton)
                present(alertVC, animated: true, completion: nil)
                
            }catch{
                print("error")
            }
        }
    }
}
