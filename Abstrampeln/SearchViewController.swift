// Copyright Max von Webel. All Rights Reserved.

import UIKit
import Pulley

class SearchViewController: UIViewController {
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var suggestionsCollectionView: UICollectionView!
  
  let searchController = SearchController(searchSources: [
    DummySuggestionSource(),
    OpenRouteSuggestionSearch(client: AppController.shared.openrouteClient)
    ])
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    searchBar.delegate = self
    
    searchController.collectionView = suggestionsCollectionView
    searchController.searchFor(text: "")
    suggestionsCollectionView.backgroundColor = .clear
  }
}

extension SearchViewController: PulleyDrawerViewControllerDelegate {
  func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
    return searchBar.frame.maxY + bottomSafeArea
  }
  
  func drawerPositionDidChange(drawer: PulleyViewController, bottomSafeArea: CGFloat) {
    if drawer.drawerPosition != .open {
      searchBar.resignFirstResponder()
    } else {
      searchBar.becomeFirstResponder()
    }
  }
}

extension SearchViewController: UISearchBarDelegate {
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    pulleyViewController?.setDrawerPosition(position: .open, animated: true)
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    searchController.searchFor(text: searchText)
  }
}
