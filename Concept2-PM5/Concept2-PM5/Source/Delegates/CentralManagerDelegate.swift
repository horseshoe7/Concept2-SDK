//
//  CentralManagerDelegate.swift
//  Pods
//
//  Created by Jesse Curry on 9/30/15.
//  Copyright © 2015 Bout Fitness, LLC. All rights reserved.
//

import Foundation
import CoreBluetooth

final class CentralManagerDelegate: NSObject, CBCentralManagerDelegate {
  // MARK: Central Manager Status
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    
    switch central.state {
    case .unknown:
      log.debug("[BluetoothManager]state: unknown")
      break
    case .resetting:
      log.debug("[BluetoothManager]state: resetting")
      break
    case .unsupported:
      log.debug("[BluetoothManager]state: not available")
      break
    case .unauthorized:
      log.debug("[BluetoothManager]state: not authorized")
      break
    case .poweredOff:
      log.debug("[BluetoothManager]state: powered off")
      break
    case .poweredOn:
      log.debug("[BluetoothManager]state: powered on")
      break
    @unknown default:
      fatalError("[BluetoothManager]state: unknown")
    }
    
    BluetoothManager.isReady.value = (central.state == .poweredOn)
  }
  
  // MARK: Peripheral Discovery
  func centralManager(_ central: CBCentralManager,
    didDiscover
    peripheral: CBPeripheral,
    advertisementData: [String : Any],
    rssi RSSI: NSNumber) {
    
    log.debug("[BluetoothManager]didDiscoverPeripheral \(peripheral)")
    PerformanceMonitorStore.sharedInstance.addPerformanceMonitor(
      PerformanceMonitor(withPeripheral: peripheral)
    )
  }
  
  // MARK: Peripheral Connections
  func centralManager(_ central: CBCentralManager,
    didConnect
    peripheral: CBPeripheral) {
    
    log.debug("[BluetoothManager]didConnectPeripheral")
    peripheral.discoverServices([
      Service.deviceDiscovery.UUID,
      Service.deviceInformation.UUID,
      Service.control.UUID,
      Service.rowing.UUID])
    postPerformanceMonitorNotificationForPeripheral(peripheral)
  }
  
  func centralManager(_ central: CBCentralManager,
    didFailToConnect
    peripheral: CBPeripheral,
    error: Error?) {
    
      log.debug("[BluetoothManager]didFailToConnectPeripheral")
      postPerformanceMonitorNotificationForPeripheral(peripheral)
  }
  
  func centralManager(_ central: CBCentralManager,
    didDisconnectPeripheral
    peripheral: CBPeripheral,
    error: Error?) {
    
      log.debug("[BluetoothManager]didDisconnectPeripheral")
      postPerformanceMonitorNotificationForPeripheral(peripheral)
  }
  
  // MARK: -
  
  fileprivate func postPerformanceMonitorNotificationForPeripheral(_ peripheral: CBPeripheral) {
    let performanceMonitorStore = PerformanceMonitorStore.sharedInstance
    if let pm = performanceMonitorStore.performanceMonitorWithPeripheral(peripheral) {
      pm.updatePeripheralObservers()
      NotificationCenter.default.post(
        name: Notification.Name(rawValue: PerformanceMonitor.DidUpdateStateNotification),
        object: pm)
    }
  }
}
