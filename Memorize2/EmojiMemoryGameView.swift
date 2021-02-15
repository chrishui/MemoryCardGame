//
//  EmojiMemoryGameView.swift
//  Memorize2
//
//  Created by Chris Hui on 21/01/2021.
//
//  View

import SwiftUI

struct EmojiMemoryGameView: View {
    // Pointer to viewModel. @ObservedObject (relates to ObservableObject in EmojiMemoryGame), updates
    // everytime objectWillChange.send
    @ObservedObject var viewModel: EmojiMemoryGame
    
    // body is called by system
    var body: some View {
        // game score
        HStack(spacing: 100){
            Text("Theme: \(viewModel.theme.name)")
            Text("Score: \(viewModel.score)")
        }
        
        VStack {
            // initialize struct Grid's var items, and viewForItem (do not need to show)
            Grid(viewModel.cards) {card in
                // initialise struct CardView's var card
                CardView(card: card).onTapGesture {
                    // animation for user's chosen card,
                    withAnimation(.linear(duration: 0.75)) {
                        viewModel.choose(card: card)
                    }
                }
                .padding(5)
            }
            .padding()
            .foregroundColor(viewModel.theme.cardColor)
            
            // new game button
            Button(action: {
                // explicit animation for new game
                withAnimation(.easeInOut(duration: 0.75)){
                    viewModel.newGame()
                }
            }, label: {
                Text("New Game")
            })
            .padding()
            .background(
                RoundedRectangle(
                    cornerRadius: 8,
                    style: .continuous
                ).stroke(Color.accentColor)
            ).padding()
        }
    }
}

// MARK: - View of each card
struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View{
        // GeometryReader view returns a fleixble preferred size relative to parent layout
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(110-90), clockwise: true)
                    .padding(5).opacity(0.4)
                Text(card.content)
                    //.font(Font.system(size: min(geometry.size.width, geometry.size.height) * fontScaleFactor))
                    .font(Font.system(size: fontSize(for: size)))
                    .rotationEffect(Angle.degrees(card.isMatched ? 360: 0))
                    // implicit animation for matched card's text (emoji)
                    .animation(card.isMatched ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default)
            }
            // .cardify extension specified in Caridfy.swift. Callsed .modifier, which passes content(above ZStack elements) into function
            .cardify(isFaceUp: card.isFaceUp)
            // animation for matched card, shrink
            .transition(AnyTransition.scale)
        }
    }
    
    // MARK: - Drawing Constants
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.7
    }
    
}

// preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(card: game.cards[0])
        return EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}

