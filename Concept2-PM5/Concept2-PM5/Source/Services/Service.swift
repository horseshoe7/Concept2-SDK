//
//  Services.swift
//  Pods
//
//  Created by Jesse Curry on 9/29/15.
//  Copyright © 2015 Bout Fitness, LLC. All rights reserved.
//

import CoreBluetooth

/**
 See: http://www.concept2.com/files/pdf/us/monitors/PM5_BluetoothSmartInterfaceDefinition.pdf
 */

public enum Service {
  case deviceDiscovery
  case deviceInformation
  case control
  case rowing
  
  init?(uuid: CBUUID) {
    switch uuid {
    case Service.deviceDiscovery.UUID:
      self = .deviceDiscovery
    case Service.deviceInformation.UUID:
      self = .deviceInformation
    case Service.control.UUID:
      self = .control
    case Service.rowing.UUID:
      self = .rowing
    default:
      return nil
    }
  }
  
  var UUID: CBUUID {
    switch self {
    case .deviceDiscovery:
      return CBUUID(string: "CE060000-43E5-11E4-916C-0800200C9A66")
    case .deviceInformation:
      return CBUUID(string: "CE060010-43E5-11E4-916C-0800200C9A66")
    case .control:
      return CBUUID(string: "CE060020-43E5-11E4-916C-0800200C9A66")
    case .rowing:
      return CBUUID(string: "CE060030-43E5-11E4-916C-0800200C9A66")
    }
  }
  
  var characteristicUUIDs: [CBUUID]? {
    switch self {
    case .deviceInformation:
      return [
        DeviceInformationCharacteristic.serialNumber.UUID,
        DeviceInformationCharacteristic.hardwareRevision.UUID,
        DeviceInformationCharacteristic.firmwareRevision.UUID,
        DeviceInformationCharacteristic.manufacturerName.UUID]
    case .control:
      return [
        ControlCharacteristic.response.UUID,
        ControlCharacteristic.command.UUID]
    case .rowing:
      return [
        RowingCharacteristic.generalStatus.UUID,
        RowingCharacteristic.additionalStatus1.UUID,
        RowingCharacteristic.additionalStatus2.UUID,
        RowingCharacteristic.statusSampleRate.UUID,
        RowingCharacteristic.strokeData.UUID,
        RowingCharacteristic.additionalStrokeData.UUID,
        RowingCharacteristic.intervalData.UUID,
        RowingCharacteristic.additionalIntervalData.UUID,
        RowingCharacteristic.workoutSummaryData.UUID,
        RowingCharacteristic.additionalWorkoutSummaryData.UUID,
        RowingCharacteristic.heartRateBeltInformation.UUID,
        RowingCharacteristic.mutliplexedInformation.UUID]
    default:
      return nil
    }
  }
  
  func characteristic(uuid: CBUUID) -> Characteristic? {
    switch self {
    case .deviceInformation:
      return DeviceInformationCharacteristic(uuid: uuid)
    case .control:
      return ControlCharacteristic(uuid: uuid)
    case .rowing:
      return RowingCharacteristic(uuid: uuid)
    default:
      return nil
    }
  }
}
