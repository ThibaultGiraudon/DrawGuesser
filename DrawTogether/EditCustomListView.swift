//
//  EditCustomListView.swift
//  DrawTogether
//
//  Created by Thibault Giraudon on 25/05/2024.
//

import SwiftUI

struct EditCustomListView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var matchManager: MatchManager
    @State private var newWord = ""
    @State private var showingDialogue = false
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                TextField("New word", text: $newWord)
                    .padding(.vertical, 20)
                    .padding(.horizontal)
                    .background(
                        Capsule(style: .circular)
                            .fill(.white)
                    )
                    .padding(.top)
                    .frame(width: UIScreen.main.bounds.width - 20)
                
                Button {
                    matchManager.addCustomWord(newWord: newWord)
                    newWord = ""
                } label: {
                    Text("Submit")
                        .font(.title)
                        .bold()
                        .foregroundStyle(.white)
                        .padding(.vertical, 20)
                        .frame(width: UIScreen.main.bounds.width - 20)
                        .background(
                            Capsule(style: .circular)
                                .fill(.primaryYellow)
                        )
                }
                .disabled(newWord.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                
                Spacer()
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(matchManager.customList, id: \.self) { item in
                        Text(item)
                            .font(.title)
                            .bold()
                            .foregroundStyle(.white)
                            .padding()
                            .contextMenu {
                                Button(role: .destructive) {
                                    matchManager.deleteCustomWord(word: item)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                .foregroundStyle(.red)
                            }
                    }
                }
                .padding(.top)
                .frame(maxWidth: .infinity)
                .background(
                    Color.secondary
                )
                .clipShape(
                    RoundedRectangle(cornerRadius: 20)
                )
                .padding()
            }
            .background(
                .blue
            )
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrowshape.turn.up.backward.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.primaryYellow)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingDialogue = true
                    } label: {
                        Image(systemName: "info.circle.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.primaryYellow)
                    }
                }
            }
            .confirmationDialog("Instruction", isPresented: $showingDialogue) {
                
            } message: {
                Text("You will need a least 10 custom word to us them in game.")
            }
        }
    }
}

#Preview {
    EditCustomListView(matchManager: MatchManager())
}
