//
//  ViewController.swift
//  BlackJack21
//
//  Created by praveen on 3/21/15.
//  Copyright (c) 2015 NYU. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var gameState: UILabel!
    
    @IBOutlet weak var player1Cards: UILabel!
    
    @IBOutlet weak var player1Bet: UILabel!
    
    @IBOutlet weak var player2Bet: UILabel!
    
    @IBOutlet weak var balance1: UILabel!
    
    @IBOutlet weak var balance2: UILabel!
    
    @IBOutlet weak var dealerCards: UILabel!
    
    let maxPlayerCash = 100
    
    var numberOfGamesPlayed = 5
    
    var noOfPlayersInGame :Int = 2
    
    var playerList : [Player] = []
    
    var deck = Deck()
    
    var dealer  = Dealer()
    
    var numberOfDecks:Int = 2;
    
    var maxBalanceForPlayer:Double = 0
    
    var clearedPlayerVIew1 : UIView!
    
    var bet1 = 0
    
    var bet2 = 0
    
    
    // GUI things
    
    @IBOutlet weak var playerHandView: UIView!
    @IBOutlet weak var playerCard1View: UIImageView!
    @IBOutlet weak var playerCard2View: UIImageView!
    @IBOutlet weak var dealerCard1View: UIImageView!
    @IBOutlet weak var dealerHandView: UIView!
    @IBOutlet weak var cardContainerView: UIView!
    var backUpPlayerCard1View = UIView()
    var backUpPlayerCard2View = UIView()
    var playerHandViewBackUP = UIView()
    //
    
    override func viewDidLoad() {
        playerHandViewBackUP  = playerHandView;
        super.viewDidLoad()
        clearedPlayerVIew1 = playerHandView
        // ViewControllerHelper.createCardSubView(ViewControllerHelper)
        //aiHandView
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hit(sender: UIButton) {
        for i in 1...noOfPlayersInGame{
            var hand = playerList[i-1].hand
            if(hand.handStatus == HandStatus.Turn){
                var newCard = deck.getACardFromDeck()
                hand.cardsInHand.append(newCard)
                if(i==1){
                    addCardsToView(hand.cardsInHand, parentView: playerHandView, isPlayerView: true, currentView: playerCard1View , addAllCards: false)
                }else{
                    addCardsToView(hand.cardsInHand, parentView: playerHandView, isPlayerView: false, currentView: playerCard2View , addAllCards: false)
                }
                if(hand.handSum == 21){
                    playerList[i-1].hand.handStatus = HandStatus.BlackJack
                    //showViewItems()
                    if(i != noOfPlayersInGame){
                        playerList[i].hand.handStatus = HandStatus.Turn
                    }
                    return
                }else if(hand.handSum>21){
                    playerList[i-1].hand.handStatus = HandStatus.Busted
                    //showViewItems()
                    if(i != noOfPlayersInGame){
                        playerList[i].hand.handStatus = HandStatus.Turn
                    }else if (i == noOfPlayersInGame){
                        dealerTurn()
                    }
                    return
                }
                showViewItems()
            }
        }
        
    }
    
    
    @IBAction func stand(sender: UIButton) {
        var allPlayersAreDonePlaying = true
        for i in 1...noOfPlayersInGame{
            var hand = playerList[i-1].hand
            if(hand.handStatus == HandStatus.Turn){
                hand.handStatus = HandStatus.Stand
                if(i != noOfPlayersInGame){
                    playerList[i].hand.handStatus = HandStatus.Turn
                }
                break
            }
        }
        for i in 1...noOfPlayersInGame{
            var hand = playerList[i-1].hand
            if(hand.handStatus == HandStatus.Turn){
                allPlayersAreDonePlaying = false
            }
        }
        if(allPlayersAreDonePlaying){
            dealerTurn()
        }
        
    }
    
    
    @IBAction func deal(sender: UIButton) {
        clearAllItemsOnScreen()
        if numberOfGamesPlayed%5 == 0 {
            deck.buildDeck(numberOfDecks)
        }
        //        for i in 1...playerHandView.subviews.count-1 {
        //            println(playerHandView.subviews[i])
        //            //playerHandView.subviews[i]=nil
        //        }
        //
        //        for subview in playerHandView.subviews {
        //                println(subview)
        //                subview.removeFromSuperview()
        //        }
        //        playerHandView.addSubview(backUpPlayerCard1View)
        //        playerHandView.addSubview(backUpPlayerCard2View)
        //Initializing with for loop . Based on number of players
        dealer.initializeDealer()
        numberOfGamesPlayed++;
        for i in 1...noOfPlayersInGame {
            initialize()
            var playerHand = playerList[i-1].hand
            validations(playerList[i-1])
        }
        showViewItems()
        
    }
    
    func initialize(){
        for i in 1...noOfPlayersInGame {
            var player = Player()
            player.initializeHand()
            //player.hand.bet = getBet(i-1)
            if(i==1){
                player.hand.handStatus = HandStatus.Turn
            }else{
                player.hand.handStatus = HandStatus.Statue
            }
            playerList.append(player)
        }
    }
    
    //    func getBet(index : Int) -> Int {
    //        switch index{
    //        case 1:
    //            return player1Bet.text.toInt()!
    //        case 2:
    //            return player2Bet.text.toInt()!
    //        case 3:
    //            return player3Bet.text.toInt()!
    //        case 4:
    //            return player4Bet.text.toInt()!
    //        case 5:
    //            return player5Bet.text.toInt()!
    //        default:
    //            return 0
    //        }
    //    }
    
    
    //    func getLabelsOnIndex(index : Int) -> UILabel {
    //        switch index{
    //        case 1:
    //            return player1Cards
    //        case 2:
    //            return player2cards
    //        case 3:
    //            return player3Cards
    //        case 4:
    //            return player4Cards
    //        case 5:
    //            return player5Cards
    //        default:
    //            return player1Cards
    //        }
    //    }
    
    func showViewItems(){
        var index:Int = 1;
        var i:Int = 0
        for i = noOfPlayersInGame; i > 0; i-- {
            var hand = playerList[i-1].hand
            if(i==1){
                addCardsToView(hand.cardsInHand, parentView: playerHandView,isPlayerView : true,currentView : playerCard1View,addAllCards:true)
            }
            else{
                addCardsToView(hand.cardsInHand, parentView: playerHandView,isPlayerView : false,currentView :playerCard2View,addAllCards:true)
            }
            //if(hand.handStatus == HandStatus.BlackJack || hand.handStatus == HandStatus.Busted || hand.handStatus == HandStatus.Turn || hand.handStatus == HandStatus.Stand){
            // gameState.text = gameState.text! + String(i) + ": "+hand.handStatus.rawValue+","
            //            }
            index = index+1
        }
        showDealerCards(false)
    }
    
    func showDealerCards(var showFullCards : Bool){
        var tempString = ""
        let widthStandard = 50
        let heightStandard = 75
        let xoffSet : CGFloat = CGFloat(20)
        let yoffSet : CGFloat = CGFloat(0)
        let dealerFrame = dealerCard1View.frame.size
        println(dealerFrame)
        let width1 = dealerFrame.width
        let height1 = dealerFrame.height
        let x = dealerCard1View.frame.origin.x
        let y = dealerCard1View.frame.origin.y
        let helper = ViewControllerHelper()
        println(dealer.dealerHand)
        println("testing bahhhhhhhh")
        for i in 1...dealer.dealerHand.count{
            if(i==1){
                if(showFullCards){
                    let newCardView : UIView = helper.createCardSubView(x , y:y,width:width1,height:height1,imageName : "card"+String(dealer.dealerHand[i-1]))
                    dealerHandView.addSubview(newCardView)
                    continue
                }else{
                    let newCardView : UIView = helper.createCardSubView(x , y:y,width:width1,height:height1,imageName : "back")
                    dealerHandView.addSubview(newCardView)
                    continue
                }
                
            }else{
                let newCardView : UIView = helper.createCardSubView(x + (CGFloat(i)*xoffSet) , y:y + (CGFloat(i)*yoffSet),width:width1,height:height1,imageName : "card"+String(dealer.dealerHand[i-1]))
                dealerHandView.addSubview(newCardView)
            }
        }
    }
    
    func clearAllItemsOnScreen() {
        //for i in 1...5{
        playerList = []
        //getLabelsOnIndex(i).text = ""
        //dealerCards.text = ""
        dealer = Dealer()
        //            player1Bet.text = ""
        //            player2Bet.text = ""
        //            player3Bet.text = ""
        //            player4Bet.text = ""
        //            player5Bet.text = ""
        //}
        
    }
    
    
    
    func validations(var player : Player) {
        if(player.hand.isBlackJack()){
            doBalanceChanges(player,isPlayerWon : true)
        }else if(player.hand.isBusted()){
            doBalanceChanges(player,isPlayerWon : false)
        }
    }
    
    
    func dealerTurn() {
        
        while(dealer.dealerCardsSum<16){
            dealer.dealerHand.append(deck.getACardFromDeck())
        }
        println("dealer Card sum after stand \(dealer.dealerCardsSum)")
        println("dealer Cards \(dealer.dealerHand)")
        var dealerSum = dealer.dealerCardsSum
        for playerHand in playerList{
            
            if(dealerSum > 21){
                //Loop through all Players and check each status .
                if(playerHand.hand.handStatus == HandStatus.Stand){
                    playerHand.hand.handStatus = HandStatus.Won
                    doBalanceChanges(playerHand,isPlayerWon : true)
                }
                continue
            }
            
            if(dealerSum > playerHand.hand.handSum && playerHand.hand.handStatus == HandStatus.Stand){
                playerHand.hand.handStatus =  HandStatus.Lost
                doBalanceChanges(playerHand,isPlayerWon : false)
            }else if dealerSum < playerHand.hand.handSum && playerHand.hand.handStatus == HandStatus.Stand {
                playerHand.hand.handStatus =  HandStatus.Won
                doBalanceChanges(playerHand,isPlayerWon : true)
            }else{
                playerHand.hand.handStatus =  HandStatus.Statue
                //No balance change incase of draw
            }
            
        }
        showDealerCards(true)
    }
    
    func doBalanceChanges(var player : Player , var isPlayerWon : Bool) {
        if(isPlayerWon){
            player.balance += player.hand.bet
        }else{
            player.balance -= player.hand.bet
        }
    }
    
    
    func addCardsToView(cardsInHand :[Int] ,parentView : UIView,isPlayerView : Bool, currentView :UIView,addAllCards : Bool){
        var xoffSet : CGFloat = 0
        var yoffSet : CGFloat = 0
        var currentStart = currentView.frame.size
        if(isPlayerView){
            xoffSet = CGFloat(25)
            yoffSet = CGFloat(25)
        }else{
            xoffSet = CGFloat(-25)
            yoffSet = CGFloat(25)
        }
        var width1 = currentStart.width
        var height1 = currentStart.height
        var x = currentView.frame.origin.x
        var y = currentView.frame.origin.y
        
        let helper = ViewControllerHelper()
        //if(addAllCards){
        for i in 1...cardsInHand.count{
            if(i==1){
                let newCardView : UIView = helper.createCardSubView(x , y:0,width:width1,height:height1,imageName : "card"+String(cardsInHand[i-1]))
                parentView.addSubview(newCardView)
                continue
            }else{
                let newCardView : UIView = helper.createCardSubView(x + (CGFloat(i)*xoffSet) , y:y + (CGFloat(i)*yoffSet),width:width1,height:height1,imageName : "card"+String(cardsInHand[i-1]))
                parentView.addSubview(newCardView)
            }
        }
        //}
        //        else{
        //            var lastIndex = cardsInHand.count
        //            let newCardView : UIView = helper.createCardSubView(x + (CGFloat(lastIndex)*xoffSet) , y:y + (CGFloat(lastIndex)*yoffSet),width:width1,height:height1,imageName : "card"+String(cardsInHand[lastIndex-1]))
        //            parentView.addSubview(newCardView)
        //        }
    }
    
    
    
    
    @IBAction func clearBet2(sender: UIButton) {
        bet2 = 0
        player2Bet.text = "0 (Total Bet)"
    }
    
    
    @IBAction func clearBet1(sender: UIButton) {
        bet1 = 0
        player1Bet.text = "0 (Total Bet)"
    }
    
    @IBAction func bet1P1(sender: UIButton) {
        bet1 = bet1 + 1
        player1Bet.text =  String(bet1)
    }
    
    @IBAction func bet5P1(sender: UIButton) {
        bet1 = bet1 + 5
        player1Bet.text =  String(bet1)
    }
    
    @IBAction func bet10P1(sender: UIButton) {
        bet1 = bet1 + 10
        player1Bet.text =  String(bet1)
    }
    
    @IBAction func bet50P1(sender: UIButton) {
        bet1 = bet1 + 50
        player1Bet.text =  String(bet1)
    }
    
    @IBAction func bet1P2(sender: UIButton) {
        bet2 = bet2 + 1
        player2Bet.text =  String(bet2)
    }
    
    @IBAction func bet5P2(sender: UIButton) {
        bet2 = bet2 + 5
        player2Bet.text =  String(bet2)
    }
    
    @IBAction func bet10P2(sender: UIButton) {
        bet2 = bet2 + 10
        player2Bet.text =  String(bet2)
    }
    
    @IBAction func bet50P2(sender: UIButton) {
        bet2 = bet2 + 50
        player2Bet.text =  String(bet2)
    }
    
    
    
    
}

