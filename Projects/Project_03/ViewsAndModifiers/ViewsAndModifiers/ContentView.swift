//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Eric Schofield on 6/10/20.
//  Copyright © 2020 Eric Schofield. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	var body: some View {
		NavigationView {
			VStack {
				Text("Title")
					.prominent()
				Spacer()
				GridStack(rows: 4, columns: 4) { row, column in
					Image(systemName: "\(row * 4 + column).circle")
						.font(.largeTitle)
					Text("[\(row), \(column)]")
				}
			}
			.navigationBarTitle(Text("Grid Stack"))
		}
	}
}

struct Watermark: ViewModifier {
	var text: String
	
	func body(content: Content) -> some View {
		ZStack(alignment: .bottomTrailing) {
			content
			Text(text)
				.font(.caption)
				.foregroundColor(.white)
				.padding(5)
				.background(Color.black)
		}
	}
}

struct ProminentTitle: ViewModifier {
	func body(content: Content) -> some View {
		content
			.foregroundColor(.blue)
			.font(.largeTitle)
	}
}

struct CapsuleView: View {
	var text: String
	
	var body: some View {
		Text(text)
			.font(.largeTitle)
			.padding()
//			.foregroundColor(.white)
			.background(Color.blue)
			.clipShape(Capsule())
	}
}

struct Title: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(.largeTitle)
			.foregroundColor(.white)
			.padding()
			.background(Color.blue)
			.clipShape(RoundedRectangle(cornerRadius: 10))
	}
}

struct GridStack<Content: View>: View {
	let rows: Int
	let columns: Int
	let content: (Int, Int) -> Content
	
	init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
		self.rows = rows
		self.columns = columns
		self.content = content
	}
	
	var body: some View {
		VStack {
			ForEach(0..<rows, id: \.self) { row in
				HStack {
					ForEach(0..<self.columns, id:  \.self) { column in
						self.content(row, column)
					}
				}
			}
		}
	}
}

extension View {
	func titleStyle() -> some View {
		self.modifier(Title())
	}
	
	func watermarked(with text: String) -> some View {
		self.modifier(Watermark(text: text))
	}
	
	func prominent() -> some View {
		self.modifier(ProminentTitle())
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
