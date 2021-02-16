//
//  Array+Only.swift
//  Memorize2
//
//  Created by Chris Hui on 03/02/2021.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
