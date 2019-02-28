// Copyright Max von Webel. All Rights Reserved.

import UIKit
import Pulley

class SearchViewController: UIViewController {
  @IBOutlet weak var searchBar: UISearchBar!
  
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
}
