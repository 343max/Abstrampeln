import UIKit

class OverlappingDrawerViewController: UIViewController {
  let drawerWidth: CGFloat = 400
  
  let contentViewController: UIViewController
  let drawerViewController: UIViewController
  var containerView: UIVisualEffectView!
  
  init(contentViewController: UIViewController, drawerViewController: UIViewController) {
    self.contentViewController = contentViewController
    self.drawerViewController = drawerViewController
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    addChild(contentViewController)
    view.addSubview(contentViewController.view)
    
    containerView = UIVisualEffectView(effect: currentBlurEffect())
    view.addSubview(containerView)
    
    addChild(drawerViewController)
    containerView.contentView.addSubview(drawerViewController.view)
    
    updateLayout()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    updateLayout()
  }
  
  private func currentBlurEffect() -> UIVisualEffect {
    return UIBlurEffect(style: traitCollection.userInterfaceStyle == .dark ? .dark : .extraLight)
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
      containerView.effect = currentBlurEffect()
    }
  }
  
  private func updateLayout() {
    let bounds = view.bounds
    
    contentViewController.view.frame = bounds
    
    let drawerFrame: CGRect = {
      var frame = bounds
      frame.size.width = drawerWidth
      return frame
    }()
    
    containerView.frame = drawerFrame
    drawerViewController.view.frame = drawerFrame
    
    contentViewController.additionalSafeAreaInsets.left = drawerWidth
  }
}
