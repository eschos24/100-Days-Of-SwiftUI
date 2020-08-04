//
//  Expenses.swift
//  iExpense
//
//  Created by Eric Schofield on 8/2/20.
//  Copyright © 2020 Eric Schofield. All rights reserved.
//

import SwiftUI

class Expenses: ObservableObject {
    @Published var items: [ExpenseItem] {
        didSet {
            let encoder = JSONEncoder()
            if let encodedItems = try? encoder.encode(items) {
                UserDefaults.standard.set(encodedItems, forKey: "ExpenseItems")
            }
        }
    }
    
    init() {
        if let itemsData = UserDefaults.standard.data(forKey: "ExpenseItems") {
            let decoder = JSONDecoder()
            if let decodedItems = try? decoder.decode([ExpenseItem].self, from: itemsData) {
                self.items = decodedItems
                return
            }
        }
        
        self.items = []
    }
}
