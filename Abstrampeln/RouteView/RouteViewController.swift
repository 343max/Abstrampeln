// Copyright Max von Webel. All Rights Reserved.

import UIKit

protocol SelectedDestinationListener {
  func didSelect(destination: SearchResultItem?)
}

class RouteViewController: DrawerViewController {
  let destination: SearchResultItem
  let signalDispatcher = AppController.shared.dispatcher
  
  @IBOutlet weak var destinationLabel: UILabel!
  
  init(destination: SearchResultItem) {
    self.destination = destination
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    destinationLabel.text = "→ \(destination.label)"
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    signalDispatcher.each(SelectedDestinationListener.self) { $0.didSelect(destination: destination) }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    signalDispatcher.each(SelectedDestinationListener.self) { $0.didSelect(destination: nil) }
  }
}
