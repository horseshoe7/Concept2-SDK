//
//  WorkoutDurationType.swift
//  Pods
//
//  Created by Jesse Curry on 10/26/15.
//
//

public enum WorkoutDurationType:Int {
  case timeDuration = 0
  case caloriesDuration = 0x40
  case distanceDuration = 0x80
  case wattsDuration = 0xC0
  
  var title:String {
    switch self {
    case .timeDuration:
      return "Time duration"
    case .caloriesDuration:
      return "Calories duration"
    case .distanceDuration:
      return "Distance duration"
    case .wattsDuration:
      return "Watts duration"
    }
  }
}
