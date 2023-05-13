//
//  Location.swift
//  RickAndMorty
//
//  Created by Emir Arıkan on 18.04.2023.
//

import Foundation

struct Location: Codable {
    var id: Int? = 0
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let url: URL
    let created: Date
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        type = try container.decode(String.self, forKey: .type)
        dimension = try container.decode(String.self, forKey: .dimension)
        residents = try container.decode([String].self, forKey: .residents)
        url = try container.decode(URL.self, forKey: .url)
        created = try container.decode(Date.self, forKey: .created)
    }
}
struct LocationsResponse: Codable {
    let results: [Location]
    let info: PageInfo
}

struct PageInfo: Codable {
    var count: Int? = 0
    var pages: Int? = 0
    let next: URL?
    let prev: URL?
}




