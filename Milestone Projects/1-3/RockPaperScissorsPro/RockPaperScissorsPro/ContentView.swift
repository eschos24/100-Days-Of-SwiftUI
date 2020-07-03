//
//  ContentView.swift
//  RockPaperScissorsPro
//
//  Created by Eric Schofield on 6/12/20.
//  Copyright © 2020 Eric Schofield. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	private let moves = ["Rock", "Paper", "Scissors"]
	
	@State private var currentMove = Int.random(in: 0...2)
	@State private var shouldWin = Bool.random()
	@State private var turnsRemaining = 10
	@State private var score = 0
	@State private var showingFinalScore = false
	
	
	private func moveTapped(_ selection: Int) {
		let correct: Bool
		
		switch currentMove {
		case 0:
			correct = shouldWin ? selection == 1 : selection == 2
		case 1:
			correct = shouldWin ? selection == 2 : selection == 0
		case 2:
			correct = shouldWin ? selection == 0 : selection == 1
		default:
			correct = false
		}
		
		score += correct ? 1 : -1
		
		resetSelection()
		
		turnsRemaining -= 1
		if turnsRemaining == 0 {
			showingFinalScore = true
		}
	}
	
	func resetSelection() {
		currentMove = Int.random(in: 0...2)
		shouldWin = Bool.random()
	}
	
	func newGame() {
		resetSelection()
		turnsRemaining = 10
		score = 0
		showingFinalScore = false
	}
	
	var body: some View {
		VStack(spacing: 40) {
			Text("Score: \(score)")
				.font(.title)
			
			Text(moves[currentMove])
				.frame(minWidth: 150)
				.font(.largeTitle)
				.foregroundColor(.white)
				.padding(40)
				.background(Color.blue)
				.clipShape(RoundedRectangle(cornerRadius: 20))
			Text("Try to... \(shouldWin ? "Win" : "Lose")")
				.font(.title)
			
			Spacer()
			
			VStack(alignment: .center, spacing: 20) {
				ForEach(0..<moves.count) { move in
					Button(action: {
						// Check if the selected option won or lost.
						// Update score
						// Update view with new values
						self.moveTapped(move)
					}) {
						Text(self.moves[move])
							.font(.largeTitle)
							.foregroundColor(.black)
					}
					.frame(minWidth: 150)
					.padding(.horizontal, 20)
					.padding(.vertical, 4)
					.background(Color.orange)
					.clipShape(Capsule())
					.overlay(Capsule().stroke(Color.black, lineWidth: 2))
				}
			}
			
			Spacer()
		}
		.alert(isPresented: $showingFinalScore) { () -> Alert in
			Alert(title: Text("Game Over"),
				  message: Text("Final score: \(score)"),
				  dismissButton: .default(Text("New game"), action: {
				self.newGame()
			}))
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
