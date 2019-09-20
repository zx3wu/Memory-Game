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
    
    var score = 0
    let viewController = ViewController()

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
    
    mutating func chooseCard(at index: Int) { //GAME LOGIC
        //if the card indices chosen are not contained in the actual index it will crash and print this message
        assert(cards.indices.contains(index), "chosen index not in the cards")
        //need to ignore cards which are already matched
        
        if !cards[index].isMatched {
            //if you choose another card that matches and its not the same card
            if let matchIndex = indexOfOnlyFaceUp, matchIndex != index {
                //if cards match, set both of them to isMatched is true
                
                
                if cards[matchIndex].identifier == cards[index].identifier {
                    self.score += 1
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched =  true
                }
            
                //if they dont match, when you choose the 2nd card, you have to flip up the card you chose
                cards[index].isFaceUp = true

                
                /*if cards[indexOfOnlyFaceUp ?? 0].isFaceUp, cards[index].isFaceUp {
                    
                    isTwoCardsFacedUp = true
                    
                } else {
                    isTwoCardsFacedUp = false
                }*/
                
            } else {
                
                indexOfOnlyFaceUp = index
            }
        }
        //model flips the card over
        //when we call game.choose card in viewController we get the index of the card the user chooses and when they click it, it needs to flip over. If card at the index is face up, then set the card to face back down and vise versa
        /*if cards[index].isFaceUp {
         cards[index].isFaceUp=true
        }else{
         cards[index].isFaceUp=false
         
        }*/
        
    }
    
    mutating func shuffle() {
        
        while(last > 0)
        {
            let rand = Int(arc4random_uniform(UInt32(last)))
            
            //print("swap items[\(last)] = \(cards[last]) with items[\(rand)] = \(cards[rand])")
            
            cards.swapAt(last, rand)
            
            //print(cards)
            
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
        //need to create num cards, since its a struct we dont need init we can just pass params
        //if the pairs are less than 0 it will crash and print this message
        assert(numberOfPairs > 0, "must have at least one pair")
        //for loop to iterate each unique id
        
        if numberOfItemsToMatch > 0 {
        for i in 1...numberOfPairs {
            let card = Card()
            //a copy of the card
            let matchingCard = card
            //add the cards to array
            print(numberOfItemsToMatch/2)
            for i in 1...numberOfItemsToMatch {
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

