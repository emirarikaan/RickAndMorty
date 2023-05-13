//
//  ImageSupporter.swift
//  RickAndMorty
//
//  Created by Emir Arıkan on 24.04.2023.
//

import Foundation
import UIKit

struct ImageSupporter{
  
    static func imageFromCharacter(_ character: Character, completion: @escaping (UIImage?) -> Void) {
        guard let imageUrl = URL(string: character.image) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            if let error = error {
                print("Error while fetching image from URL: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let imageData = data, let image = UIImage(data: imageData) else {
                completion(nil)
                return
            }
            
            completion(image)
        }.resume()
    }
}
