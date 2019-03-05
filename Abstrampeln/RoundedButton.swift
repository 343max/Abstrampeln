// Copyright Max von Webel. All Rights Reserved.

import UIKit

@IBDesignable
class RoundedButton: UIButton {

  override func layoutSubviews() {
    super.layoutSubviews()
    
    layer.cornerRadius = 6
  }

}
