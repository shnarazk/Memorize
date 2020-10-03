//
//  EmojiMemoryGame.swift
//  MemoryGame
//
//  Created by 楢崎修二 on 2020/10/02.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private(set) var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
        
    private static func createMemoryGame() -> MemoryGame<String> {
        let emojis: Array<String> = ["🤔", "👻", "🎃", "🕷", "🐱", "🦊", "🍺"]
        return MemoryGame<String>(numberOfPairsOfCards: emojis.count) { pairIndex in
            return emojis[pairIndex]
        }
    }
    
    // MARK: - Access to the model
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    // MARK: - Intent(s)
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
}
