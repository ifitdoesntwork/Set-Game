//
//  SetGame.swift
//  Set Game
//
//  Created by Denis Avdeev on 15.06.2020.
//  Copyright © 2020 Denis Avdeev. All rights reserved.
//

import Foundation

struct SetGame {
    
    struct Card: Equatable {
        
        enum Number: Int, CaseIterable {
            case one, two, three
        }
        
        enum Shape: CaseIterable {
            case diamond, squiggle, oval
        }
        
        enum Shading: CaseIterable {
            case solid, striped, open
        }
        
        enum Color: CaseIterable {
            case red, green, purple
        }
        
        let number: Number
        let shape: Shape
        let shading: Shading
        let color: Color
        
        enum Status {
            case inDeck, dealt, discarded
        }
        
        var status = Status.inDeck
        var isSelected = false
    }
    
    private(set) var cards = Card.Number.allCases
        .flatMap { number in
            Card.Shape.allCases
                .flatMap { shape in
                    Card.Shading.allCases
                        .flatMap { shading in
                            Card.Color.allCases
                                .map { color in
                                    Card(
                                        number: number,
                                        shape: shape,
                                        shading: shading,
                                        color: color
                                    )
                                }
                        }
                }
        }
        .shuffled()
    
    var dealtCards: [Card] {
        
        cards.filter { $0.status == .dealt }
    }
    
    var selectedCards: [Card] {
        
        dealtCards.filter { $0.isSelected }
    }
    
    var selectionIsReadyToSatisfyForSet: Bool {
        
        selectedCards.count == 3
    }
    
    var hasSetSelected: Bool {
        
        selectionIsReadyToSatisfyForSet
        && selectedCards
            .hashables
            .map { $0.allElementsAreEqualOrDifferent }
            .filter(!)
            .count == 0
    }
    
    mutating func deal() {
        
        let cardsToDeal = dealtCards.isEmpty ? 12 : 3
        
        if hasSetSelected {
            selectedCards.forEach { card in
                cards.firstIndex(of: card).map {
                    cards[$0].status = .discarded
                }
            }
        }
        
        (1...cardsToDeal).forEach { _ in
            if let index = cards.lastIndex(where: { $0.status == .inDeck }) {
                cards[index].status = .dealt
            }
        }
    }
    
    mutating func select(card: Card) {
        
        if hasSetSelected {
            deal()
        }
        
        if selectionIsReadyToSatisfyForSet {
            cards.indices.forEach {
                cards[$0].isSelected = false
            }
        }
        
        cards.firstIndex(of: card).map {
            cards[$0].isSelected.toggle()
        }
    }
}

private extension Array where Element == SetGame.Card {
    
    var hashables: [[AnyHashable]] {
        [
            map { $0.number },
            map { $0.shape },
            map { $0.shading },
            map { $0.color }
        ]
    }
}
