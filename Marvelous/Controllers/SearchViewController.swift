//
//  ViewController.swift
//  Marvelous
//
//  Created by Joseph Ugowe on 12/21/17.
//  Copyright © 2017 Joseph Ugowe. All rights reserved.
//

import UIKit
import Foundation

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    var marvelClient = APIClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSearchResults",
            let nextScene = segue.destination as? CharactersViewController {
            nextScene.searchTerm = searchTextField.text
        }
    }
    
    @IBAction func searchDidTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "toSearchResults", sender: self)
    }
    
    
    
}

