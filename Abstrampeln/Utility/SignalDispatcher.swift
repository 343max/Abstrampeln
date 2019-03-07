// Copyright Max von Webel. All Rights Reserved.

import Foundation

enum SignalDispatcherError: Error {
  case invalidListenerCount
}

class SignalDispatcher {
  typealias Listener = AnyObject
  var listeners: [WeakContainer] = []
  
  struct WeakContainer {
    weak var listener: Listener?
  }
  
  func register(listener: Listener) {
    listeners += [WeakContainer(listener: listener)]
  }
  
  func cleanUp() {
    listeners.removeAll { (container) -> Bool in
      container.listener == nil
    }
  }
  
  func all<T>(_ protocol: T.Type) -> [T] {
    return listeners.filter({ $0.listener as? T != nil }).map({ $0.listener }) as! [T]
  }
  
  func each<T>(_ protocol: T.Type, _ handler: (_ listener: T) -> ()) {
    self.all(T.self).forEach { (listener) in
      handler(listener)
    }
  }
  
  func one<T>(_ protocol: T.Type) throws -> T {
    let listeners = all(T.self)
    if listeners.count != 1 {
      throw SignalDispatcherError.invalidListenerCount
    }
    return listeners.first!
  }
}
