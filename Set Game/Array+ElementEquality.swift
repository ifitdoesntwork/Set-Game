//
//  Array+ElementEquality.swift
//  Set Game
//
//  Created by Denis Avdeev on 21.06.2020.
//  Copyright © 2020 Denis Avdeev. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    
    var allElementsAreEqual: Bool {
        Set(self).count == 1
    }
    
    var allElementsAreDifferent: Bool {
        Set(self).count == count
    }
    
    var allElementsAreEqualOrDifferent: Bool {
        allElementsAreEqual || allElementsAreDifferent
    }
}
