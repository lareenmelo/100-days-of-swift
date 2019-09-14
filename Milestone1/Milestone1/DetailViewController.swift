//
//  DetailViewController.swift
//  Milestone1
//
//  Created by Lareen Melo on 9/13/19.
//  Copyright © 2019 Lareen Melo. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var flagImageView: UIImageView!
    var flagSelected: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        navigationItem.largeTitleDisplayMode = .never

        // Do any additional setup after loading the view.
        
        if let flagImage = flagSelected {
            flagImageView.image = UIImage(named: flagImage)
        }
    }
    

    @objc func shareTapped() {
        guard let image = flagImageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }
        
        
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
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
