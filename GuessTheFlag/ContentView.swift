//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Ростислав Гайда on 20.04.2026.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var isGameOver = false
    @State private var scoreTitle = ""
    @State private var score = Int()
    @State private var questionCount = 1
    @State private var degreesAmount = [0.0, 0.0, 0.0]
    @State private var correctFlag: Int? = nil
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .yellow], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                VStack(spacing: 30) {
                    Text("Guess the Flag")
                        .modifier(Title())
                    Text("Question: \(questionCount) of 8")
                        .font(.title.weight(.semibold))
                        .foregroundStyle(.white)
                    Text("Score: \(score) ")
                        .foregroundStyle(.white)
                        .font(.title)
                }
                Spacer()
                VStack(spacing: 20) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                            withAnimation(.bouncy(duration: 0.7, extraBounce: 0.2)) {
                                degreesAmount[number] += 360
                            }
                        }label: {
                            FlagImage(country: countries[number])
                                .rotation3DEffect(
                                    .degrees(degreesAmount[number]),
                                    axis: (x: 0, y: 1, z: 0))
                                .opacity(correctFlag != nil && correctFlag != number ? 0.25 : 1)
                                .scaleEffect(correctFlag == number ? 1.2 : 1)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                Spacer()
            }
            .padding()
        }
        
        .alert(scoreTitle, isPresented: $showingScore) {
            if isGameOver {
                Button("Restart", action: restartGame)
            } else {
                Button("Continue", action: askQuestion)
            }
        }
    }
    
    func flagTapped(_ number: Int) {
        correctFlag = number
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
            questionCount += 1
            if questionCount == 9 {
                questionCount -= 1
                isGameOver = true
                scoreTitle = "Final score: \(score)"
            } else {
                isGameOver = false
            }
        } else {
            scoreTitle = "Wrong! That’s the flag of: \(countries[correctAnswer])"
            questionCount += 1
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        correctFlag = nil
    }
    
    func restartGame() {
        score = 0
        questionCount = 1
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        }
    }

struct FlagImage: View {
    
    var country: String
    
    var body: some View {
        Image(country)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.weight(.bold))
            .foregroundStyle(.white)
    }
}


#Preview {
    ContentView()
}
