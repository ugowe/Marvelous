//
//  APIClient.swift
//  Marvelous
//
//  Created by Joseph Ugowe on 12/22/17.
//  Copyright © 2017 Joseph Ugowe. All rights reserved.
//

import Foundation
import CryptoSwift

class APIClient {
    
    typealias JSONDictionary = [String: Any]
    typealias JSONArray = [[String: Any]]
    typealias CharacterSearchCompletionBlock = ([Character]?, String) -> ()
    
    var characters: [Character] = []
    //    var character: Character?
    var errorMessage = ""
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    let baseURLString = "https://gateway.marvel.com/v1/public/"
    
    struct MarvelResourceTypes {
        static let comics = "comics"
        static let comicSeries = "series"
        static let comicStories = "stories"
        static let comicEvents = "events"
        static let characters = "characters"
    }
    
    
    func createURLWithComponents(searchTerm: String) -> URL? {
        guard var urlComponents = URLComponents(string: baseURLString+MarvelResourceTypes.characters) else { return nil }
        
        let apiKeyQuery = URLQueryItem(name: ParameterStrings.apikey, value: Secrets.publicKey)
        let timestampQuery = URLQueryItem(name: ParameterStrings.ts, value: timestamp)
        let hashQuery = URLQueryItem(name: ParameterStrings.hash, value: (timestamp+Secrets.privateKey+Secrets.publicKey).md5())
        let nameQuery = URLQueryItem(name: ParameterStrings.nameStartsWith, value: searchTerm)
        
        urlComponents.queryItems = [timestampQuery, apiKeyQuery, hashQuery, nameQuery]
        print(String(describing: urlComponents.url))
        return urlComponents.url
    }
    
    func getSearchResults(searchTerm: String, completion: @escaping CharacterSearchCompletionBlock) {
        
        dataTask?.cancel()
        
        guard let url = createURLWithComponents(searchTerm: searchTerm) else {
            print("invalid URL")
            return
        }
        
        dataTask = defaultSession.dataTask(with: url) { data, response, error in
            defer { self.dataTask = nil }
            
            if let error = error {
                self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                print("\(self.errorMessage)")
            } else if let data = data {
                self.serializeJSON(data: data)
                
                DispatchQueue.main.async {
                    completion(self.characters, self.errorMessage)
                }
            }
        }
         self.dataTask?.resume()
    }
    
    func serializeJSON(data: Data) {
        var response: JSONDictionary?
        
        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary

        } catch let parseError as NSError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)"
            return
        }
        
        //        if let returnCode = response["code"] as? Int, returnCode == 200 {
        if let responseData = response!["data"] as? [String: Any] {
            let resultsArray = responseData["results"] as! JSONArray
            for result in resultsArray {
                let id = result["id"] as! Int
                let name = result["name"] as! String
                let thumbnail = result["thumbnail"] as? JSONDictionary
                let thumbnailPath = thumbnail!["path"] as? String
                let thumbnailExt = thumbnail!["extension"] as? String
                let imageURLString = "\(thumbnailPath!).\(thumbnailExt!)"
                let imageURL = URL(string: imageURLString)
                
                let character = Character.init(characterName: name, characterImageURL: imageURL!, characterID: id)
                
                self.characters.append(character)
            }
        } else {
            print("None of these work")
        }
        
    }
    
}
















