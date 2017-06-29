//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Antonio Villavicencio on 6/28/17.
//  Copyright © 2017 Antonio Villavicencio. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    var pokemon: Pokemon!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var pokemonImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var nextEvoLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    
    override func viewDidLoad() {
        pokemonImg.image = UIImage(named: "\(pokemon.pokedexID)")
        currentEvoImg.image = UIImage(named: "\(pokemon.pokedexID)")
        nextEvoImg.isHidden = true
        nameLbl.text = pokemon.name.capitalized
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {

        pokemon.downloadDetails {
            self.updateUI()
        }

    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func updateUI() {
        attackLbl.text = pokemon.attack
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        idLbl.text = String(pokemon.pokedexID)
        typeLbl.text = pokemon.type
        descriptionLbl.text = pokemon.description
        nextEvoLbl.text = pokemon.nextEvoText
        if pokemon.nextEvoID != "" {
            nextEvoLbl.text = "Next Evolution: \(pokemon.nextEvoName) LVL \(pokemon.nextEvoLvl)"
            nextEvoImg.isHidden = false
            nextEvoImg.image = UIImage(named: "\(pokemon.nextEvoID)")
        } else {
            nextEvoLbl.text = "No Evolution"
        }

    }
    

}
