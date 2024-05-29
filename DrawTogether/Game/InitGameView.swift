//
//  InitGameView.swift
//  DrawTogether
//
//  Created by Thibault Giraudon on 25/05/2024.
//

import SwiftUI

struct InitGameView: View {
    @ObservedObject var matchManager: MatchManager
    @State private var showingAlert = false
    
    var body: some View {
        VStack {
            Spacer()
            
            ButtonView(matchManager: matchManager, drawingList: matchManager.everydayObjectList, title: "Everyday objects")
            
            ButtonView(matchManager: matchManager, drawingList: matchManager.animalsList, title: "Animals")
            
            ButtonView(matchManager: matchManager, drawingList: matchManager.customList, title: "Customs")
            
            Button {
                if (matchManager.selectedList.count < 10) {
                    showingAlert = true
                } else {
                    matchManager.startGame()
                }
            } label: {
                Text("Start")
                    .foregroundStyle(.primaryYellow)
                    .brightness(-0.2)
                    .font(.largeTitle)
                    .bold()
                    .padding(.vertical, 20)
                    .frame(width: UIScreen.main.bounds.width - 20)
                    .background(
                        Capsule(style: .circular)
                            .fill(.primaryYellow)
                    )
            }
            .alert("Error", isPresented: $showingAlert) {
                
            } message: {
                Text("You need at least 10 custom words to use them in game.")
            }

            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .ignoresSafeArea()
        .background(
            .blue
        )
    }
}

#Preview {
    InitGameView(matchManager: MatchManager())
}
