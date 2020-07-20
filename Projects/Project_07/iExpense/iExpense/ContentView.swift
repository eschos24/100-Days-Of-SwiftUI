//
//  ContentView.swift
//  iExpense
//
//  Created by Eric Schofield on 7/19/20.
//  Copyright © 2020 Eric Schofield. All rights reserved.
//

import SwiftUI

struct User: Codable {
	var firstName: String
	var lastName: String
}


struct ContentView: View {
	@State private var numbers = UserDefaults.standard.array(forKey: "numbers") as? [Int] ?? [Int]()
	@State private var currentNumber = 1
	
	@State private var user = User(firstName: "Natalie", lastName: "Portman")
	
    var body: some View {
		VStack {
			Text("Hello, \(user.firstName) \(user.lastName)")
			Button("Save") {
				let encoder = JSONEncoder()
				
				if let data = try? encoder.encode(self.user) {
					UserDefaults.standard.set(data, forKey: "UserData")
				}
			}
		}
//		NavigationView {
//			VStack {
//				List {
//					ForEach(numbers, id: \.self) {
//						Text("\($0)")
//					}
//				.onDelete(perform: removeRows)
//				}
//
//				Button("Add Number") {
//					self.numbers.append(self.currentNumber)
//					self.currentNumber += 1
//
//					UserDefaults.standard.set(self.numbers, forKey: "numbers")
//				}
//			}
//		.navigationBarItems(leading: EditButton())
//		}
    }
	
	func removeRows(at offsets: IndexSet) {
		numbers.remove(atOffsets: offsets)
		UserDefaults.standard.set(self.numbers, forKey: "numbers")
	}
}

struct SecondView: View {
	@Environment (\.presentationMode) var presentationMode
	
	var name: String
	
	var body: some View {
		VStack {
			Text("Hello, \(name)")
			Button("Dismiss") {
				self.presentationMode.wrappedValue.dismiss()
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
