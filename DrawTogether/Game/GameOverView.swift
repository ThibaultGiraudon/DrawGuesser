//
//  GameOverView.swift
//  DrawTogether
//
//  Created by Thibault Giraudon on 25/05/2024.
//

import SwiftUI

struct GameOverView: View {
    @ObservedObject var matchManager: MatchManager
    
    var body: some View {
        VStack {
            Spacer()
            
            Image(.gameOver)
                .resizable()
                .scaledToFit()
                .clipShape(
                    RoundedRectangle(cornerRadius: 20)
                )
                .padding(30)
            
            Text("Score: \(matchManager.score)")
                .font(.largeTitle)
                .bold()
                .foregroundStyle(.primaryYellow)
            
            Spacer()
            
            Button {
                matchManager.resetGame()
            } label: {
                Text("Menu")
                    .foregroundStyle(.primaryYellow)
                    .brightness(-0.4)
                    .font(.largeTitle)
                    .bold()
                    .padding()
                    .padding(.horizontal, 50)
                    .background(
                        Capsule(style: .circular)
                            .fill(.primaryYellow)
                    )
            }
            
            Spacer()
        }
        .background(
            .blue
        )
        .ignoresSafeArea()
    }
}

#Preview {
    GameOverView(matchManager: MatchManager())
}
