//
//  MatchManager.swift
//  DrawTogether
//r
//  Created by Thibault Giraudon on 25/05/2024.
//

import Foundation
import GameKit
import PencilKit
import Combine

class MatchManager: NSObject, ObservableObject {
    let savePath = URL.documentsDirectory.appending(path: "customList")
    
    @Published var initGame = false
    @Published var waitingPage = false
    @Published var inGame = false
    @Published var isGameOver = false
    @Published var isTimeKeeper = false
    @Published var authenticationState = PlayerAuthState.authenticating
    @Published var everydayObjectList = everydayObjects
    @Published var animalsList = animals
    @Published var customList = [String]()
    @Published var selectedList = everydayObjects
    
    @Published var currentlyDrawing = true
    @Published var drawPrompt = "Machine a laver"
    @Published var pastGuesses = [PastGuess]()
    
    @Published var score = 0
    @Published var remainingTime = maxTimeRemaining {
        willSet {
            if isTimeKeeper { sendString("timer:\(newValue)") }
            if newValue < 0 { gameOver() }
        }
    }
    @Published var lastReceivedDrawing = PKDrawing()
  
    var match: GKMatch? = nil
    var otherPlayer: GKPlayer? = nil
    var localPlayer = GKLocalPlayer.local
    
    var playerUUIDKey = UUID().uuidString
    
    var rootViewController: UIViewController? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first?.rootViewController
    }
    
    enum CondingKeys: String, CodingKey {
        case initGame, waitingPage, inGame, isGameOver, isTimeKeeper, authenticationState, everydayObjectList, animalsList, customList, selectedList, currentlyDrawing, drawPrompt, pastGuesses, score, remainingTime, lastReceivedDrawing, match, otherPlayer, localPlayer, playerUUIDKey, rootViewController
    }
    
    func loadData() {
        do {
            let data = try Data(contentsOf: savePath)
            customList = try JSONDecoder().decode([String].self, from: data)
        } catch {
            customList = []
        }
    }
    
    func save() {
        do {
            let data = try JSONEncoder().encode(selectedList)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable do save data")
        }
    }
    
    func addCustomWord(newWord: String) {
        customList.append(newWord.trimmingCharacters(in: .whitespacesAndNewlines).lowercased())
        self.save()
    }
    
    func deleteCustomWord(word: String) {
        if let index = customList.firstIndex(of: word) {
            customList.remove(at: index)
            self.save()
        }
    }
    
    func authenticateUser() {
        GKLocalPlayer.local.authenticateHandler = { [self] vc, error in
            if let viewController = vc {
                rootViewController?.present(viewController, animated: true)
                return
            }
            
            if let error = error {
                authenticationState = .error
                print(error.localizedDescription)
                
                return
            }
            
            if localPlayer.isAuthenticated {
                if localPlayer.isMultiplayerGamingRestricted {
                    authenticationState = .restricted
                } else {
                    authenticationState = .authenticated
                }
            } else {
                authenticationState = .unauthenticated
            }
        }
    }
    
    func startMatchMaking() {
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 2
        
        let matchmakingVC = GKMatchmakerViewController(matchRequest: request)
        matchmakingVC?.matchmakerDelegate = self
        
        rootViewController?.present(matchmakingVC!, animated: true)
    }
    
    func initGame(newMatch: GKMatch) {
        initGame = true
        match = newMatch
        match?.delegate = self
        otherPlayer = match?.players.first
    }
    
    func startGame() {
        var selection: String = ""
        for item in selectedList {
            selection += item + ", "
        }
        
        initGame = false
        if !inGame {
            waitingPage = true
        }
        
        sendString("selection:\(selection)")
        sendString("began:\(playerUUIDKey)")
    }
    
    func swapRoles() {
        score += 1
        currentlyDrawing = !currentlyDrawing
        drawPrompt =  selectedList.randomElement()!
    }
    
    func gameOver() {
        isGameOver = true
        match?.disconnect()
        // rematch see https://developer.apple.com/documentation/gamekit/gkmatch/1502042-rematch
    }
    
    func resetGame() {
        DispatchQueue.main.async { [self] in
            isGameOver = false
            inGame = false
            drawPrompt = ""
            score = 0
            remainingTime = maxTimeRemaining
            lastReceivedDrawing = PKDrawing()
        }
        
        isTimeKeeper = false
        match?.delegate = nil
        match = nil
        otherPlayer = nil
        pastGuesses.removeAll()
        playerUUIDKey = UUID().uuidString
    }
    
    func addSelection(_ selection: String) {
        let list = selection.split(separator: ", ")
        
        for item in list {
            selectedList.append(String(item))
        }
    }
    
    func receivedString(_ message: String) {
        let messageSplit = message.split(separator: ":")
        guard let messagePrefix = messageSplit.first else { return }
        
        let parameter = String(messageSplit.last ?? "")
        
        switch messagePrefix {
        case "began":
            waitingPage = false
            if playerUUIDKey == parameter {
                playerUUIDKey = UUID().uuidString
                sendString("began:\(playerUUIDKey)")
                break
            }
            
            drawPrompt = selectedList.randomElement()!
            currentlyDrawing = playerUUIDKey < parameter
            inGame = true
            isTimeKeeper = currentlyDrawing
            
            if isTimeKeeper {
                countdownTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
            }
        case "timer":
            remainingTime = Int(parameter) ?? 0
        case "guess":
            var guessCorrect = false
            
            if parameter.lowercased() == drawPrompt.lowercased().removeAccents() {
                sendString("correct:\(parameter)")
                swapRoles()
                guessCorrect = true
                
            } else {
                sendString("incorrect:\(parameter)")
            }
            
            appendPastGuess(guess: parameter, correct: guessCorrect)
        case "correct":
            swapRoles()
            appendPastGuess(guess: parameter, correct: true)
        case "incorrect":
            appendPastGuess(guess: parameter, correct: false)
        case "selection":
            addSelection(parameter)
        default:
            break
        }
    }
    
    func appendPastGuess(guess: String, correct: Bool) {
        pastGuesses.append(PastGuess(message: "\(guess)\(correct ? " was correct!" : "")", correct: correct))
    }
}
