//
//  ContentView.swift
//  iExpense
//
//  Created by Eric Schofield on 8/2/20.
//  Copyright © 2020 Eric Schofield. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var total: Int {
        return expenses.items.reduce(0) { (total, item) in
            total + item.amount
        }
    }
    
    var body: some View {
        NavigationView {
            Group {
                List {
                    ForEach(expenses.items) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                                    .font(.subheadline)
                            }
                            
                            Spacer()
                            Text("$\(item.amount)")
                                .foregroundColor(self.color(for: item.amount))
                        }
                    }
                    .onDelete(perform: removeItems)
                }
                HStack {
                    Text("Total: $\(total)")
                        .padding(.leading, 20)
                        .font(.title)
                    Spacer()
                }
            }
            .navigationBarTitle("iExpenses")
            .navigationBarItems(leading:
                Button(action: {
                    self.showingAddExpense = true
                }) {
                    Image(systemName: "plus")
                }, trailing: EditButton()
            )
        }
        .sheet(isPresented: $showingAddExpense) {
            AddView(expenses: self.expenses)
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    
    func color(for amount: Int) -> Color {
        if amount < 10 {
            return .secondary
        } else if amount < 100 {
            return .primary
        } else {
            return .red
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let cv = ContentView()
        cv.expenses.items = [ExpenseItem(name: "First", type: "Business", amount: 20),
                             ExpenseItem(name: "Second", type: "Personal", amount: 123),
                             ExpenseItem(name: "Third", type: "Business", amount: 8)]
        
        return cv
    }
}
