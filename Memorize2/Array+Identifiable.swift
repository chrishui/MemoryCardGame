//
//  Array+Identifiable.swift
//  Memorize2
//
//  Created by Chris Hui on 02/02/2021.
//

import Foundation

// Index of matching card
extension Array where Element: Identifiable {
    func firstIndex(matching: Element) -> Int? {
        for index in 0..<self.count {
            if self[index].id == matching.id{
                return index
            }
        }
        return nil
    }
}

