//
//  ViewController.swift
//  Pokedex
//
//  Created by Antonio Villavicencio on 6/28/17.
//  Copyright © 2017 Antonio Villavicencio. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var inSearchMode = false
    var filteredPokemons = [Pokemon]()
    
    var pokemons =  [Pokemon]()
    
    var audioPlayer = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.returnKeyType = UIReturnKeyType.done
        
        searchBar.delegate = self
        collection.dataSource = self
        collection.delegate = self
        
        parseCSV()
        prepareAudio()
    }
    
    func prepareAudio() {
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            audioPlayer.prepareToPlay()
            audioPlayer.numberOfLoops = -1
            audioPlayer.play()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func musicBtnPressed(_ sender: UIButton) {
        if audioPlayer.isPlaying {
            audioPlayer.pause()
            sender.alpha = 0.3
        } else {
            audioPlayer.play()
            sender.alpha = 1.0
        }
    }
    
    
    func parseCSV() {
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")
        
        do {
            let csv = try CSV(contentsOfURL: path!)
            let rows = csv.rows
            
            for row in rows {
                let id = Int(row["id"]!)!
                let name = row["identifier"]!
                let poke = Pokemon(name: name, pokedexID: id)
                pokemons.append(poke)
            }
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let poke: Pokemon!
        
        if inSearchMode {
            poke = filteredPokemons[indexPath.row]
        } else {
            poke = pokemons[indexPath.row]
        }
        
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredPokemons.count
        }
        return pokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collection.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            let pokemon: Pokemon!
            if inSearchMode {
                pokemon = filteredPokemons[indexPath.row]
                cell.configureCell(pokemon)
            } else {
                pokemon =  pokemons[indexPath.row]
                cell.configureCell(pokemon)
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }
    
    //MARK: Search Bar Delegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text == nil) || (searchBar.text == "") {
            inSearchMode = false
            searchBar.endEditing(true)
            collection.reloadData()
        } else {
            let lower =  searchBar.text!.lowercased()
            filteredPokemons = pokemons.filter({$0.name.range(of: lower) != nil})
            collection.reloadData()
            inSearchMode = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PokemonDetailVC {
            if let poke = sender as? Pokemon {
                vc.pokemon = poke
            }
        }
    }

}

