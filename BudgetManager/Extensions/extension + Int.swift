//
//  extension + Int.swift
//  BudgetManager
//
//  Created by Yundong Lee on 2021/12/04.
//

import Foundation

extension Int{
    func formatIntToString () -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let result = numberFormatter.string(for: self)!
        
        return result
    }
}
