//
//  ViewController.swift
//  Memory Game
//
//  Created by Nancy Wu on 2019-09-14.
//  Copyright © 2019 Nancy Wu. All rights reserved.
//

import UIKit

struct Item: Decodable {
    var products: [Product]
}
struct Product: Decodable {
    var images: [Image]
}

struct Image: Decodable {
    var src: String
   
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        networkRequest()
    }
    
    var numberOfItemsToMatch = 2
    
    var countPairs: Int {
        get {
            return (buttons.count+1)/numberOfItemsToMatch
        }
    }
    
    private lazy var game = GameModel(numberOfPairs: countPairs, numberOfItemsToMatch: numberOfItemsToMatch)

    
    var imageChoice = [String]()
    var images = Dictionary<Int, String>()
    
    func networkRequest() {
        guard let url = URL(string: "https://shopicruit.myshopify.com/admin/products.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                let product = try JSONDecoder().decode(Item.self, from: dataResponse)
                print(product.products[1].images[0].src)
                print(product.products.count)
                for i in 0...product.products.count - 1 {
                    if let imageLink = product.products[i].images[0].src as? String {
                        self.imageChoice.append(imageLink)
                    }
                }
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
        
        game.shuffle()
    }

    
    @IBOutlet var buttons: [UIButton]!
    
    @IBAction func tapCard(_ sender: UIButton) {
        if let cardNum = buttons.index(of: sender){
            game.chooseCard(at: cardNum)
            
            //now need to update new from model once the card is chosen so that we see card flipping over
            updateViewFromModel()
        }
    }
    
    @IBAction func reset(_ sender: Any) {
        //resets the game and shuffles the cards
        images.removeAll()
        game.shuffle()
        game.startOver()
        
        for button in buttons {
            button.backgroundColor = #colorLiteral(red: 0.5563425422, green: 0.9793455005, blue: 0, alpha: 1)
            button.setBackgroundImage(nil, for: .normal)
        }
    }
    
    @IBOutlet weak var pairsMatched: UILabel!
    
    func updateViewFromModel() {
        //indices returns countable range of indices in cardButtons
        pairsMatched.text = "Score: " + String(game.score)
        if game.score == 10 || game.score*numberOfItemsToMatch == buttons.count {
            presentSuccessAlert(viewController: self)
        }
        
        for index in buttons.indices {
            //we match the actual card to the object struct
            let button = buttons[index]
            let card = game.cards[index]
            
            button.imageView?.contentMode = .scaleAspectFit
            
            if card.isFaceUp {
            
                //synchronous
                let url = URL(string: image(for: card))
                
                if let url = url, let data = try? Data(contentsOf: url) {
                   
                    let image = UIImage(data: data)
                    
                    button.setBackgroundImage(image, for: .normal)
                    button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    button.contentHorizontalAlignment = .fill
                }
    
            } else {
                if card.isMatched {
                    
                     button.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                } else {
                    button.backgroundColor = #colorLiteral(red: 0.5563425422, green: 0.9793455005, blue: 0, alpha: 1)
                    //if not matched then hide the image
                    button.setBackgroundImage(nil, for: .normal)
                }
            }
        }
    }
    
    func image(for card: Card)-> String {
        //put image in dict as we are playing the game
        if images[card.identifier] == nil, imageChoice.count>0 {
            let randomIndex = getRandomIndex(for: buttons.count)
            images[card.identifier] = imageChoice.remove(at: randomIndex)
        }

        return images[card.identifier] ?? ""
    }
    
    private func presentSuccessAlert(viewController: UIViewController) -> Void {
        let alert = UIAlertController(title: "You Win!", message: "You successfully matched \(game.score) pairs!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}


// Helper to get random index from desired array count.
private func getRandomIndex(for arrayCount: Int) -> Int {
    return Int(arc4random_uniform(UInt32(arrayCount)))
}

