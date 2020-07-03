//
//  ContentView.swift
//  WeSplit
//
//  Created by Eric Schofield on 6/4/20.
//  Copyright © 2020 WriteSoft. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	@State private var checkAmount = ""
	@State private var numberOfPeople = ""
	@State private var tipPercentage = 2
	
	let tipPercentages = [10, 15, 20, 25, 0]
	
	private var students = ["Harry", "Hermione", "Ron"]
	
	private var subtotal: Double {
		
		let tipSelection = Double(tipPercentages[tipPercentage])
		let orderAmount = Double(checkAmount) ?? 0
		
		let tipValue = orderAmount * tipSelection / 100
		let subTotal = orderAmount + tipValue
		
		return subTotal
	}
	
	private var totalPerPerson: Double {
		let peopleCount = Double(numberOfPeople) ?? 1
		let amountPerPerson = subtotal / peopleCount
		
		return amountPerPerson
	}
	
    var body: some View {
		NavigationView {
			Form {
				Section {
					TextField("Amount", text: $checkAmount)
						.keyboardType(.decimalPad)
					TextField("Number of people", text: $numberOfPeople)
						.keyboardType(.decimalPad)
				}
				
				Section(header: Text("How much tip do you want to leave?")) {
					Picker("Tip percentage", selection: $tipPercentage) {
						ForEach(0 ..< tipPercentages.count)
						{
							Text("\(self.tipPercentages[$0])%")
						}
					}
					.pickerStyle(SegmentedPickerStyle())
				}
				
				Section(header: Text("Subtotal")) {
					Text("$\(subtotal, specifier: "%.2f")")
						.foregroundColor(tipPercentages[tipPercentage] == 0 ? .red : tipPercentages[tipPercentage] < 20 ? .orange : nil)
				}
				
				Section(header: Text("Amount per person")) {
					Text("$\(totalPerPerson, specifier: "%.2f")")
				}
			}
			.navigationBarTitle("WeSplit")
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
