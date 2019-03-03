// Copyright Max von Webel. All Rights Reserved.

import UIKit
import Pulley

class SearchViewController: UIViewController {
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var suggestionsCollectionView: UICollectionView!
  
  let searchController = SearchController(searchSources: [
    RecentSuggestionsSource(),
    DummySuggestionSource(),
    OpenRouteSuggestionSearch(client: AppController.shared.openrouteClient, locationController: AppController.shared.locationController)
    ])
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    searchBar.delegate = self
    
    searchController.collectionView = suggestionsCollectionView
    searchController.searchFor(text: "")
    
    suggestionsCollectionView.backgroundColor = .clear
    
    AppController.shared.dispatcher.register(listener: self)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    if let scrollView = view.superview?.superview as? UIScrollView {
      scrollView.keyboardDismissMode = .onDrag
    }
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

extension SearchViewController: SelectedSuggestionListener {
  func didSelect(suggestion: SearchResultItem) {
    pulleyViewController?.setDrawerPosition(position: .partiallyRevealed, animated: true)
  }
}
