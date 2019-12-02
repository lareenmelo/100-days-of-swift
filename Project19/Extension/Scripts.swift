//
//  Scripts.swift
//  Extension
//
//  Created by Lareen Melo on 12/2/19.
//  Copyright © 2019 Lareen Melo. All rights reserved.
//

import Foundation

let exampleScripts = [
    (title: "Array Sort: Ascending Order" , script: """
    var fruits = ["Banana", "Orange", "Apple", "Mango"];
    document.getElementById("demo").innerHTML = fruits;

    function myFunction() {
      fruits.sort();
      document.getElementById("demo").innerHTML = fruits;
    }
"""
    ),
    (title: "Get Array Length" , script: """
    var fruits = ["Banana", "Orange", "Apple", "Mango"];
    document.getElementById("demo").innerHTML = fruits.length;

"""
),
    (title: "Display an Alert" , script: """

alert("Page title: " + document.title + "\\nPage url: " + document.URL);

"""
)
]
