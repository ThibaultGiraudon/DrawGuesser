//
//  Misc.swift
//  DrawTogether
//
//  Created by Thibault Giraudon on 25/05/2024.
//

import Foundation

//TODO add more objects

var everydayObjects = ["Téléphone", "Lampe", "Voiture", "Montre", "Chaise", "Livre", "Bouteille", "Ordinateur", "Table", "Vélo", "Piano", "Casque", "Couteau", "Ballon", "Guitare", "Avion", "Sac à dos", "Crayon", "Parapluie", "Télévision", "Ciseaux", "Brosse à dents", "Machine à laver", "Réfrigérateur", "Four", "Tasse", "Tablette", "Caméra", "Trampoline", "Skateboard"]

var animals = ["Chien", "Chat", "Cheval", "Lion", "Éléphant", "Tigre", "Oiseau", "Poisson", "Lapin", "Singe", "Serpent", "Grenouille", "Panda", "Kangourou", "Pingouin"]


enum PlayerAuthState: String {
    case authenticating = "Loading into Game Center..."
    case unauthenticated = "Please sign in to Game Center to play"
    case authenticated = ""
    
    case error = "There was an error logging into Game Center"
    case restricted = "You're not allowed to play mutliplayer games!"
}

struct PastGuess: Identifiable {
    let id = UUID()
    var message: String
    var correct: Bool
}

let maxTimeRemaining = 100
