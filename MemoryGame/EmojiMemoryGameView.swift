//
//  ContentView.swift
//  MemoryGame
//
//  Created by 楢崎修二 on 2020/10/02.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    var body: some View {
        Grid(items: viewModel.cards) { card in
            CardView(card: card)
                .onTapGesture {
                    self.viewModel.choose(card: card)
                }
                .padding(4)
        }
        .padding()
        .foregroundColor(Color.orange)
        .font(Font.largeTitle)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    func body(for size: CGSize) -> some View {
        ZStack {
            if self.card.isFaceUp {
                RoundedRectangle(cornerRadius: cornerRaius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRaius).stroke(lineWidth: edgeLineWidth)
                Text(card.content)
            } else {
                if !card.isMatched {
                    RoundedRectangle(cornerRadius: cornerRaius).fill()
                }
            }
        }
        .font(Font.system(size: fontSize(for: size)))
    }
    
    // MARK - Drawing Constants
    
    let cornerRaius: CGFloat = 10.0
    let edgeLineWidth: CGFloat = 3
    func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.75
    }
    
}
