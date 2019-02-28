// Copyright Max von Webel. All Rights Reserved.

import UIKit

class PullPillView: UIView {

  override func layoutSubviews() {
    super.layoutSubviews()
    
    layer.cornerRadius = min(bounds.width, bounds.height) / 2
  }

}
