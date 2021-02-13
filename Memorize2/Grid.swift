//
//  Grid.swift
//  Memorize2
//
//  Created by Chris Hui on 01/02/2021.
//

import SwiftUI

// 'don't care' types Item and ItemView
struct Grid<Item, ItemView>: View where Item: Identifiable, ItemView: View {
    private var items: [Item]
    private var viewForItem: (Item) -> ItemView
    
    // @escaping: (Item) -> ItemView needs to escape from initializer, without getting called (not sure?)
    init(_ items: [Item], viewForItem: @escaping (Item) -> ItemView) {
        self.items = items
        self.viewForItem = viewForItem
    }
    
    var body: some View {
        GeometryReader { geomtry in
            body(for: GridLayout(itemCount: self.items.count, in: geomtry.size))
        }
    }
    
    private func body(for layout: GridLayout) -> some View {
        return ForEach(items) { item in
            body(for: item, in: layout)
        }
    }
    
    private func body(for item: Item, in layout: GridLayout) -> some View {
        // firstIndex defined in Array+identifiable
        let index = items.firstIndex(matching: item)!
        return viewForItem(item)
            .frame(width: layout.itemSize.width, height: layout.itemSize.height)
            .position(layout.location(ofItemAt: index))
    }
}




