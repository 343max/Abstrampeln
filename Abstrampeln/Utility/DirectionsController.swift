// Copyright Max von Webel. All Rights Reserved.

import Foundation
import OpenrouteService

enum MappingMode {
  case None
  case Display
  case StepByStep
}

protocol DirectionsControllerListener {
  func destinationDidChange(_ destination: SearchResultItem)
  func directionsDidChange(_ directions: Directions?, mode: MappingMode)
}

class DirectionsController {
  let listeners: () -> ([DirectionsControllerListener])
  let locationController: LocationController
  let openrouteClient: OpenrouteClient
  
  init(dispatcher: SignalDispatcher, locationController: LocationController, openrouteClient: OpenrouteClient) {
    self.listeners = dispatcher.all(DirectionsControllerListener.self)
    self.locationController = locationController
    self.openrouteClient = openrouteClient
  }
  
  private(set) var destination: SearchResultItem?
  private(set) var directions: Directions?
  private(set) var mappingMode = MappingMode.None
}

extension DirectionsController {
  func updateDirections(destination: SearchResultItem) {
    if let currentLocation = locationController.latestLocations.first?.coordinate {
      openrouteClient.directions(start: currentLocation, finish: destination.coordinate).then { (directions) in
        self.directions = directions
        self.listeners().forEach { $0.directionsDidChange(directions, mode: self.mappingMode) }
      }
    }
  }
  
  private func dispatchDirectionChange() {
    listeners().forEach { $0.directionsDidChange(directions, mode: mappingMode) }
  }
  
  func update(destination: SearchResultItem, mode: MappingMode) {
    let destinationChanged = destination == self.destination
    let modeChanged = mode == self.mappingMode
    
    guard modeChanged || destinationChanged else {
      return
    }
    
    if destinationChanged {
      self.destination = destination
      updateDirections(destination: destination)
      listeners().forEach { $0.destinationDidChange(destination) }
    }
    
    if modeChanged {
      self.mappingMode = mode
    }
  }
}
