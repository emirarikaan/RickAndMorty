//
//  CharacterListViewModel.swift
//  RickAndMorty
//
//  Created by Emir Arıkan on 20.04.2023.
//

import Foundation

class CharacterListViewModel {
    var characters: [Character] = []
    var characterViewModels = [CharacterViewModel]()
    var characterone : CharacterViewModel?
    
    
    func fetchCharacters(for characterURL:[String], completion: @escaping ([CharacterViewModel]) -> Void) {
        let url = Constants.Urls.createCharacterUrls(urls: characterURL)
        let webService = WebService<[Character]>()
        webService.fetchData(url: url) { [weak self] result in
            switch result {
            case .success(let charactersData):
                // self?.characters = charactersData
                self?.characterViewModels = charactersData.map { CharacterViewModel(character: $0) }
                completion(self?.characterViewModels ?? [])
            case .failure(let error):
                print(error.localizedDescription)
                completion([])
            }
        }
    }
    func fetchCharacter(for characterURL:[String], completion: @escaping (CharacterViewModel) -> Void) {
        let url = Constants.Urls.createCharacterUrls(urls: characterURL)
        let webService = WebService<Character>()
        webService.fetchDataNoArray(url: url) { [weak self] result in
            switch result {
            case.success(let charactersData):
                self?.characterone = CharacterViewModel(character: charactersData)
                completion((self?.characterone)!)
            case.failure(_):
                completion((self?.characterone!)!)
            }
            
        }
    }
}
extension CharacterListViewModel{
    
    func addCharacterViewModel(_ vm : CharacterViewModel){
        characterViewModels.append(vm)
    }
    func numberRowsInsection(_ section:Int) -> Int{
        return characterViewModels.count
    }
    func modelAt(_ index : Int) -> CharacterViewModel{
        return characterViewModels[index]
    }
    
}

class CharacterViewModel{
    var character : Character
    
    init(character: Character) {
        self.character = character
    }
    //    init(){
    //
    //    }
    func getName() -> String? {
        return character.name
    }
    
    func getStatus() -> String? {
        return character.status
    }
    
    func getSpecies() -> String? {
        return character.species
    }
    
    func getType() -> String? {
        return character.type
    }
    
    func getGender() -> String? {
        return character.gender
    }
    
    func getOriginName() -> String? {
        return character.origin.name
    }
    
    func getOriginURL() -> String? {
        return character.origin.url
    }
    
    func getLocationName() -> String? {
        return character.location.name
    }
    
    func getLocationURL() -> String? {
        return character.location.url
    }
    
    func getImageURL() -> String? {
        return character.image
    }
    
    func getEpisodes() -> [String]? {
        return character.episode
    }
    
    func getCreatedAt() -> String? {
        return character.created
    }
    func getFirstElement(from array: [CharacterViewModel]) -> CharacterViewModel? {
            return array.first
        }
    
    
}


