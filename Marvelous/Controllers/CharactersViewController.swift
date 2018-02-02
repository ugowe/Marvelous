//
//  CharactersViewController.swift
//  Marvelous
//
//  Created by Joseph Ugowe on 12/29/17.
//  Copyright © 2017 Joseph Ugowe. All rights reserved.
//

import UIKit
import Foundation



class CharactersViewController: UICollectionViewController {

    var characterArray = [Character]()
    var marvelClient = APIClient()
    var searchTerm: String?
    
    fileprivate let reuseIdentifier = "CharacterCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    fileprivate let itemsPerRow: CGFloat = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let searchTerm = searchTerm else { print("There is no search term"); return }
        loadCharacters(characterName: searchTerm)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadCharacters(characterName: String) {
        
        marvelClient.getSearchResults(searchTerm: characterName) { (results, errorMessage) in
            
            //get the main queue so that we can update the UI
            DispatchQueue.main.async {
                self.characterArray.removeAll()
                
                if let results = results {
                    self.characterArray = results
                }
                
                self.collectionView?.reloadData()
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {

        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characterArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CharacterCell
    
        let character = characterArray[indexPath.row]
        
        cell.nameLabel.text = character.characterName
        
        character.downloadImage(url: character.characterImageURL) { (characterImage) in
            DispatchQueue.main.async {
                if characterImage != nil {
                    cell.characterImage.image = characterImage
                }
            }
        }
        
        // Configure the cell
    
        return cell
    }
}

extension CharactersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
    }
}



























