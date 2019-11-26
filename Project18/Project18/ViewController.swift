//
//  ViewController.swift
//  Project18
//
//  Created by Lareen Melo on 11/25/19.
//  Copyright © 2019 Lareen Melo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("I'm inside the viewDidLoad() method!")
        print(1, 2, 3, 4, 5, separator: "-")
        print("Some message", terminator: ".")
        
        assert(1 == 1, "Maths failure!")
        assert(1 == 2, "Maths failure!")


    }


}

