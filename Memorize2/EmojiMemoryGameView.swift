//
//  EmojiMemoryGameView.swift
//  Memorize2
//
//  Created by Chris Hui on 21/01/2021.
//

import SwiftUI

// View
struct EmojiMemoryGameView: View {
    // Pointer to viewModel
    @ObservedObject var viewModel: EmojiMemoryGame

    var body: some View {
        VStack {
            // Game score
            Text("Score: \(viewModel.score)")
            
            // Grid for set of cards
            Grid(viewModel.cards) {card in
                CardView(card: card).onTapGesture {
                    // Explicit animation for chosen card, rotation
                    withAnimation(.linear(duration: 0.75)) {
                        viewModel.choose(card: card)
                    }
                }
                .padding(5)
            }
            .padding()
            .foregroundColor(viewModel.theme.cardColor)
            
            // Button for new game
            Button(action: {
                // Explicit animation for new game
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
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    // Invalidates appearance and recompute body when state value changes
    @State private var animatedBonusRemaining: Double = 0
    
    // Animation for background pie
    private func startBonusTimeAnimation() {
        // Sync up with model
        animatedBonusRemaining = card.bonusRemaining
        // Animate towards 0
        withAnimation(.linear(duration: card.bonusTimeRemaining)){
            animatedBonusRemaining = 0
        }
    }
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Group {
                    // Background pie countdown animation
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-animatedBonusRemaining*360-90), clockwise: true)
                            // Start pie animation when displayed
                            .onAppear {
                                startBonusTimeAnimation()
                            }
                    } else {
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-card.bonusRemaining*360-90), clockwise: true)
                    }
                }
                .padding(5).opacity(0.4)
                .transition(.identity)
                // Card emoji
                Text(card.content)
                    .font(Font.system(size: fontSize(for: size)))
                    .rotationEffect(Angle.degrees(card.isMatched ? 360: 0))
                    .animation(card.isMatched ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default)
            }
            // Modifier for ZStack group into cards
            .cardify(isFaceUp: card.isFaceUp)
            // Animation for matched card, shrink
            .transition(AnyTransition.scale)
        }
    }
    
    // MARK: - Drawing Constants
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.7
    }
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(card: game.cards[0])
        return EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}

