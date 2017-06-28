//
//  Pokemon.swift
//  Pokedex
//
//  Created by Antonio Villavicencio on 6/28/17.
//  Copyright © 2017 Antonio Villavicencio. All rights reserved.
//

import Foundation

class Pokemon {
    
    private var _name: String!
    private var _pokedexID: String!
    
    var name: String {
        return _name
    }
    
    var pokedexID: String {
        return _pokedexID
    }
    
    init(name: String, pokedexID: String) {
        self._name = name
        self._pokedexID = pokedexID
    }
    
}
