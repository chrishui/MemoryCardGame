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
    // private(set) means, setting it is private, but reading it is not
    private(set) var cards: Array<Card>
    var score = 0
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
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
    
    // user choose card. mutating, to change var cards
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
                    // card score
                    score += 2
                }
                cards[chosenIndex].isFaceUp = true
                // card score
                if cards[chosenIndex].isPreviouslySeen && !cards[chosenIndex].isMatched { score -= 1 }
                if cards[potentialMatchIndex].isPreviouslySeen && !cards[potentialMatchIndex].isMatched { score -= 1 }
                cards[chosenIndex].isPreviouslySeen = true
                cards[potentialMatchIndex].isPreviouslySeen = true
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
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
        cards.shuffle()
    }
    
    // Note: the identifiable 
    struct Card: Identifiable {
        var isFaceUp: Bool = false {
            didSet{
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        
        var isMatched: Bool = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        
        var content: CardContent
        var id: Int
        var isPreviouslySeen: Bool = false
        
        // MARK: - Bonus Time

        // this could give matching bonus points
        // if the user matches the card
        // before a certain amount of time passes during which the card is face up

        // can be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6

        // how long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }

        // the last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        // the accumulated time this card has been face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0

        // how much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        // percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        // whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool{
            isMatched && bonusTimeRemaining > 0
        }
        // whether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }

        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
        
    }
}


