// Copyright Max von Webel. All Rights Reserved.

import UIKit

protocol HierarchyContainingViewController: UIViewController {
  func pushViewController(_ viewController: UIViewController, animated: Bool)
  func popViewController(animated: Bool) -> UIViewController?
}

extension StackViewController: HierarchyContainingViewController { }
extension UINavigationController: HierarchyContainingViewController { }

extension UIViewController {
  var hierarchyContainingViewController: HierarchyContainingViewController? {
    get {
      return stackViewController ?? navigationController
    }
  }
}
