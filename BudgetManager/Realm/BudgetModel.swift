//
//  BudgetModel.swift
//  BudgetManager
//
//  Created by Yundong Lee on 2021/11/21.
//

import Foundation
import RealmSwift

class BudgetModel: Object {
    
    @Persisted var usedDate : String
    @Persisted var category: Int
    @Persisted var content: String
    @Persisted var payment: String
    @Persisted var income: Int?
    @Persisted var spending: Int?
    
    convenience init(usedDate: String, category: Int, content: String, payment: String, income: Int?, spending: Int?) {
        self.init()
        self.usedDate = usedDate
        self.content = content
        self.category = category
        self.payment = payment
        self.income = income
        self.spending = spending
    }
}
