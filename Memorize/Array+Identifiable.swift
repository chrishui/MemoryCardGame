//
//  Array+Identifiable.swift
//  Memorize2
//
//  Created by Chris Hui on 02/02/2021.
//

import Foundation

// Constraints and gains. Constraints the 'don't care' type of array, so that they are Identifiable. Gain func firstIndex for all arrays
extension Array where Element: Identifiable {
    // Index of matching card. Note Int? is an optional, since a card might not match
    func firstIndex(matching: Element) -> Int? {
        for index in 0..<self.count {
            if self[index].id == matching.id{
                return index
            }
        }
        return nil
    }
}


//// Index of matching card
//func index(of item: Item) -> Int {
//    for index in 0..<items.count {
//        if items[index].id == item.id{
//            return index
//        }
//    }
//    return 0 // TODO: Bogus!
//}
