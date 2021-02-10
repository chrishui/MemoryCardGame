//
//  MemoryGame.swift
//  Memorize2
//
//  Created by Chris Hui on 22/01/2021.
//

// for Backend (?)

import Foundation

// no 'View' is added after MemoryGame as it's a non-UI view
// <CardContent> is declared, as it is a 'don't care'/generic
// CardContent is Equatable, so that it can match chosen card with potential match (==) operator
struct MemoryGame<CardContent> where CardContent: Equatable{
    // var cards of type Array. 
    var cards: Array<Card>
    
    // Getter and Setter
    var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get {
            // .only defined in Array+Only extension
            cards.indices.filter { cards[$0].isFaceUp }.only
            
//            var faceUpCardIndices = [Int]()
//            for index in cards.indices {
//                if cards[index].isFaceUp {
//                    faceUpCardIndices.append(index)
//                }
//            }
//            if faceUpCardIndices.count == 1 {
//                return faceUpCardIndices.first
//            } else {
//                return nil
//            }
        }
        set {
            for index in cards.indices{
                cards[index].isFaceUp = index == newValue
                // Note newValue is available in setter
//                if index == newValue {
//                    cards[index].isFaceUp = true
//                } else {
//                    cards[index].isFaceUp = false
//                }
            }
        }
    }
    
    // mutating Func to choose struct Card, defined below. mutating, to change var cards
    mutating func choose(card: Card) {
        // To flip over chosen card, if Int is not nil (recall firstIndex returns Int?), and is not already face up
        // Finds the flipped over card's index in the var cards array (?)
        // Note comma (,) in front of !cards[chosenIn... is like a sequential &&. Does cards.firstIndex(ma... first, then !cards[cho...
        if let chosenIndex: Int = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
            // one of OneAndOnlyFaceUpCard card
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                }
                cards[chosenIndex].isFaceUp = true
            } else {
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
        }
    } 
    
    // init to initialise var cards via ViewModel
    // 2nd argument is a function. cardContentFactory, Int input, returns 'don't care' CardContent
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        // Create an empty array. Initialises var cards (line 16)
        cards = Array<Card>()
        // Populate cards array 
        for pairIndex in 0..<numberOfPairsOfCards {
            // note: cardContentFactory defined in viewModel line 24/25
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
        // Shuffle cards
        cards.shuffle()
    }
    
    // Note: the identifiable 
    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
    }
}
