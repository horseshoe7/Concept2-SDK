//
//  StrokeState.swift
//  Pods
//
//  Created by Jesse Curry on 10/26/15.
//
//

public enum StrokeState: Int {
  case waitingForWheelToReachMinSpeed = 0
  case waitingForWheelToAccelerate
  case driving
  case dwellingAfterDrive
  case recovery
  
  var title: String {
    switch self {
    case .waitingForWheelToReachMinSpeed:
      return "Waiting for wheel to reach minimum speed"
    case .waitingForWheelToAccelerate:
      return "Waiting for wheel to accelerate"
    case .driving:
      return "Driving"
    case .dwellingAfterDrive:
      return "Dwelling after drive"
    case .recovery:
      return "Recovery"
    }
  }
}
