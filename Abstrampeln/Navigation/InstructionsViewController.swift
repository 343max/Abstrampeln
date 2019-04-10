// Copyright Max von Webel. All Rights Reserved.

import UIKit
import OpenrouteService

class InvisibleView: UIView {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    backgroundColor = .clear
  }

  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    let view = super.hitTest(point, with: event)
    if view == self {
      return nil
    } else {
      return view
    }
  }
}

class InstructionsViewController: UIViewController {
  var directions: Directions? {
    didSet {
      updateVisibility(animated: true)
    }
  }

  var isVisible: Bool {
    return directions != nil
  }

  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var pageControl: UIPageControl!
  @IBOutlet weak var visibleConstraint: NSLayoutConstraint!
  @IBOutlet weak var invisibleConstraint: NSLayoutConstraint!
  @IBOutlet weak var heightConstraint: NSLayoutConstraint!

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    updateVisibility(animated: false)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  func updateVisibility(animated: Bool) {
    let updateVisibility = {
      let visible = self.isVisible
      self.visibleConstraint.isActive = visible
      self.invisibleConstraint.isActive = !visible
      self.view.layoutIfNeeded()
    }

    if animated {
      UIView.animate(withDuration: 0.2) {
        updateVisibility()
      }
    } else {
      updateVisibility()
    }
  }
}
