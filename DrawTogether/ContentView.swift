//
//  ContentView.swift
//  DrawTogether
//
//  Created by Thibault Giraudon on 25/05/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var matchManager = MatchManager()
    
    var body: some View {
        ZStack {
            if matchManager.isGameOver {
                GameOverView(matchManager: matchManager)
            } else if matchManager.waitingPage {
                WaitingView()
            } else if matchManager.initGame {
                InitGameView(matchManager: matchManager)
            } else if matchManager.inGame {
                GameView(matchManager: matchManager)
            } else {
                MenuView(matchManager: matchManager)
            }
        }
        .onAppear {
            matchManager.authenticateUser()
        }
    }
}

#Preview {
    ContentView()
}
