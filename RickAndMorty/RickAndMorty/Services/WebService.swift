//
//  WebService.swift
//  RickAndMorty
//
//  Created by Emir Arıkan on 19.04.2023.
//

import Foundation

final class WebService<T: Codable> {
    func fetchData(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)

                let jsonData = try decoder.decode(T.self, from: data)
                completion(.success(jsonData))

            }
            catch let DecodingError.dataCorrupted(context){
                print(context)
            }
            catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)}
            catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            }
            catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            }

            catch {
                completion(.failure(error))
            }

        }.resume()
    }
    func fetchDataNoArray(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }

            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                let jsonData = try JSONSerialization.data(withJSONObject: jsonObject ?? [:], options: [])
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)

                let decodedData = try decoder.decode(T.self, from: jsonData)
                completion(.success(decodedData))
            }
            catch {
                completion(.failure(error))
            }
        }.resume()
    }
}





