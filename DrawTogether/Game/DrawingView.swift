//
//  DrawingView.swift
//  DrawTogether
//
//  Created by Thibault Giraudon on 25/05/2024.
//

import SwiftUI
import PencilKit

struct DrawingView: UIViewRepresentable {
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var matchManager: MatchManager
        
        init(matchManager: MatchManager) {
            self.matchManager = matchManager
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            guard canvasView.isUserInteractionEnabled else { return }
            
            matchManager.sendData(canvasView.drawing.dataRepresentation(), mode: .reliable)
        }
        
    }
    
    @ObservedObject var matchManager: MatchManager
    @Binding var eraserEnabled: Bool
    @Binding var color: UIColor
    @Binding var lineWidth: CGFloat
    
    func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = PKCanvasView()
//        canvasView.isOpaque = false
        canvasView.backgroundColor = .white
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(.marker, color: color, width: lineWidth)
        canvasView.delegate = context.coordinator
        canvasView.isUserInteractionEnabled = matchManager.currentlyDrawing
        
        return canvasView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(matchManager: matchManager)
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        let wasDrawing = uiView.isUserInteractionEnabled
        uiView.isUserInteractionEnabled = matchManager.currentlyDrawing
        
        if !wasDrawing && matchManager.currentlyDrawing {
            uiView.drawing = PKDrawing()
        }
        
        if !uiView.isUserInteractionEnabled || !matchManager.inGame {
            uiView.drawing = matchManager.lastReceivedDrawing
        }
        
        uiView.tool = eraserEnabled ? PKEraserTool(.vector) : PKInkingTool(.marker, color: color, width: lineWidth)
    }
}

#Preview {
    @State var eraser = false
    @State var color: UIColor = .blue
    @State var lineWidth: CGFloat = 5
    return DrawingView(matchManager: MatchManager(), eraserEnabled: $eraser, color: $color, lineWidth: $lineWidth)
}
