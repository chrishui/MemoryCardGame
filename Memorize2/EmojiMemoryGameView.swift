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
        
        // initialize struct Grid's var items, and viewForItem (do not need to show)
        Grid(viewModel.cards) {card in
            // Initialise struct CardView's var card
            CardView(card: card)
                .onTapGesture {
                viewModel.choose(card: card)
            }
            .padding(5)
        }
        .padding()
        .foregroundColor(viewModel.theme.cardColor)
        
        // new game button
        Button("New Game"){
            viewModel.newGame()
        }
        .padding()
        .background(
            RoundedRectangle(
                cornerRadius: 8,
                style: .continuous
            ).stroke(Color.accentColor)
        ).padding()
    }
}

// MARK: - View of each card
struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View{
        // GeometryReader view returns a fleixble preferred size relative to parent layout
        GeometryReader { geometry in
            ZStack {
                if card.isFaceUp {
                    RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                    // stroke() is a function, draws a line along edges of shape
                    RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                    Text(card.content)
                } else {
                    // If card is not matched, draw fill. Else will be emptyView (Don't need to specify)
                    if !card.isMatched {
                        RoundedRectangle(cornerRadius: cornerRadius).fill()
                    }
                    
                }
            }
            // Font size, calls fontSize func
            //.font(Font.system(size: min(geometry.size.width, geometry.size.height) * fontScaleFactor))
            .font(Font.system(size: fontSize(for: geometry.size)))
        }
    }
    
    // MARK: - Drawing Constants
    
    let cornerRadius: CGFloat = 10
    let edgeLineWidth: CGFloat = 3
    func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.75
    }
    
}

// preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}


//struct EmojiMemoryGameView: View {
//    @ObservedObject var viewModel: EmojiMemoryGame
//    var body: some View {
//        NavigationView {
//            VStack {
//                LazyVGrid(columns: columns) {
//                    ForEach(viewModel.cards) { card in
//                        CardView(card: card).onTapGesture {
//                            withAnimation(.linear(duration: flipDuration)) {
//                                viewModel.choose(card: card)
//                            }
//                        }
//                        .scaledToFill()
//                        .padding(.vertical)
//                    }
//                }
//                .padding(.horizontal)
//
//                Spacer()
//
//                Text("Score: \(viewModel.score)")
//                    .font(.largeTitle)
//                    .padding(.bottom)
//            }
//            .accentColor(viewModel.theme.accentColor)
//            .foregroundColor(viewModel.theme.accentColor)
//            .navigationBarTitle(viewModel.theme.name)
//            .navigationBarItems(trailing:
//                Button("New Game") {
//                    withAnimation(.easeInOut(duration: shuffleDuration)) {
//                        viewModel.newGame()
//                    }
//                }
//            )
//        }
//    }
