//
//  BudgetModel.swift
//  BudgetManager
//
//  Created by Yundong Lee on 2021/11/21.
//

import Foundation
import RealmSwift

class BudgetModel: Object {
    
    @Persisted var uuid: UUID
    @Persisted var usedDate : String
    @Persisted var category: String
    @Persisted var content: String
    @Persisted var payment: String
    @Persisted var income: Int?
    @Persisted var spending: Int?
    
    convenience init(usedDate: String, category: String, content: String, payment: String, income: Int?, spending: Int?) {
        self.init()
        self.usedDate = usedDate
        self.content = content
        self.category = category
        self.payment = payment
        self.income = income
        self.spending = spending
    }
    
  
   
    
//    let config = Realm.Configuration(
//        schemaVersion: 2,
//        migrationBlock: { migration, oldSchemaVersion in
//            if oldSchemaVersion < 2 {
//                // Rename the "age" property to "yearsSinceBirth".
//                // The renaming operation should be done outside of calls to `enumerateObjects(ofType: _:)`.
////                migration.renameProperty(onType: Person.className(), from: "age", to: "yearsSinceBirth")
//                migration.create(<#T##typeName: String##String#>, value: <#T##Any#>)
//            }
//        })
    
}
