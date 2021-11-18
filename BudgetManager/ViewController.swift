//
//  ViewController.swift
//  BudgetManager
//
//  Created by Yundong Lee on 2021/11/17.
//

import UIKit
import FSCalendar

class ViewController: UIViewController {

    @IBOutlet weak var historyCollectionView: UICollectionView!
    @IBOutlet weak var topCalendar: FSCalendar!
    var selectedDate: Date = Date(){
        didSet{
            print(selectedDate)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fsCalendarConfigure()
        historyCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
    
    func fsCalendarConfigure() {
        topCalendar.appearance.borderRadius = 1
        topCalendar.appearance.headerMinimumDissolvedAlpha = 0.0

        topCalendar.weekdayHeight = 30

        topCalendar.rowHeight = 50
        topCalendar.appearance.headerDateFormat = "YYYY년 M월"
        topCalendar.locale = Locale(identifier: "ko_KR")
        topCalendar.scope = .week
    }
    
    func dateToCurrentLocation(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        return dateFormatter.string(from: date)
    }


}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identfier, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell()}
        
        
        cell.priceLabel.text = "100000"
        cell.contentLabel.text = "강아지 삼"
        cell.backgroundColor = .gray
        cell.layer.cornerRadius = 15
//        cell.remainingHistoryLabel.t
        
        return cell
    }
    
     
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 20
        }

        // 옆 간격
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 15
        }

        // cell 사이즈( 옆 라인을 고려하여 설정 )
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

            let width = collectionView.frame.width / 2 - 15 ///  3등분하여 배치, 옆 간격이 1이므로 1을 빼줌


            let size = CGSize(width: width, height: width)
            return size
        }
    
    
    
}

extension ViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
//        print(dateToCurrentLocation(date: date))
    }
    
}
