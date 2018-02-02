//
//  Character.swift
//  Marvelous
//
//  Created by Joseph Ugowe on 12/21/17.
//  Copyright © 2017 Joseph Ugowe. All rights reserved.
//

import Foundation
import UIKit

class Character: NSObject {
    
    let characterName: String
    let characterImageURL: URL
    let characterID: Int
    
    init(characterName: String, characterImageURL: URL, characterID: Int) {
        self.characterName = characterName
        self.characterImageURL = characterImageURL
        self.characterID = characterID
    }
    
    func downloadImage(url: URL, _ completionHandler: @escaping (_ image: UIImage?) -> () ){
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard let imageData = data else { print("Problem parsing imageData"); return}
                
                if let image = UIImage(data: imageData){
                    completionHandler(image)
                }
            }
        }.resume()
    }
    
}
