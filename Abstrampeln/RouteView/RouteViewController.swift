// Copyright Max von Webel. All Rights Reserved.

import UIKit

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
    view.backgroundColor = .clear
    destinationLabel.text = "→ \(destination.label)"
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    debugPrint(traitCollection.userInterfaceStyle)
  }

  @IBAction func tappedPreviewRoute(_ sender: Any) {
    //
  }
}
