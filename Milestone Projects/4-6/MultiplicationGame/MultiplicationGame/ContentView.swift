//
//  ContentView.swift
//  MultiplicationGame
//
//  Created by Eric Schofield on 6/23/20.
//  Copyright © 2020 Eric Schofield. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	@State private var selectedMultiplicationTable = 1
	@State private var numQuestionsSelection = 1
	@State private var gameStarted = false
	
	@State private var firstNumber = 0
	@State private var secondNumber = 0
	
	private var questionAmounts = ["5", "10", "20", "All"]
	@State private var questions = [Question]()
	@State private var currentQuestion = 0
	
	@State private var answer = ""
	@State private var correctAnswers = 0
	@State private var endGameAlertShowing = false
	
	var body: some View {
		NavigationView {
			Group {
				if gameStarted {
					VStack {
						Text(currentQuestion < questions.count ? "\(questions[currentQuestion].first) x \(questions[currentQuestion].second) = ?" : "Game Over!")
							.font(.largeTitle)
						TextField("Answer", text: $answer, onCommit: answerQuestion)
							.keyboardType(.numberPad)
							.multilineTextAlignment(.center)
							.frame(width: 80, alignment: .center)
							.textFieldStyle(RoundedBorderTextFieldStyle())
							.animation(.default)
						Spacer()
					}
				} else {
					Form {
						Section(header: Text("Setup Game")) {
							Stepper(value: $selectedMultiplicationTable, in: 1...12) {
								Text("Up to...\(selectedMultiplicationTable)")
							}
							
							Picker("Number of questions", selection: $numQuestionsSelection) {
								ForEach(0 ..< questionAmounts.count) {
									Text(self.questionAmounts[$0])
								}
							}
							.pickerStyle(SegmentedPickerStyle())
						}
						
						HStack {
							Spacer()
							Button(action: {
								self.startGame()
							}) {
								Text("Start")
							}
							Spacer()
						}
					}
				}
			}
			.navigationBarTitle(gameStarted ? "" : "Multiplication")
			.navigationBarItems(trailing: gameStarted ?
				Button(action: {
					self.gameStarted = false
				}) {
					Text("End")
				} : nil)
			.alert(isPresented: $endGameAlertShowing) {
				Alert(title: Text("Game Over"),
					  message: Text("You answered \(self.correctAnswers) out of \(self.questions.count) questions correctly!"),
					primaryButton: .cancel(Text("OK"), action: {
						self.endGameAlertShowing = false
						self.gameStarted = false
					}),
					secondaryButton: .default(Text("Play again"), action: {
						self.endGameAlertShowing = false
						self.startGame()
					}))
			}
		}
	}
	
	func startGame() {
		correctAnswers = 0
		currentQuestion = 0
		gameStarted = true
		
		var possibleQuestions = [Question]()
		for number in 1 ... selectedMultiplicationTable {
			for secondNumber in 1 ... 12 {
				let q = Question(first: number, second: secondNumber)
				possibleQuestions.append(q)
			}
		}
		
		possibleQuestions.shuffle()
		
		questions.removeAll()
		if let amount = Int(questionAmounts[numQuestionsSelection]),
			amount < possibleQuestions.count {
			questions.append(contentsOf: possibleQuestions[0..<amount])
		} else {
			questions = possibleQuestions
		}
	}
	
	func answerQuestion() {
		if let number = Int(answer),
			number == questions[currentQuestion].answer {
			correctAnswers += 1
		}
		
		answer = ""
		currentQuestion += 1
		
		if currentQuestion >= questions.count {
			endGameAlertShowing = true
		}
	}
}

struct Question {
	private(set) var first: Int
	private(set) var second: Int
	var answer: Int {
		return first * second
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView()
    }
}
