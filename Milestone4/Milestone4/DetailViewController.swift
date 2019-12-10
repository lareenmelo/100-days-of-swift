//
//  DetailViewController.swift
//  Milestone4
//
//  Created by Lareen Melo on 12/7/19.
//  Copyright © 2019 Lareen Melo. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    let userDefaults = UserDefaults.standard
    @IBOutlet var noteTextView: UITextView!
    var notes = [Notes]()
    var detail: Notes!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        
        noteTextView.text = detail.content
    }
    

    @objc func save() {
        let newNote = Notes(id: UUID().uuidString, content: noteTextView.text)
        notes.append(newNote)
        
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(notes) {
            userDefaults.set(savedData, forKey: "notes")
        } else {
            print("Failed to save notes")
        }
            
        navigationController?.popViewController(animated: true)

        
//        notes.append(Notes(id: UUID().uuidString, content: noteTextView.text))
//        print(notes.count)
//        DispatchQueue.global().async { [weak self] in
//            self?.notes.append(Notes(id: UUID().uuidString, content:" self?.noteTextView.text ?? "))
//            let jsonEncoder = JSONEncoder()
//            if let savedData = try? jsonEncoder.encode(self?.notes) {
//                let defaults = UserDefaults.standard
//                defaults.set(savedData, forKey: "notes")
//                print("yas, printing notes: \(self?.notes)")
//            } else {
//                print("Failed to save notes")
//            }
//
//        }
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
