//
//  ButtonView.swift
//  DrawTogether
//
//  Created by Thibault Giraudon on 27/05/2024.
//

import SwiftUI

struct ButtonView: View {
    @ObservedObject var matchManager: MatchManager
    let drawingList: [String]
    let title: String
    var body: some View {
        Button {
            matchManager.selectedList = drawingList
        } label: {
            Text(title)
                .foregroundStyle(.secondary)
                .font(.largeTitle)
                .bold()
                .frame(width: UIScreen.main.bounds.width - 20)
                .padding(.vertical, 20)
                .background(
                    Capsule(style: .circular)
                        .fill(matchManager.selectedList == drawingList ? .primaryGray : .white)
                )
        }
    }
}

#Preview {
    ButtonView(matchManager: MatchManager(), drawingList: everydayObjects, title: "Everyday objects")
}
