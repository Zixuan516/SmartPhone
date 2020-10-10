//
//  ViewController.swift
//  CardGameUI
//
//  Created by Ashish Ashish on 10/7/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var player1Img1: UIImageView!
    
    @IBOutlet weak var player1Img2: UIImageView!
    
    @IBOutlet weak var player1Img3: UIImageView!
    
    @IBOutlet weak var player2Img1: UIImageView!
    
    @IBOutlet weak var player2Img2: UIImageView!
    
    @IBOutlet weak var player3Img3: UIImageView!
    
    @IBOutlet weak var lblWinner: UILabel!
    
    @IBOutlet weak var playGameButton: UIButton!
    
    var player1Val1 = -1
    var player1Val2 = -1
    var player1Val3 = -1
    var player2Val1 = -1
    var player2Val2 = -1
    var player2Val3 = -1
    
    var player1Win = false
    var player2Win = false
    
    let imageNames = ["AC","AD","AH","AS","2C","2D","2H","2S","3C","3D","3H","3S","4C","4D","4H","4S","5C","5D","5H","5S","6C","6D","6H","6S","7C","7D","7H","7S","8C","8D","8H","8S","9C","9D","9H","9S","10C","10D","10H","10S","JC","JD","JH","JS","QC","QD","QH","QS","KC","KD","KH","KS"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playGame()
    }
    
    func playGame(){
        player1Val1 = Int.random(in: 0..<52)
        player1Val2 = Int.random(in: 0..<52)
        player1Val3 = Int.random(in: 0..<52)
        player2Val1 = Int.random(in: 0..<52)
        player2Val2 = Int.random(in: 0..<52)
        player2Val3 = Int.random(in: 0..<52)
        
        player1Img1.image = UIImage(named: imageNames[player1Val1])
        player1Img2.image = UIImage(named: imageNames[player1Val2])
        player1Img3.image = UIImage(named: imageNames[player1Val3])
        player2Img1.image = UIImage(named: imageNames[player2Val1])
        player2Img2.image = UIImage(named: imageNames[player2Val2])
        player3Img3.image = UIImage(named: imageNames[player2Val3])
        
        if(player1Val1 == 3 || player1Val2 == 3 || player1Val3 == 3){
            player1Win = true
        }
        if(player2Val1 == 3 || player2Val2 == 3 || player2Val3 == 3){
            player2Win = true
        }
        
        updateWinner()
    }
    
    func updateWinner(){
        if(player1Win){
            lblWinner.text = "Winner is player1"
            showAlert()
        }else if(player2Win){
            lblWinner.text = "Winner is player2"
            showAlert()
        }else{
            lblWinner.text = "No Winner"
        }
    }

    func showAlert() {
        let controller = UIAlertController(title: "Play Again", message: "Do you wanna play again?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .default) { (_) in
            self.initGame()
            self.playGame()
        }
        controller.addAction(okAction)
        let cancelAction = UIAlertAction(title: "No", style: .destructive) { (_) in
            self.closeGame()
        }
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    
    func closeGame() {
        playGameButton.isEnabled = false
    }
    
    func initGame() {
        self.player1Win = false
        self.player2Win = false
    }
    
    @IBAction func playGame(_ sender: Any) {
        playGame()
    }
    
    
    
    


}

