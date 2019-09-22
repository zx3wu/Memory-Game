//
//  GameModel.swift
//  Memory Game
//
//  Created by Nancy Wu on 2019-09-14.
//  Copyright © 2019 Nancy Wu. All rights reserved.
//

import Foundation

struct GameModel {

    private (set) var cards = [Card]()
    private (set) var currentIndex: Int = 0
    
    private (set) var numberOfItemsToMatch: Int
    
    var score = 0
    
    var matchesAtID = Dictionary<Int, [Int]>()

    lazy var last = cards.count - 1
    //in the case there not no cards or two cards face up then we need to make it optional otherwise it will be not set
    private var indexOfOnlyFaceUp: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    var cardsChosen = 0
    
    mutating func chooseCard(at index: Int) { //GAME LOGIC
        cards[index].isFaceUp = true
        matchesAtID[cards[index].identifier, default: []].append(index)
        print(matchesAtID[cards[index].identifier])
        //if the card indices chosen are not contained in the actual index it will crash and print this message
        assert(cards.indices.contains(index), "chosen index not in the cards")
        //need to ignore cards which are already matched
        if !cards[index].isMatched {
            cardsChosen += 1
    
                if cardsChosen < numberOfItemsToMatch + 1 {
                    //if cards match, set all of them to isMatched is true
                    if Set(matchesAtID[cards[index].identifier] ?? []).count == numberOfItemsToMatch {
                        let arrayOfIndex = matchesAtID[cards[index].identifier]
                        self.score += 1
                        for index in Set(arrayOfIndex ?? []) {
                                cards[index].isMatched = true
                        }
                    }
                }
                if cardsChosen > numberOfItemsToMatch {
                    indexOfOnlyFaceUp = index
                    cardsChosen = 1
                    
                    print("removed")
                }
            
            if cardsChosen == numberOfItemsToMatch {
                matchesAtID.removeAll()
            }
        }
    }
    
    mutating func shuffle() {
        
        while(last > 0)
        {
            let rand = Int(arc4random_uniform(UInt32(last)))

            cards.swapAt(last, rand)
            
            last -= 1
        }
        last = cards.count - 1
    }
    
    mutating func startOver() {
        self.score = 0
        
        for index in cards.indices {
            cards[index].isFaceUp = false
            cards[index].isMatched = false
        }
    }
    
    //constructor to init the number of cards to start off with in order to create a game
    init(numberOfPairs: Int, numberOfItemsToMatch: Int){
        self.numberOfItemsToMatch = numberOfItemsToMatch
        //if the pairs are less than 0 it will crash and print this message
        assert(numberOfPairs > 0, "must have at least one pair")
        //for loop to iterate to get each unique id numberOfItemsToMatch times
        
        if numberOfItemsToMatch > 0 {
            for _ in 1...numberOfPairs {
            let card = Card()
            //add the cards to array
                for _ in 1...numberOfItemsToMatch {
                cards.append(card)
                }
            }
        }
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}

