// Copyright Max von Webel. All Rights Reserved.

import Foundation
import OpenrouteService

enum MappingMode {
  case None
  case Display
  case StepByStep
}

protocol DirectionsControllerDestinationListener {
  func destinationDidChange(_ destination: Location?)
}

protocol DirectionsControllerDirectionsListener {
  func directionsDidChange(_ directions: Directions?, mode: MappingMode)
}

class DirectionsController {
  let dispatcher: SignalDispatcher
  let locationController: LocationController
  let openrouteClient: OpenrouteClient
  
  init(dispatcher: SignalDispatcher, locationController: LocationController, openrouteClient: OpenrouteClient) {
    self.dispatcher = dispatcher
    self.locationController = locationController
    self.openrouteClient = openrouteClient
  }
  
  private(set) var destination: Location?
  private(set) var directions: Directions?
  private(set) var mappingMode = MappingMode.None
}

extension DirectionsController {
  func updateDirections(destination: Location) {
    if let currentLocation = locationController.latestLocations.first?.coordinate {
      openrouteClient.directions(start: currentLocation, finish: destination.coordinate).then { (directions) in
        self.directions = directions
        
        self.dispatcher.each(DirectionsControllerDirectionsListener.self, {
          $0.directionsDidChange(directions, mode: self.mappingMode)
        })
      }
    }
  }
  
  func set(destination: Location, mode: MappingMode) {
    let destinationChanged = destination != self.destination
    let modeChanged = mode != self.mappingMode
    
    guard modeChanged || destinationChanged else {
      return
    }
    
    if destinationChanged {
      self.destination = destination
      updateDirections(destination: destination)
      dispatcher.each(DirectionsControllerDestinationListener.self) {
        $0.destinationDidChange(destination)
      }
    }
    
    if modeChanged {
      self.mappingMode = mode
    }
  }
}
