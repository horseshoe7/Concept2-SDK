//
//  RowingState.swift
//  Pods
//
//  Created by Jesse Curry on 10/24/15.
//
//

public enum RowingState: Int {
  case inactive = 0
  case active
  
  var title: String {
    switch self {
    case .inactive:
      return "Inactive"
    case .active:
      return "Active"
    }
  }
}
