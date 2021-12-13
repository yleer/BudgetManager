//
//  extension  + DateForematter.swift
//  BudgetManager
//
//  Created by Yundong Lee on 2021/12/04.
//

import Foundation

extension DateFormatter {
    func toYearMonthDayString(date: Date)  -> String {
        self.dateFormat = "yyyy-MM-dd"
        return self.string(from: date)
    }
    
    func toYearMonthString(date: Date) -> String {
        self.dateFormat = "yyyy-MM"
        return self.string(from: date)
    }
    
    func toYearInt(date: Date) -> Int{
        self.dateFormat = "yyyy"
        return Int(self.string(from: date))!
    }
    
    func toMonthInt(date: Date) -> Int{
        self.dateFormat = "MM"
        return Int(self.string(from: date))!
    }
}
