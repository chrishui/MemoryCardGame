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
    // var model, contents MemoryGame is String
    // private(set) means 1) only EmojiMemoryGame can modify the model. 2) everyone else can still see the model
    // private means fully closed door
    // @Published, a property wrapper, notice every time var model changes, it will call objectWillChange.send (which indicates MemoryGame (model) will change)
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    // card game themes
    struct Theme {
        var name = ["Halloween","Animals","Sports","Faces","Cars","Food"]
        var emojis = [["🎃","🕷","🕸","🍬","👺","👻"],["🐴","🐒","🦁","🦍","🦋","🐧"],["⚽️","🏀","🏈","⚾️","🎾","🏐"],["🥶","😈","😷","🤡","💩","🤠"],["🚗","🚕","🚑","🚚","🚝","🚀"],["🍏","🍎","🥬","🥐","🥖","🍑"]]
        var noOfPairsOfCards: [Int?] = [5,5,nil,5,5]
        //var cardColor: String?
        func pairsOfCards(index: Int) -> Int {
            if let number = noOfPairsOfCards[index] {
                return number
            } else {
                return Int.random(in: 2...5)
            }
        }
    }
    
    static func createMemoryGame() -> MemoryGame<String> {
        // choose random theme
        let theme = Theme()
        let themeIndex = Int.random(in: 0...theme.name.count-1)
        // Below returns MemoryGame<String> struct, recall can omit argument label for first trailling closure, so cardContentFactory label omitted
        // pairIndex from model's line 75. Random int between 2 to 5.
        return MemoryGame<String>(numberOfPairsOfCards: theme.pairsOfCards(index: themeIndex)) { pairIndex in
            return theme.emojis[themeIndex][pairIndex]
//        return MemoryGame<String>(numberOfPairsOfCards: Int.random(in: 2...5)) { pairIndex in
//            return emojis[pairIndex]
        }
    }
    
    // MARK: - Access to the model
    // var cards to let people look cards in the model in constricted ways
    // Note: model is var defined in line 18. calls EmojiMemoryGame.CreateMemoryGame() as set in that line.
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    // MARK: - Intent(s)
    // note: func choose(card: String)... in this case it is struct from MemoryGame<String>.card
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
    
}



// Note
// cardContentFactory: {(pairIndex: Int) -> String in return "😄" }
// same as cardContentFactory: {pairIndex in "😄"}
