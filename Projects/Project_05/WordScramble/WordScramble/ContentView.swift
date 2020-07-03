//
//  ContentView.swift
//  WordScramble
//
//  Created by Eric Schofield on 6/15/20.2
//  Copyright © 200 Eric Schofield. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	
	// MARK: - @State
	@State var usedWords = [String]()
	@State var rootWord = ""
	@State var newWord = ""
	@State var currentScore = 0
	
	@State var errorTitle = ""
	@State var errorMessage = ""
	@State var showingError = false
	
	
	// MARK: - Body
	
    var body: some View {
		NavigationView {
			VStack {
				HStack {
					Spacer()
					Text("Score: \(currentScore)")
						.font(.title)
						.padding(.trailing)
				}
				
				TextField("Enter your word", text: $newWord, onCommit: addNewWord)
					.textFieldStyle(RoundedBorderTextFieldStyle())
					.padding()
					.autocapitalization(.none)
					.disableAutocorrection(true)
				
				List(usedWords, id: \.self) {
					Image(systemName: "\(self.points(for: $0)).square")
					.imageScale(.large)
					Text($0)
						.padding(.leading)
					Spacer()
					Image(systemName: "\($0.count).circle")
					.imageScale(.medium)
				}
			}
			.navigationBarTitle(Text(rootWord))
			.navigationBarItems(trailing: Button(action: startGame) {
				Text("Start")
			})
			.onAppear(perform: startGame)
			.alert(isPresented: $showingError) {
				Alert(title: Text(errorTitle),
					  message: Text(errorMessage),
					  dismissButton: .default(Text("OK")))
			}
		}
	}
	
	// MARK: - Helper methods
	
	private func startGame() {
		guard let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"),
			let startWords = try? String(contentsOf: startWordsURL) else {
				fatalError("Could not load start.txt from bundle")
		}
		
		let words = startWords.components(separatedBy: "\n")
		rootWord = words.randomElement() ?? "spiderman"
		currentScore = 0
		usedWords.removeAll()
	}
	
	private func endGame() {
		wordError(title: "Game Over", message: "You found \(usedWords.count) words for \(currentScore) points!")
	}
	
	private func addNewWord() {
		let word = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
		
		guard word.count > 0 else {
			return
		}
		
		guard isOriginal(word: word) else {
			wordError(title: "Word used already",
					  message: "Be more original!")
			return
		}
		
		guard isPossible(word: word) else {
			wordError(title: "Word not possible", message: "Make sure you only use each letter from the word shown above one time.")
			return
		}
		
		guard isReal(word: word) else {
			wordError(title: "Word not recognized",
					  message: "Creative...but try using words from a dictionary next time!")
			return
		}
		
		guard isValid(word: word) else {
			wordError(title: "Invalid word", message: "Words must be at least 3 letters and cannot be the same as the original word")
			return
		}
		
		currentScore += points(for: word)
		usedWords.insert(word, at: 0)
		newWord = ""
	}
	
	private func isOriginal(word: String) -> Bool {
		return !usedWords.contains(word)
	}
	
	private func isPossible(word: String) -> Bool {
		var tempRoot = rootWord
		
		for letter in word {
			if let pos = tempRoot.firstIndex(of: letter) {
				tempRoot.remove(at: pos)
			} else {
				return false
			}
		}
		
		return true
	}
	
	private func isReal(word: String) -> Bool {
		let checker = UITextChecker()
		let range = NSRange(location: 0, length: word.count)
		
		let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
		
		return misspelledRange.location == NSNotFound
	}
	
	private func isValid(word: String) -> Bool {
		return word.count >= 3 && word != rootWord
	}
	
	private func points(for word: String) -> Int {
		switch word.count {
		case 3...4:
			return 1
		case 5:
			return 2
		case 6:
			return 3
		case 7:
			return 5
		default:
			return 11
		}
	}
	
	private func wordError(title: String, message: String) {
		errorTitle = title
		errorMessage = message
		showingError = true
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
