//
//  WaitingView.swift
//  DrawTogether
//
//  Created by Thibault Giraudon on 25/05/2024.
//

import SwiftUI

struct WaitingView: View {
    var body: some View {
        VStack {
            Spacer()
            ProgressView()
                .scaleEffect(8)
                .tint(.primaryYellow)
                .padding(50)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(
            .blue
        )
    }
}

#Preview {
    WaitingView()
}
