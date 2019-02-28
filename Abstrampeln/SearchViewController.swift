// Copyright Max von Webel. All Rights Reserved.

import UIKit
import Pulley

class SearchViewController: UIViewController {
  @IBOutlet weak var searchField: UITextField!
}

extension SearchViewController: PulleyDrawerViewControllerDelegate {
  func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
    return searchField.frame.maxY + bottomSafeArea
  }
}
