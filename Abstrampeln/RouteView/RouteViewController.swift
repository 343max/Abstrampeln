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
    destinationLabel.text = "→ \(destination.label)"
    view.backgroundColor = .clear
  }

  @IBAction func tappedPreviewRoute(_ sender: Any) {
    //
  }
}
