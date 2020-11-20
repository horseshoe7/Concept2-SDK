//
//  RowingCharacteristic.swift
//  Pods
//
//  Created by Jesse Curry on 10/24/15.
//
//

import CoreBluetooth

public enum RowingCharacteristic:Characteristic {
  case generalStatus
  case additionalStatus1
  case additionalStatus2
  case statusSampleRate
  case strokeData
  case additionalStrokeData
  case intervalData
  case additionalIntervalData
  case workoutSummaryData
  case additionalWorkoutSummaryData
  case heartRateBeltInformation
  case mutliplexedInformation
  
  init?(uuid:CBUUID) {
    switch uuid {
    case RowingCharacteristic.generalStatus.UUID:
      self = .generalStatus
    case RowingCharacteristic.additionalStatus1.UUID:
      self = .additionalStatus1
    case RowingCharacteristic.additionalStatus2.UUID:
      self = .additionalStatus2
    case RowingCharacteristic.statusSampleRate.UUID:
      self = .statusSampleRate
    case RowingCharacteristic.strokeData.UUID:
      self = .strokeData
    case RowingCharacteristic.additionalStrokeData.UUID:
      self = .additionalStrokeData
    case RowingCharacteristic.intervalData.UUID:
      self = .intervalData
    case RowingCharacteristic.additionalIntervalData.UUID:
      self = .additionalIntervalData
    case RowingCharacteristic.workoutSummaryData.UUID:
      self = .workoutSummaryData
    case RowingCharacteristic.additionalWorkoutSummaryData.UUID:
      self = .additionalWorkoutSummaryData
    case RowingCharacteristic.heartRateBeltInformation.UUID:
      self = .heartRateBeltInformation
    case RowingCharacteristic.mutliplexedInformation.UUID:
      self = .mutliplexedInformation
    default:
      return nil
    }
  }
  
  var UUID:CBUUID {
    switch self {
    case .generalStatus:
      return CBUUID(string: "CE060031-43E5-11E4-916C-0800200C9A66")
    case .additionalStatus1:
      return CBUUID(string: "CE060032-43E5-11E4-916C-0800200C9A66")
    case .additionalStatus2:
      return CBUUID(string: "CE060033-43E5-11E4-916C-0800200C9A66")
    case .statusSampleRate:
      return CBUUID(string: "CE060034-43E5-11E4-916C-0800200C9A66")
    case .strokeData:
      return CBUUID(string: "CE060035-43E5-11E4-916C-0800200C9A66")
    case .additionalStrokeData:
      return CBUUID(string: "CE060036-43E5-11E4-916C-0800200C9A66")
    case .intervalData:
      return CBUUID(string: "CE060037-43E5-11E4-916C-0800200C9A66")
    case .additionalIntervalData:
      return CBUUID(string: "CE060038-43E5-11E4-916C-0800200C9A66")
    case .workoutSummaryData:
      return CBUUID(string: "CE060039-43E5-11E4-916C-0800200C9A66")
    case .additionalWorkoutSummaryData:
      return CBUUID(string: "CE06003A-43E5-11E4-916C-0800200C9A66")
    case .heartRateBeltInformation:
      return CBUUID(string: "CE06003B-43E5-11E4-916C-0800200C9A66")
    case .mutliplexedInformation:
      return CBUUID(string: "CE060080-43E5-11E4-916C-0800200C9A66")
    }
  }
  
  func parse(data:Data?) -> CharacteristicModel? {
    if let data = data {
      switch self {
      case .generalStatus:
        return RowingGeneralStatus(fromData: data)
      case .additionalStatus1:
        return RowingAdditionalStatus1(fromData: data)
      case .additionalStatus2:
        return RowingAdditionalStatus2(fromData: data)
      case .statusSampleRate:
        return RowingStatusSampleRate(fromData: data)
      case .strokeData:
        return RowingStrokeData(fromData: data)
      case .additionalStrokeData:
        return RowingAdditionalStrokeData(fromData: data)
      case .intervalData:
        return RowingIntervalData(fromData: data)
      case .additionalIntervalData:
        return RowingAdditionalIntervalData(fromData: data)
      case .workoutSummaryData:
        return RowingWorkoutSummaryData(fromData: data)
      case .additionalWorkoutSummaryData:
        return RowingAdditionalWorkoutSummaryData(fromData: data)
      case .heartRateBeltInformation:
        return RowingHeartRateBeltInformation(fromData: data)
      case .mutliplexedInformation:
        return nil // JLC: this service gives the same data as the others
      }
    }
    else {
      return nil
    }
  }
}
