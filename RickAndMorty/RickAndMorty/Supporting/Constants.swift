//
//  Constants.swift
//  RickAndMorty
//
//  Created by Emir Arıkan on 20.04.2023.
//

import Foundation

struct Constants {
   static let locationURL =  "https://rickandmortyapi.com/api/location"
    struct Urls{
        static func urlCharacter(url : String ) -> URL{
            let urlFormat = URL(string: url)!
            return urlFormat
        }
        static func createCharacterUrls(urls : [String]) -> URL {
            let urlNumbers = urls.map { (url) -> String in
                let components = url.components(separatedBy: "/")
                return components.last ?? ""
            }
            let combinedURL = "https://rickandmortyapi.com/api/character/" + urlNumbers.joined(separator: ",")
            
            return URL(string:combinedURL)!
        }
        static func createEpisodes(urls : [String]) -> String {
            let urlNumbers = urls.map { (url) -> String in
                let components = url.components(separatedBy: "/")
                return components.last ?? ""
            }
            let combinedURL = urlNumbers.joined(separator: ",")
            return combinedURL
        }

    }
}

