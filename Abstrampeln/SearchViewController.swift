// Copyright Max von Webel. All Rights Reserved.

import UIKit
import Pulley

class SearchViewController: UIViewController {
  @IBOutlet weak var searchBar: UISearchBar!
  
}

extension SearchViewController: PulleyDrawerViewControllerDelegate {
  func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
    return searchBar.frame.maxY + bottomSafeArea
  }
}
