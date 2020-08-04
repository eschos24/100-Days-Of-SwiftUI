//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Eric Schofield on 8/2/20.
//  Copyright © 2020 Eric Schofield. All rights reserved.
//

import Foundation

struct ExpenseItem: Codable, Identifiable {
    let id = UUID()
    let name: String
    let type: String
    let amount: Int
}
