// Copyright Max von Webel. All Rights Reserved.

import UIKit

class DrawerViewController: UIViewController {
  class PullPillView: UIView {
    override func layoutSubviews() {
      super.layoutSubviews()
      
      layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }
  }
  
  class CloseButton: UIButton {
    static let normalColor = UIColor(white: 0.3, alpha: 1.0 / 3.0)
    static let highlightedColor = UIColor(white: 0.3, alpha: 1.0 / 3.0 * 2.0)
    
    override var buttonType: UIButton.ButtonType {
      get {
        return .custom
      }
    }
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      
      widthAnchor.constraint(equalToConstant: 24).isActive = true
      heightAnchor.constraint(equalToConstant: 24).isActive = true
      
      imageView?.image = UIImage(named: "CloseX")

      backgroundColor = CloseButton.normalColor
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
      didSet {
        backgroundColor = isHighlighted ? CloseButton.highlightedColor : CloseButton.normalColor
      }
    }
    
    override func layoutSubviews() {
      layer.cornerRadius = min(bounds.width, bounds.height) / 2
      imageView?.sizeToFit()
      imageView?.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }
  }
  
  var pullPillView: PullPillView!
  var closeButton: CloseButton!
  
  var showsCloseButton = false {
    didSet {
      closeButton?.isHidden = !showsCloseButton
    }
  }
    
  override func viewDidLoad() {
    additionalSafeAreaInsets = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    
    closeButton = CloseButton()
    closeButton.addTarget(self, action: #selector(didTapCloseButton(_:)), for: .touchUpInside)
    closeButton.translatesAutoresizingMaskIntoConstraints = false
    closeButton.isHidden = !showsCloseButton
    view.addSubview(closeButton)
    closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2).isActive = true
    closeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
    
    pullPillView = PullPillView()
    pullPillView.translatesAutoresizingMaskIntoConstraints = false
    
    pullPillView.backgroundColor = UIColor(white: 0, alpha: 1.0 / 3.0)
    
    view.addSubview(pullPillView)

    pullPillView.widthAnchor.constraint(equalToConstant: 36).isActive = true
    pullPillView.heightAnchor.constraint(equalToConstant: 5).isActive = true
    pullPillView.topAnchor.constraint(equalTo: view.topAnchor, constant: 6).isActive = true
    pullPillView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor, constant: 0).isActive = true
    
    super.viewDidLoad()
  }
  
  @objc func didTapCloseButton(_ sender: CloseButton) {
    stackViewController?.popTopViewController(animated: true)
  }
}
