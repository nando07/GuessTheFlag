//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Fernando Gomez on 1/4/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var questionNumber = 0
    @State private var reset = false
    @State private var isRotating = 0.0
    @State private var animationAmount = 0.0
    @State private var selectedButton : Int?
    let buttons = ["Button 1", "Button 2", "Button 3"]
        @State private var rotate = Array(repeating: false, count: 3)
    
   @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
     
   @State private var correctAnswer = Int.random(in: 0...2)
    
    var body: some View {
        
        ZStack {
            
            RadialGradient(stops: [.init(color: Color(red:0.1, green: 0.2, blue: 0.45), location: 0.3),
                                   .init(color: Color(red:0.76, green: 0.15, blue: 0.26), location: 0.3)], center: .top, startRadius: 200, endRadius: 700)
            
            
            .ignoresSafeArea()
            
            VStack{
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                VStack (spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                        
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            selectedButton = number
//                            flagTapped(number)
                            withAnimation(.interpolatingSpring(stiffness: 8, damping: 3)) {
                                self.rotate[number].toggle()
                                  
                                flagTapped(number)
                                
                            }
                        }
                        
                    
                    label:
                        {
                            FlagImage(country: countries[number])
                        }
                        
            
                        .rotation3DEffect(.degrees(self.rotate[number] ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                        .opacity(number == self.selectedButton ? 1 : 0.30)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                Text("Tries: " + "\(questionNumber)")
                
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
                Text("Score: " + "\(score)")
                
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
        }
            .alert(scoreTitle, isPresented: $showingScore) {
                Button("Continue", action: askQuestion)
                
            } message: {
                Text("Your score is " + "\(score)")
            }

            .alert("You reached the end!", isPresented: $reset) {
                Button("Reset", action: resetGame)
              }

    }
       
    func flagTapped(_ number: Int) {
       
        questionNumber += 1
        
            if number == correctAnswer {
                scoreTitle = "Correct!"
                score += 1
                
            } else {
                scoreTitle = "Wrong! " + "That is the flag of \(countries[number])"
                if score > 0 {
                    score -= 1
                }
                
            }
        showingScore = true
    }
    
    func askQuestion() {
        
        if questionNumber == 8 {
            reset = true
        } else {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
        }
    }
    
    func resetGame() {
        reset = false
        showingScore = false
        score = 0
        questionNumber = 0
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}


struct FlagImage: View {

    var country: String

    var body: some View {
        Image(country)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
