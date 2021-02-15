//
//  Cardify.swift
//  Memorize2
//
//  Created by Chris Hui on 14/02/2021.
//

import SwiftUI

// Refernce to ViewModifier developer documentation. func body refers to modification to content passed into func
// AnimatableModifier is Viewmodifier + Animatable
struct Cardify: AnimatableModifier {
    var rotation: Double
    
    init(isFaceUp: Bool){
        rotation = isFaceUp ? 0 : 180
    }
    
    // isFaceUp becomes function of rotation. If rotation < 90 degrees, it's face up
    var isFaceUp: Bool {
        rotation < 90
    }
    
    // makes rotation animatable (?)
    var animatableData: Double {
        get { return rotation }
        set { rotation = newValue }
    }
    
    func body(content: Content) -> some View {
        ZStack{
            Group {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                content
            }
                .opacity(isFaceUp ? 1 : 0)
            // If card is not faced up, fill (1 opacity). Else will be emptyView (Don't need to specify)
            RoundedRectangle(cornerRadius: cornerRadius).fill()
                .opacity(isFaceUp ? 0 : 1)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0,1,0))
    }
    // drawing constraints
    private let cornerRadius: CGFloat = 10
    private let edgeLineWidth: CGFloat = 3
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
