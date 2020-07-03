//
//  ContentView.swift
//  BetterRest
//
//  Created by Eric Schofield on 6/14/20.
//  Copyright © 2020 Eric Schofield. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	@State var wakeUp = defaultWakeTime
	@State var sleepAmount = 8.0
	@State var coffeeAmount = 1
	@State var alertTitle = "Error"
	@State var alertMessage = "Sorry, there was a problem calculating your bedtime"
	@State var showingAlert = false
	
	static private var defaultWakeTime: Date {
		var components = DateComponents()
		components.hour = 7
		components.minute = 0
		
		return Calendar.current.date(from: components) ?? Date()
	}
	
	var body: some View {
		NavigationView {
			Form {
				Section(header: Text("What time do you want to wake up?")) {
					
					DatePicker("Wake up time", selection: $wakeUp, displayedComponents: .hourAndMinute)
				}
				
				Section(header: Text("Desired amount of sleep")) {
					Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
						Text("\(sleepAmount, specifier: "%g") hours")
					}
				}
				
				Section(header: Text("Daily coffee intake")) {
					Picker("Number of cups", selection: $coffeeAmount) {
						ForEach(0..<21) {
							if $0 == 1 {
								Text("1 cup")
							} else {
								Text("\($0) cups")
							}
						}
					}
				}
				
				Section(header: Text("Ideal bedtime")) {
					Text("Go to bed at \(calculateBedtime())")
						.font(.title)
				}
			}
			.navigationBarTitle("Better Rest")
				.alert(isPresented: $showingAlert) {
					Alert(title: Text(alertTitle),
						  message: Text(alertMessage),
						  dismissButton: .default(Text("OK")))
			}
		}
	}
	
	
	private func calculateBedtime() -> String {
		let model = SleepCalculator()
		
		let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
		let hour = (components.hour ?? 0) * 60 * 60
		let minute = (components.minute ?? 0) * 60
		
		do {
			let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
			let sleepTime = wakeUp - prediction.actualSleep
			
			let formatter = DateFormatter()
			formatter.timeStyle = .short
			
			return formatter.string(from: sleepTime)
		} catch {
			showingAlert = true
			return "Error"
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
