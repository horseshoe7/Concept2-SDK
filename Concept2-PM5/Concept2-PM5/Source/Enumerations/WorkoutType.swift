//
//  WorkoutTypes.swift
//  Pods
//
//  Created by Jesse Curry on 10/24/15.
//
//

public enum WorkoutType: Int {
  case justRowNoSplits = 0
  case justRowSplits
  case fixedDistanceNoSplits
  case fixedDistanceSplits
  case fixedTimeNoSplits
  case fixedTimeSplits
  case fixedTimeInterval
  case fixedDistanceInterval
  case variableInterval
  case variableUndefinedRestInterval
  case fixedCalorie
  case fixedWattMinutes
  
  var title: String {
    switch self {
    case .justRowNoSplits:
      return "Just row, no splits"
    case .justRowSplits:
      return "Just row, with splits"
    case .fixedDistanceNoSplits:
      return "Fixed distance, no splits"
    case .fixedDistanceSplits:
      return "Fixed distance, with splits"
    case .fixedTimeNoSplits:
      return "Fixed time, no splits"
    case .fixedTimeSplits:
      return "Fixed time, with splits"
    case .fixedTimeInterval:
      return "Fixed time intervals"
    case .fixedDistanceInterval:
      return "Fixed distance intervals"
    case .variableInterval:
      return "Variable intervals"
    case .variableUndefinedRestInterval:
      return "Variable, with undefined rest intervals"
    case .fixedCalorie:
      return "Fixed calorie"
    case .fixedWattMinutes:
      return "Fixed watt-minutes"
    }
  }
}
