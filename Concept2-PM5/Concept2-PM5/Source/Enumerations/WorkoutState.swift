//
//  WorkoutState.swift
//  Pods
//
//  Created by Jesse Curry on 10/24/15.
//
//

public enum WorkoutState: Int {
  case waitToBegin = 0
  case workoutRow
  case countdownPause
  case intervalRest
  case intervalWorkTime
  case intervalWorkDistance
  case intervalRestEndToWorkTime
  case intervalRestEndToWorkDistance
  case intervalWorkTimeToRest
  case intervalWorkDistanceToRest
  case workoutEnd
  case terminate
  case workoutLogged
  case rearm
}
