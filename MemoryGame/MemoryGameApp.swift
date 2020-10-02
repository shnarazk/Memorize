//
//  MemoryGameApp.swift
//  MemoryGame
//
//  Created by 楢崎修二 on 2020/10/02.
//

import SwiftUI

@main
struct MemoryGameApp: App {
    let game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
