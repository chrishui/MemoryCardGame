//
//  EmojiMemoryGame.swift
//  Memorize2
//
//  Created by Chris Hui on 22/01/2021.
//

// This file is created as a ViewModel (recall MVVM), a doorway for the Views to get to Model

import SwiftUI

// class (instead of struct). ObservableObject (only applicable to class) contrains/gains, gain var objectWillChange.
// class biggest advantage is 1) it's easy to share, 2) lives in the HEAP, 3)Can have lots of pointers. Many views can look through this portal
class EmojiMemoryGame: ObservableObject {
    // private(set) means 1) only EmojiMemoryGame can modify the model. 2) everyone else can still see the model
    // private means fully closed door
    // @Published, a property wrapper, notice every time var model changes, it will call objectWillChange.send (which indicates MemoryGame (model) will change)
    @Published private var model: MemoryGame<String>
    var theme = themes.randomElement()!
    init() {
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
    
    private static func createMemoryGame(theme: Theme) -> MemoryGame<String> {
        let emojis = theme.emojis.shuffled()
        let pairsOfCards = theme.numberOfPairs ?? Int.random(in: 4...6)
        // Below returns MemoryGame<String> struct, recall can omit argument label for first trailling closure, so cardContentFactory label omitted
        return MemoryGame<String>(numberOfPairsOfCards: pairsOfCards) { pairIndex in
            return emojis[pairIndex]
        }
    }
    
    
    // MARK: - Access to the model
    // var cards to let people look cards in the model in constricted ways
    // Note: model is var defined in line 18. calls EmojiMemoryGame.CreateMemoryGame() as set in that line.
    var cards: Array<MemoryGame<String>.Card> { model.cards }
    var score: Int {
        model.score
    }
    
    // MARK: - Intent(s)
    // note: func choose(card: String)... in this case it is struct from MemoryGame<String>.card
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
    func newGame() {
        theme = themes.randomElement()!
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
}



// Note
// cardContentFactory: {(pairIndex: Int) -> String in return "😄" }
// same as cardContentFactory: {pairIndex in "😄"}
