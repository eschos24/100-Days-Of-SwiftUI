//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Eric Schofield on 6/9/20.
//  Copyright © 2020 Eric Schofield. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	@State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
	@State private var correctAnswer = Int.random(in: 0...2)
	@State private var currentScore = 0
	@State private var showingScore = false
	@State private var scoreTitle = ""
	
	@State private var spinAnimationAmount = 0.0
	@State private var otherOpacity = 1.0
	@State private var selectedNumber: Int?
	
	
	var body: some View {
		ZStack {
			LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
			VStack(spacing: 32) {
				VStack(spacing: 8) {
					Text("Tap the flag of")
						.foregroundColor(.white)
						.font(.title)
					
					Text(countries[correctAnswer])
						.foregroundColor(.white)
						.font(.largeTitle)
						.fontWeight(.black)
				}
				
				ForEach(0 ..< 3) { number in
					Button(action: {
						self.flagTapped(number)
					}) {
						FlagImage(imageName: self.countries[number])
					}
					.modifier(ShakeEffect(amount: self.numberOfShakes(for: number)))
					.animation(self.selectedNumber != nil ? Animation.default : nil)
					.rotation3DEffect(
						.degrees(number == self.correctAnswer
							? self.spinAnimationAmount : 0),
						axis: (x: 0, y: 1, z: 0))
					.animation(self.selectedNumber != nil ? .easeInOut(duration: 1) : nil)
					.opacity(number == self.correctAnswer ? 1.0 : self.otherOpacity)
					.animation(.easeInOut(duration: 1))
				}
				
				Spacer()
				
				Text("Score: \(currentScore)")
					.foregroundColor(.white)
					.font(.title)
			}
		}
//		.alert(isPresented: $showingScore) {
//			Alert(title: Text(scoreTitle),
//				  dismissButton: .default(Text("Continue")) {
//				self.askQuestion()
//				})
//		}
	}
	
	func flagTapped(_ number: Int) {
		selectedNumber = number
		
		if number == correctAnswer {
			scoreTitle = "Correct"
			currentScore += 1
			
			spinAnimationAmount = 360
			otherOpacity = 0.25
		} else {
			scoreTitle = "Wrong!\nThat's the flag of \(countries[number])"
			
			otherOpacity = 0.25
		}
		
		showingScore = true
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
			self.askQuestion()
			
			withAnimation(.default) {
				self.otherOpacity = 1
			}
		}
	}
	
	func numberOfShakes(for number: Int) -> CGFloat {
		if let selected = selectedNumber,
			selected == number,
			number != correctAnswer {
			return 2
		}
		
		return 0
	}
	
	func askQuestion() {
		countries.shuffle()
		correctAnswer = Int.random(in: 0...2)
		
		selectedNumber = nil
		spinAnimationAmount = 0
	}
}

struct FlagImage: View {
	var imageName: String
	
	var body: some View {
		Image(imageName)
			.renderingMode(.original)
			.clipShape(Capsule())
			.overlay(Capsule().stroke(Color.black, lineWidth: 1))
			.shadow(color: .black, radius: 2)
	}
}

struct ShakeEffect: GeometryEffect {
	var amount: CGFloat
	var animatableData: CGFloat {
		get { amount }
		set { amount = newValue }
	}
	
	func effectValue(size: CGSize) -> ProjectionTransform {
		ProjectionTransform(CGAffineTransform(translationX: -20 * sin(amount * 2 * .pi), y: 0))
	}
	
	
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
