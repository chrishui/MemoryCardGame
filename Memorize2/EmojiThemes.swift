//
//  EmojiThemes.swift
//  Memorize2
//
//  Created by Chris Hui on 11/02/2021.
//

import SwiftUI

// Card game themes
let themes: [Theme] = [
    Theme(
        name: "Halloween",
        emojis: ["🎃","🕷","🕸","🍬","👺","👻"],
        numberOfPairs: 5,
        cardColor: .orange,
        id: 0
    ),

    Theme(
        name: "Animals",
        emojis: ["🐴","🐒","🦁","🦍","🦋","🐧"],
        numberOfPairs: nil,
        cardColor: .purple,
        id: 1
    ),

    Theme(
        name: "Sports",
        emojis: ["⚽️","🏀","🏈","⚾️","🎾","🏐"],
        numberOfPairs: nil,
        cardColor: .blue,
        id: 2
    ),

    Theme(
        name: "Faces",
        emojis: ["🥶","😈","😷","🤡","💩","🤠"],
        numberOfPairs: nil,
        cardColor: .gray,
        id: 3
    ),

    Theme(
        name: "Cars",
        emojis: ["🚗","🚕","🚑","🚚","🚝","🚀"],
        numberOfPairs: nil,
        cardColor: .red,
        id: 4
    ),

    Theme(
        name: "Food",
        emojis: ["🍏","🍎","🥬","🥐","🥖","🍑"],
        numberOfPairs: nil,
        cardColor: .purple,
        id: 5
    )
]

struct Theme: Identifiable {
    let name: String
    let emojis: [String]
    let numberOfPairs: Int?
    let cardColor: Color
    let id: Int
}
