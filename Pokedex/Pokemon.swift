//
//  Pokemon.swift
//  Pokedex
//
//  Created by Antonio Villavicencio on 6/28/17.
//  Copyright © 2017 Antonio Villavicencio. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexID: Int!
    private var _description: String!
    private var _type: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _defense: String!
    private var _nextEvoText: String!
    private var _nextEvoLvl: String!
    private var _nextEvoID: String!
    private var _nextEvoName: String!
    
    var name: String {
        return _name
    }
    
    var pokedexID: Int {
        return _pokedexID
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var nextEvoLvl: String {
        if _nextEvoLvl == nil {
            _nextEvoLvl = ""
        }
        return _nextEvoLvl
    }
    
    var nextEvoText: String {
        if _nextEvoText == nil {
            _nextEvoText = ""
        }
        return _nextEvoText
    }
    
    var nextEvoID: String {
        if _nextEvoID == nil {
            _nextEvoID = ""
        }
        return _nextEvoID
    }
    
    var nextEvoName: String {
        if _nextEvoName == nil {
            _nextEvoName = ""
        }
        return _nextEvoName
    }
    
    init(name: String, pokedexID: Int) {
        self._name = name
        self._pokedexID = pokedexID
    }
    
    func downloadDetails(completed: @escaping DownloadComplete) {
        Alamofire.request("\(BASE_URL)\(POKEMON_URL)\(self.pokedexID)/").responseJSON(completionHandler: { (response) in
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                if let attack = dict["attack"] as? Int {
                    self._attack = String(attack)
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = String(defense)
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                //Loop for type
                if let type = dict["types"] as? [Dictionary<String, AnyObject>] , type.count > 0 {
                    if let t1 = type[0]["name"] as? String {
                        self._type = t1.capitalized
                    }
                    
                    if type.count > 1 {
                        for  x in 1..<type.count {
                            if let tn = type[x]["name"] as? String {
                                self._type! += "/\(tn.capitalized)"
                            }
                        }
                    }
                }
                
                //Description
                if let descriptionsArray = dict["descriptions"] as? [Dictionary<String, AnyObject>] {
                    if let descriptionUri = descriptionsArray[0]["resource_uri"] as? String {
                        let uri = "\(BASE_URL)\(descriptionUri)"
                        Alamofire.request(uri).responseJSON(completionHandler: { (response) in
                            if let json = response.result.value as? Dictionary<String, AnyObject> {
                                if let description = json["description"] as? String {
                                    let desc = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    self._description = desc
                                }
                            }
                            completed()
                        })
                    }
                }
                
                //Evolutions
                if let evolutionsArr = dict["evolutions"] as? [Dictionary<String, AnyObject>] {
                    if let evoName = evolutionsArr[0]["to"] as? String, evoName.range(of: "mega") == nil {
                        self._nextEvoName = evoName
                        if let evoLvl = evolutionsArr[0]["level"] as? Int {
                            self._nextEvoLvl = String(evoLvl)
                        }
                        if let evoID = evolutionsArr[0]["resource_uri"] as? String {
                            let s1 = evoID.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                            let id = s1.replacingOccurrences(of: "/", with: "")
                            self._nextEvoID = id
                        }
                    }
                }
            }
            completed()
        })
    }
    
}
