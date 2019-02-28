// Copyright Max von Webel. All Rights Reserved.

import UIKit
import CoreLocation
import Pulley

struct SearchResultItem {
  let name: String
  let coordinate: CLLocationCoordinate2D
}

protocol SearchResultsDataSource {
  func searchFor(text: String, completion: @escaping (_ text: String, _ results: [SearchResultItem]) -> ())
  func cancelSearchFor(text: String)
}

class SearchViewController: UIViewController {
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var searchResultsTableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    searchBar.delegate = self
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
    print("search for: \(searchText)")
  }
}
