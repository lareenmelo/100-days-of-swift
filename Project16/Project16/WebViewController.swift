//
//  WebViewController.swift
//  Project16
//
//  Created by Lareen Melo on 11/22/19.
//  Copyright © 2019 Lareen Melo. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet var webView: WKWebView!
    var website: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard website != nil else {
            print("Website not set")
            navigationController?.popViewController(animated: true)
            return
        }
        
        if let url = URL(string: website) {
            webView.load(URLRequest(url: url))
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
