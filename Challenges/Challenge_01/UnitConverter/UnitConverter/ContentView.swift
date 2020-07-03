//
//  ContentView.swift
//  UnitConverter
//
//  Created by Eric Schofield on 6/5/20.
//  Copyright © 2020 Eric Schofield. All rights reserved.
//

import SwiftUI

struct ContentView: View {

	private let volumeUnits = [UnitVolume.milliliters,
							   UnitVolume.liters,
							   UnitVolume.cups,
							   UnitVolume.pints,
							   UnitVolume.gallons]
	
	@State private var convertFromUnit = 1
	@State private var convertToUnit = 2
	@State private var input = ""
	
	private func volumeString(unit: UnitVolume) -> String {
		switch unit {
		case .milliliters:
			return "Milliliters"
		case .liters:
			return "Liters"
		case .cups:
			return "Cups"
		case .pints:
			return "Pints"
		case .gallons:
			return "Gallons"
		default:
			return "<None>"
		}
	}
	
	private var output: String {
		let value = Double(input) ?? 0
		let volumeFrom = Measurement(value: value, unit: volumeUnits[convertFromUnit])
		let volumeConverted = volumeFrom.converted(to: volumeUnits[convertToUnit])
		
		let formatter = NumberFormatter()
		formatter.maximumFractionDigits = 2
		let measurementFormatter = MeasurementFormatter()
		measurementFormatter.numberFormatter = formatter
		measurementFormatter.unitStyle = .medium
		measurementFormatter.unitOptions = .providedUnit
		
		return measurementFormatter.string(from: volumeConverted)
	}
	
	var body: some View {
		NavigationView {
			Form {
				Section(header: Text("Convert From")) {
					Picker("Units", selection: $convertFromUnit) {
						ForEach(0 ..< volumeUnits.count) {
							Text(self.volumeString(unit: self.volumeUnits[$0]))
						}
					}
				.pickerStyle(SegmentedPickerStyle())
					TextField("Value to convert", text: $input)
				}
				
				Section(header: Text("Convert To")) {
					Picker("Units", selection: $convertToUnit) {
						ForEach(0 ..< volumeUnits.count) {
							Text(self.volumeString(unit: self.volumeUnits[$0]))
						}
					}
				.pickerStyle(SegmentedPickerStyle())
					
				Text(output)
				}
			}
		.navigationBarTitle("Volume Converter")
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
