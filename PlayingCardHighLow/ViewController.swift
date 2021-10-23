//
//  ViewController.swift
//  PlayingCardHighLow
//
//  Created by Kyle Lei on 2021/10/12.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cardCountLabel: UILabel!
    @IBOutlet weak var cardStackContainer: UIView!
    @IBOutlet var rightCardOutside: UIImageView!
    @IBOutlet weak var rightCardImage: UIView! {
        didSet {setCardShadow(imageView: rightCardImage)}}
    @IBOutlet var rightCardInside: UIView!
    @IBOutlet weak var rightRankLabel: UILabel!
    @IBOutlet weak var rightSuitSmallLabel: UILabel!
    @IBOutlet weak var rightSuitBigLabel: UILabel!
    @IBOutlet weak var rightScoreLabel: UILabel!
    @IBOutlet var leftCardOutside: UIImageView!
    @IBOutlet weak var leftCardImage: UIView!{
        didSet {setCardShadow(imageView: leftCardImage)}}
    @IBOutlet var leftCardInside: UIView!
    @IBOutlet weak var leftRankLabel: UILabel!
    @IBOutlet weak var leftSuitSmallLabel: UILabel!
    @IBOutlet weak var leftSuitBigLabel: UILabel!
    @IBOutlet weak var leftScoreLabel: UILabel!
    @IBOutlet weak var leftArrowImage: UIImageView!
    @IBOutlet weak var rightArrowImage: UIImageView!
    @IBOutlet var swipeGuesture: [UISwipeGestureRecognizer]!
    @IBOutlet weak var keepPlayButton: UIButton!
    
    // Card suit and rank update
    var cards = Cards().cards
    var cardIndex = Cards().cardIndex
    var drawOrder = 0
    
    var rightPlayer = RightPlayer()
    var leftPlayer = LeftPlayer()
    var firstDraw = Player()
    var secondDraw = Player()
       
    func updateUI(sender: UISwipeGestureRecognizer, currentCard: Card) {
        drawOrder %= 2
        var currentPlayer: Player {
            var player = Player()
            switch sender.direction {
            case .right:
                rightPlayer.cardCombol = currentCard
                player = rightPlayer
            case .left:
                leftPlayer.cardCombol = currentCard
                player = leftPlayer
            default: break
            }
            return player
        }
        
        switch DrawOrder(rawValue: drawOrder){
        case .firstDraw:
            firstDraw = currentPlayer
            setPattern()
        case .secondDraw:
            secondDraw = currentPlayer
            setPattern()
            secondDraw.compare(against: firstDraw)
            swipeGuesture[0].isEnabled = true
            swipeGuesture[1].isEnabled = true
            
            flipCard(cardSide: .right, transitFrom: self.rightCardOutside, to: self.rightCardInside, delay: 0.5, duration:0.8, options: .transitionFlipFromLeft, isSetCore: true)
            flipCard(cardSide: .left, transitFrom: self.leftCardOutside, to: self.leftCardInside, delay: 0.5, duration:0.8, options: .transitionFlipFromLeft, isSetCore: true)
           
            flipCard(cardSide: .right, transitFrom: self.rightCardInside, to: self.rightCardInside, delay: 2.5, duration:0.8, options: .transitionCrossDissolve, isSetCore: false)
            flipCard(cardSide: .left, transitFrom: self.leftCardInside, to: self.leftCardInside, delay: 2.5, duration:0.8, options: .transitionCrossDissolve, isSetCore: false)
            
        case .none : break
        }
        
        cardIndex -= 1
        
        func setPattern() {
            switch sender.direction {
            case .right:
                drawACard(dispayPattern: rightRankLabel, rightSuitSmallLabel, rightSuitBigLabel, from: rightPlayer.cardCombol)
                rightCardImage.addSubview(rightCardOutside)
            case .left:
                drawACard(dispayPattern: leftRankLabel, leftSuitSmallLabel, leftSuitBigLabel, from: leftPlayer.cardCombol)
                leftCardImage.addSubview(leftCardOutside)
            default: break
            }
            sender.isEnabled = false
            
                       
            func drawACard(dispayPattern rankLabel: UILabel, _ smallSuitLabel: UILabel, _ bigSuitLabel: UILabel, from cardCombol: Card) {
                
                rankLabel.text = cardCombol.rank.emoji
                rankLabel.textColor = cardCombol.suit.color
                smallSuitLabel.text = cardCombol.suit.emoji
                smallSuitLabel.textColor = cardCombol.suit.color
                bigSuitLabel.text = cardCombol.suit.emoji
                bigSuitLabel.textColor = cardCombol.suit.color
                setCardStackRadious(transRadiousFrom: cardIndex)
            }
        }
    }
    
    // Card appearance
    let cardOutside = UIImageView(image: UIImage(named: "img_playingcard_front"))
    func setCardRadious(_ imageView: UIView) {
        imageView.frame = cardStackContainer.bounds
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
    }
    
    func setCardStackRadious(transRadiousFrom radious: Int) {
        cardStackContainer.layer.shadowRadius = CGFloat(cardIndex) / 5
        cardStackContainer.layer.shadowOffset = CGSize(width: 0, height: CGFloat(cardIndex) / 2)
        cardStackContainer.layer.shadowOpacity = 0.5
    }
    
    func setCardShadow(imageView: UIView){
        imageView.layer.shadowRadius = 2
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    //
    func flipCard(cardSide: PlayerDirection, transitFrom viewOne: UIView, to viewTwo: UIView, delay second: Double, duration: Double, options: UIView.AnimationOptions, isSetCore: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + second) {
            UIView.transition(from: viewOne, to: viewTwo, duration: duration, options: options, completion: nil)
            
            
            self.rightScoreLabel.text = String(self.rightPlayer.score)
            self.leftScoreLabel.text = String(self.leftPlayer.score)
            
            if isSetCore {
                switch cardSide {
                case .right: self.rightScoreLabel.text = String(self.rightPlayer.score)
                case .left: self.leftScoreLabel.text = String(self.leftPlayer.score)
                }
            }
        }
    }
    
    func setCardCount() {
        cardCountLabel.text = "\(cardIndex + 1)"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCardRadious(rightCardOutside)
        setCardRadious(rightCardInside)
        setCardRadious(leftCardOutside)
        setCardRadious(leftCardInside)
        setCardRadious(cardOutside)
        
        setCardStackRadious(transRadiousFrom: cardIndex )
        cardStackContainer.addSubview(cardOutside)
        
        setCardCount()
        keepPlayButton.isHidden = true
     
    }
      
    @IBAction func swipe(_ sender: UISwipeGestureRecognizer) {
        
        updateUI(sender: sender, currentCard: cards[cardIndex])
        setCardCount()
        drawOrder += 1
        
        if cardCountLabel.text == "0" {
            cardOutside.isHidden = true
            leftArrowImage.isHidden = true
            rightArrowImage.isHidden = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.keepPlayButton.isHidden = false
            }            
        }
    }
    @IBAction func keepPlay(_ sender: Any) {
        cards = Cards().cards
        cardIndex = Cards().cardIndex
        setCardCount()
        
        cardOutside.isHidden = false
        leftArrowImage.isHidden = false
        rightArrowImage.isHidden = false
        keepPlayButton.isHidden = true     
    }
}


