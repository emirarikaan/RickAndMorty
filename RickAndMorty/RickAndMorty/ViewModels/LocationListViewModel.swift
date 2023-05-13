//
//  LocationViewModel.swift
//  RickAndMorty
//
//  Created by Emir Arıkan on 19.04.2023.
//

import Foundation



class LocationListViewModel {
     var locationViewModels = [LocationViewModel]()
    
    func fetchLocations(completion: @escaping ([LocationViewModel]) -> Void) {
        guard let url = URL(string: Constants.locationURL) else {
            return
        }
        
        let webService = WebService<LocationsResponse>()
        webService.fetchData(url: url) {  [weak self] result in
            switch result {
            case .success(let locationData):
                self?.locationViewModels = locationData.results.map { LocationViewModel(location: $0) }
               // self?.locationViewModels = self.locationViewModels
                completion(self?.locationViewModels ?? [])
            case .failure(let error):
                print(error.localizedDescription)
                completion([])
            }
        }
    }

    init(locationViewModels: [LocationViewModel] = [LocationViewModel]()) {
            self.locationViewModels = locationViewModels
        }
        
        required init?(coder aDecoder: NSCoder) {
            guard let locationViewModels = aDecoder.decodeObject(forKey: "locationViewModels") as? [LocationViewModel] else {
                return nil
            }
            self.locationViewModels = locationViewModels
        }
        
        func encode(with aCoder: NSCoder) {
            aCoder.encode(locationViewModels, forKey: "locationViewModels")
        }
   
}

struct LocationViewModel {
    let location : Location
    
    init(location: Location) {
        self.location = location
    }
    
    var name : String {
        return location.name
    }
}











