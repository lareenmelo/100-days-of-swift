//
//  ViewController.swift
//  Project2
//
//  Created by Lareen Melo on 9/7/19.
//  Copyright © 2019 Lareen Melo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var questionsAsked = 0
    var correctAnswer = 0
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1

        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()

        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)

        correctAnswer = Int.random(in: 0...2)
        title = "SCORE: \(score) - \(countries[correctAnswer].uppercased())"

    }
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        if questionsAsked <= 2 {
            if sender.tag == correctAnswer {
                title = "Correct"
                score += 1
                callAlert(title: title, message: "Your score is \(score).")

            } else {
                title = "Wrong"
                score -= 1
                callAlert(title: title, message: "Wrong! That's the flag of \(countries[correctAnswer].uppercased()). Your score is \(score).")

            }
            
            questionsAsked += 1
            
        } else {
            callAlert(title: "Game Over", message: "Your score is \(score).")
            finalizeGame()
        }
    }
    

    func finalizeGame() {
        score = 0
        questionsAsked = 0
        correctAnswer = 0
        
    }
    
    func callAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        present(ac, animated: true)

    }
}

//Wrong! That’s the flag of France
