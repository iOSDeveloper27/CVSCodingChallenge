//
//  ViewController.swift
//  CVSCodingChallenge
//
//  Created by Brandon Riehle on 8/17/22.
//

import UIKit

class ViewController: UICollectionViewController {
    
    private var currentSearchString = ""
    
    var flickrImages = [FlickrImage]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search Flickr"
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        
        navigationItem.searchController = searchController
        
        collectionView.register(UINib(nibName: "FlickrImageCell", bundle: nil), forCellWithReuseIdentifier: "FlickrImageCell")
    }
    
    private func searchImages(with searchText: String) async {
        do {
            flickrImages = try await Networking.callAPI(api: SearchAPI(searchText), type: SearchResults.self).items
        }
        catch let error {
            let ac = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            
            present(ac, animated: true)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlickrImageCell", for: indexPath) as! FlickrImageCell
        let flickrImage = flickrImages[indexPath.item]
        cell.configure(with: flickrImage)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        flickrImages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedFlickrImage = flickrImages[indexPath.item]
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "FlickrImageDetailViewController") as? FlickrImageDetailViewController {
            vc.flickrImage = selectedFlickrImage
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchBarText = searchController.searchBar.text, !searchBarText.isEmpty else {
            return
        }

        let okayChars = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890,")
        let cleanText = searchBarText.filter {okayChars.contains($0) }
                
        if currentSearchString != cleanText {
            currentSearchString = cleanText
            Task {
                await searchImages(with: cleanText)
            }
        }
    }
}
