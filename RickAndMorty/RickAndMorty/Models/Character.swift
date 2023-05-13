//
//  LocationResponse.swift
//  RickAndMorty
//
//  Created by Emir Arıkan on 18.04.2023.
//

import Foundation

struct Character: Codable {
    var id: Int? = nil
    let name: String
    let status: String
    let species: String
    let type: String?
    let gender: String
    let origin: Origin
    let location: LocationCharacter
    let image: String
    let episode: [String]
    let url: String
    let created: String

    enum CodingKeys: String, CodingKey {
        case id, name, status, species, type, gender, origin, location, image, episode, url, created
    }
}
struct LocationCharacter: Codable{
    let name: String
    let url: String
}
struct Origin: Codable {
    let name: String
    let url: String
}

