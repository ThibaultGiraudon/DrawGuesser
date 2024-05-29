//
//  MenuView.swift
//  DrawTogether
//
//  Created by Thibault Giraudon on 25/05/2024.
//

import SwiftUI

struct MenuView: View {
    
    @ObservedObject var matchManager: MatchManager
    @State private var showingCustomList = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Image(.drawGuesser)
                    .resizable()
                    .scaledToFit()
                    .padding(30)
                
                Spacer()
                
                Button {
                    matchManager.startMatchMaking()
                } label: {
                    Text("Play")
                        .foregroundStyle(.white)
                        .font(.largeTitle)
                        .bold()
                        .padding(.vertical, 20)
                        .padding(.horizontal, 100)
                        .background(
                            Capsule(style: .circular)
                                .fill(matchManager.authenticationState != .authenticated || matchManager.inGame ? .gray : .playBtn)
                        )
                }
                .disabled(matchManager.authenticationState != .authenticated || matchManager.inGame)
                
                Text(matchManager.authenticationState.rawValue)
                    .font(.footnote)
                    .foregroundStyle(.primaryYellow)
                    .padding()
                
                NavigationLink {
                    EditCustomListView(matchManager: matchManager)
                } label: {
                    Text("Custom List")
                        .foregroundStyle(.primaryYellow)
                        .brightness(-0.2)
                        .font(.largeTitle)
                        .bold()
                        .padding(.vertical, 20)
                        .padding(.horizontal, 30)
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
            .sheet(isPresented: $showingCustomList, content: {
                EditCustomListView(matchManager: matchManager)
            })
            .onAppear(perform: {
                matchManager.loadData()
            })
        }
    }
}

#Preview {
    MenuView(matchManager: MatchManager())
}
