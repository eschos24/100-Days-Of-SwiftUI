//
//  AddView.swift
//  iExpense
//
//  Created by Eric Schofield on 8/2/20.
//  Copyright © 2020 Eric Schofield. All rights reserved.
//

import SwiftUI

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var expenses: Expenses
    
    @State private var name = ""
    @State private var type = types[0]
    @State private var amount = ""
    
    @State private var alertShowing = false
    @State private var alertTitle = "Unable to Save"
    @State private var alertMessage = ""
    
    private static let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }
            .navigationBarTitle("Add new expense")
            .navigationBarItems(leading:
                Button("Cancel") {
                    self.presentationMode.wrappedValue.dismiss()
                }, trailing:
                Button("Save") {
                    self.saveExpense()
                }
            )
        }
        .alert(isPresented: $alertShowing) { () -> Alert in
            Alert(title: Text(alertTitle),
                  message: Text(alertMessage.trimmingCharacters(in: .whitespacesAndNewlines)),
                  dismissButton: .default(Text("OK")))
        }
    }
    
    func saveExpense() {
        alertMessage = ""
        
        if name.count == 0 {
            alertShowing = true
            alertMessage += "\n• Must include a name"
        }
        
        if amount.count == 0 {
            alertShowing = true
            alertMessage += "\n• Must include an amount"
        } else if let amt = Int(amount), amt <= 0 {
            alertShowing = true
            alertMessage += "\n• Amount must be greater than 0"
        } else if Int(amount) == nil {
            alertShowing = true
            alertMessage += "\n• Amount must be a whole number"
        }
        
        guard let amt = Int(self.amount), !alertShowing else {
            return
        }
        
        let item = ExpenseItem(name: name,
                               type: type,
                               amount: amt)
        
        self.expenses.items.append(item)
        
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
