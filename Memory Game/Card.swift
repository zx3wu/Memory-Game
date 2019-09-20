//
//  Card.swift
//  Memory Game
//
//  Created by Nancy Wu on 2019-09-14.
//  Copyright © 2019 Nancy Wu. All rights reserved.
//

struct Card :Hashable {
    
    var hashValue: Int {
        return identifier
    }
    
    static func equals(lhs: Card, rhs: Card) ->Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var isFaceUp = false
    var isMatched = false
    var identifier: Int
    
    private static var IdGenerator = 0
    private static func getUniqueID() -> Int{
        IdGenerator += 1
        return IdGenerator
    }
    
    init(){
        self.identifier = Card.getUniqueID()
    }
}

