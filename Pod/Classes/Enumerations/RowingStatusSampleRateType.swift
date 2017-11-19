//
//  RowingStatusSampleRateType.swift
//  Pods
//
//  Created by Jesse Curry on 10/27/15.
//
//

public enum RowingStatusSampleRateType:UInt8 {
  case oneSecond = 0
  case halfSecond = 1
  case quarterSecond = 2
  case tenthSecond = 3
  
  var title:String {
    switch self {
    case .oneSecond:
      return "1 sec"
    case .halfSecond:
      return "500 ms"
    case .quarterSecond:
      return "250 ms"
    case .tenthSecond:
      return "100 ms"
    }
  }
}
