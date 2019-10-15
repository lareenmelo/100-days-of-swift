//
//  ViewController.swift
//  Project1
//
//  Created by Lareen Melo on 9/5/19.
//  Copyright © 2019 Lareen Melo. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    var picturesFrequencies = [String : Int]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        performSelector(inBackground: #selector(loadPictures), with: nil)
        
        let defaults = UserDefaults.standard
        let frequencies = defaults.object(forKey: "frequency") as? [String: Int] ?? [String: Int]()
        picturesFrequencies = frequencies
        
        print("USER DEFAULTS")
        print(picturesFrequencies)
        
    }
    
    @objc func loadPictures() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        pictures.sort()
        for image in pictures {
            picturesFrequencies[image] = 0
            
        }
        
        print(picturesFrequencies)
        //        pictures.sort(by: <) you could do this <3
        
//        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
//        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)

        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        cell.detailTextLabel?.text = "\(picturesFrequencies[pictures[indexPath.row], default: 0])"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1: try loading the "Detail" view controller and typecasting it to be DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            // 2: success! Set its selectedImage property
            vc.selectedImage = pictures[indexPath.row]
            vc.totalPictures = pictures.count
            vc.selectedPictureNumber = indexPath.row + 1
            // 3: now push it onto the navigation controller
            //            navigationController?.pushViewController(vc, animated: true)
            
            
            DispatchQueue.global().async { [weak self] in
                self?.saveFrequency()
                
                DispatchQueue.main.async {
                    self?.navigationController?.pushViewController(vc, animated: true)
                    self?.tableView.reloadRows(at: [indexPath], with: .none)
                }
            }
        }
    }
    func saveFrequency() {
        let defaults = UserDefaults.standard
        defaults.set(picturesFrequencies, forKey: "frequency")
        
    }
}
