//
//  PerformanceMonitorStore.swift
//  Pods
//
//  Created by Jesse Curry on 9/30/15.
//  Copyright © 2015 Bout Fitness, LLC. All rights reserved.
//

import CoreBluetooth

let PerformanceMonitorStoreDidAddItemNotification = "PerformanceMonitorStoreDidAddItemNotification"
let PerformanceMonitorStoreDidRemoveItemNotification = "PerformanceMonitorStoreDidRemoveItemNotification"

final class PerformanceMonitorStore {
  // Singleton
  static let sharedInstance = PerformanceMonitorStore()
  
  //////////////////////////////////////////////////////////////////////////////////////////////////
  var performanceMonitors = Set<PerformanceMonitor>()

  func addPerformanceMonitor(_ performanceMonitor:PerformanceMonitor) {
    performanceMonitors.insert(performanceMonitor)
    
    NotificationCenter.default.post(
      name: Notification.Name(rawValue: PerformanceMonitorStoreDidAddItemNotification),
      object: self)
  }
  
  func performanceMonitorWithPeripheral(_ peripheral:CBPeripheral) -> PerformanceMonitor? {
    var pm:PerformanceMonitor?
    
    performanceMonitors.forEach { (performanceMonitor:PerformanceMonitor) -> () in
      if performanceMonitor.peripheral == peripheral {
        pm = performanceMonitor
      }
    }
    
    return pm
  }
  
  func removePerformanceMonitor(_ performanceMonitor:PerformanceMonitor) {
    performanceMonitors.remove(performanceMonitor)
    
    NotificationCenter.default.post(
      name: Notification.Name(rawValue: PerformanceMonitorStoreDidRemoveItemNotification),
      object: self)
  }
}
