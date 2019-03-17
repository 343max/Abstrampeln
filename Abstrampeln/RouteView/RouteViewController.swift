// Copyright Max von Webel. All Rights Reserved.

import UIKit

enum DestinationSelectionPurpose {
  case Display
  case Preview
  case Navigation
}

protocol SelectedDestinationListener {
  func didSelect(destination: Location, for: DestinationSelectionPurpose)
  func didDeselectDestination()
}

class RouteViewController: DrawerViewController {
  let destination: Location
  let signalDispatcher = AppController.shared.dispatcher
  
  @IBOutlet weak var destinationLabel: UILabel!
  
  init(destination: Location) {
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
    
    signalDispatcher.each(SelectedDestinationListener.self) { $0.didSelect(destination: destination, for: .Display) }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    signalDispatcher.each(SelectedDestinationListener.self) { $0.didDeselectDestination() }
  }
  
  @IBAction func tappedPreviewRoute(_ sender: Any) {
    signalDispatcher.each(SelectedDestinationListener.self) { $0.didSelect(destination: destination, for: .Preview) }
  }
}
