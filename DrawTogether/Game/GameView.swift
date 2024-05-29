//
//  GameView.swift
//  DrawTogether
//
//  Created by Thibault Giraudon on 25/05/2024.
//

import SwiftUI

var countdownTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

struct GameView: View {
    @ObservedObject var matchManager: MatchManager
    @State private var drawingGuess = ""
    @State private var eraserEnabled = false
    @State private var selectedColor: UIColor = .black
    let colors: [UIColor] = [.black, .purple, .blue, .green, .yellow, .orange, .red, .white, .gray, .brown]
    @State private var lineWidth: CGFloat = 5
    
    var body: some View {
        VStack {
            topBar
                .padding(.horizontal)
                .frame(height: UIScreen.main.bounds.height * 0.05)
            VStack {
                GeometryReader { _ in
                    VStack {
                        ZStack(alignment: .top) {
                            DrawingView(matchManager: matchManager, eraserEnabled: $eraserEnabled, color: $selectedColor, lineWidth: $lineWidth)
                                .frame(height: UIScreen.main.bounds.height * 0.5)
                            
                            if matchManager.currentlyDrawing {
                                VStack {
                                    HStack {
                                        colorsButton
                                        Spacer()
                                        
                                        Button {
                                            eraserEnabled.toggle()
                                        } label: {
                                            Image(systemName: eraserEnabled ? "eraser.fill" : "eraser")
                                                .font(.title)
                                                .foregroundStyle(.purple)
                                                .padding(.top, 10)
                                        }
                                    }
                                    
                                    HStack {
                                        Slider(value: $lineWidth, in: 1...25)
                                        Circle()
                                            .frame(height: lineWidth)
                                    }
                                }
                                .padding()
                                .background(.primaryGray)
                            }
                        }
                        .frame(height: UIScreen.main.bounds.height * 0.5)
                        pastGuesses
                            .frame(height: UIScreen.main.bounds.height * 0.20)
                    }
                }
            }
                
            VStack {
                Spacer()
                promptGroup
                    .frame(height: UIScreen.main.bounds.height * 0.1)
                    .padding(.bottom, 30)
            }
            .ignoresSafeArea(.container)
        }
        .padding(.top, 50)
        .background(matchManager.currentlyDrawing ? .blue : .green)
        .ignoresSafeArea()
        .onReceive(countdownTimer) { _ in
            guard matchManager.isTimeKeeper else { return }
            matchManager.remainingTime -= 1
        }
    }
    
    func makeGuess() {
        guard drawingGuess != "" else { return }
        
        matchManager.sendString("guess:\(drawingGuess.trimmingCharacters(in: .whitespacesAndNewlines).removeAccents())")
        drawingGuess = ""
    }
    
    @ViewBuilder
    var colorsButton: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(colors, id: \.self) { color in
                    Button {
                        selectedColor = color
                        eraserEnabled = false
                    } label: {
                        Image(systemName: selectedColor == color ? "pencil.tip.crop.circle.fill" : "pencil.tip.crop.circle")
                            .font(.title2)
                            .foregroundStyle(Color(color))
                            .padding(.top, 10)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    var topBar: some View {
        ZStack {
            HStack {
                Spacer()
                
                Label("\(matchManager.remainingTime)", systemImage: "clock.fill")
                    .bold()
                    .font(.title2)
                    .foregroundStyle(matchManager.currentlyDrawing ? .purple : .purple)
            }
            Text("Score: \(matchManager.score)")
                .bold()
                .font(.title2)
                .foregroundStyle(matchManager.currentlyDrawing ? .purple : .purple)
        }
        .padding(.vertical, 15)
    }
    
    @ViewBuilder
    var pastGuesses: some View {
        ScrollView {
            ScrollViewReader { value in
                ForEach(matchManager.pastGuesses) { guess in
                    HStack {
                        Text(guess.message)
                            .font(.title2)
                            .bold()
                        
                        if guess.correct {
                            Image(systemName: "hand.thubsup.fill")
                                .foregroundStyle(matchManager.currentlyDrawing
                                                 ? Color(red: 0.808, green: 0.345, blue: 0.776)
                                                 : Color(red: 0.243, green: 0.773, blue: 0.745)
                                )
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .onChange(of: matchManager.pastGuesses.count) {
                    value.scrollTo(matchManager.pastGuesses.count - 1)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            .secondary
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 20)
        )
        .padding(.vertical)
    }
    
    @ViewBuilder
    var promptGroup: some View {
        VStack {
            if matchManager.currentlyDrawing {
                Label("DRAW:", systemImage: "exclamationmark.bubble.fill")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.white)
                Text(matchManager.drawPrompt.uppercased())
                    .font(.largeTitle)
                    .bold()
                    .padding(10)
                    .foregroundStyle(.primaryPurple)
            } else {
                HStack {
                    Label("GUESS THE DRAWING!", systemImage: "exclamationmark.bubble.fill")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.purple)
                }
                HStack {
                    TextField("Type your guess", text: $drawingGuess)
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                        .padding()
                        .background(
                            Capsule(style: .circular)
                                .fill(.white)
                        )
                        .onSubmit {
                            makeGuess()
                        }
                    
                    Button {
                        makeGuess()
                    } label: {
                        Image(systemName: "chevron.right.circle.fill")
                            .renderingMode(.original)
                            .font(.system(size: 50))
                            .foregroundStyle(.purple)
                    }
                }
            }
        }
        .padding(.bottom, 10)
        .frame(maxWidth: .infinity)
        .padding([.horizontal], 30)
        .padding(.top)
        .background(
            .secondary
        )
    }
}

#Preview {
    GameView(matchManager: MatchManager())
}
