//
//  PeripheralDelegate.swift
//  Pods
//
//  Created by Jesse Curry on 9/30/15.
//  Copyright © 2015 Bout Fitness, LLC. All rights reserved.
//

import CoreBluetooth

final class PeripheralDelegate: NSObject, CBPeripheralDelegate {
    
  weak var performanceMonitor: PerformanceMonitor?
  
  // MARK: Services
  func peripheral(_ peripheral: CBPeripheral,
    didDiscoverServices
    error: Error?) {
      log.debug("[PerformanceMonitor]didDiscoverServices:")
      peripheral.services?.forEach({ (service:CBService) -> () in
        log.debug("\t* \(service.description)")

        if let svc = Service(uuid: service.uuid) {
          peripheral.discoverCharacteristics(svc.characteristicUUIDs,
            for:  service)
        }
      })
  }
  
  func peripheral(_ peripheral: CBPeripheral,
    didDiscoverIncludedServicesFor
    service: CBService,
    error: Error?) {
      log.debug("[PerformanceMonitor]didDiscoverIncludedServicesForService")
  }
  
  func peripheral(_ peripheral: CBPeripheral,
    didModifyServices
    invalidatedServices: [CBService]) {
      log.debug("[PerformanceMonitor]didModifyServices")
  }
  
  // MARK: Characteristics
  func peripheral(_ peripheral: CBPeripheral,
    didDiscoverCharacteristicsFor
    service: CBService,
    error: Error?) {
      log.debug("[PerformanceMonitor]didDiscoverCharacteristicsForService")
      service.characteristics?.forEach({ (characteristic:CBCharacteristic) -> () in
        peripheral.setNotifyValue(true, for: characteristic)
      })
  }
  
  func peripheral(_ peripheral: CBPeripheral,
    didDiscoverDescriptorsFor
    characteristic: CBCharacteristic,
    error: Error?) {
      log.debug("[PerformanceMonitor]didDiscoverDescriptorsForCharacteristic")
  }
  
  func peripheral(_ peripheral: CBPeripheral,
    didUpdateValueFor
    characteristic: CBCharacteristic,
    error: Error?) {
      log.debug("[PerformanceMonitor]didUpdateValueForCharacteristic: \(characteristic)")
      if let svc = Service(uuid: characteristic.service.uuid) {
        if let c = svc.characteristic(uuid: characteristic.uuid) {
          let cm = c.parse(data: characteristic.value)
          if let pm = performanceMonitor {
            cm?.updatePerformanceMonitor(pm)
          }
        }
      }
  }
  
  func peripheral(_ peripheral: CBPeripheral,
    didUpdateValueFor
    descriptor: CBDescriptor,
    error: Error?) {
      log.debug("[PerformanceMonitor]didUpdateValueForDescriptor")
  }
  
  func peripheral(_ peripheral: CBPeripheral,
    didWriteValueFor
    characteristic: CBCharacteristic,
    error: Error?) {
      log.debug("[PerformanceMonitor]didWriteValueForCharacteristic")
  }
  
  func peripheral(_ peripheral: CBPeripheral,
    didWriteValueFor
    descriptor: CBDescriptor,
    error: Error?) {
      log.debug("[PerformanceMonitor]didWriteValueForDescriptor")
  }
  
  func peripheral(_ peripheral: CBPeripheral,
    didUpdateNotificationStateFor
    characteristic: CBCharacteristic,
    error: Error?) {
      log.debug("[PerformanceMonitor]didUpdateNotificationStateForCharacteristic")
  }
  
  // MARK: Signal Strength
  func peripheralDidUpdateRSSI(_ peripheral: CBPeripheral,
    error: Error?) {
      log.debug("[PerformanceMonitor]didUpdateRSSI")
  }
  
  // MARK: Name
  func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
    log.debug("[PerformanceMonitor]didUpdateName")
  }
}
