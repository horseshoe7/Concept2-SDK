//
//  BluetoothManager.swift
//  Pods
//
//  Created by Jesse Curry on 9/29/15.
//
//

import CoreBluetooth

public final class BluetoothManager
{
  public static let sharedInstance = BluetoothManager()
  
  public static func scanForPerformanceMonitors() {
    sharedInstance.scanForPerformanceMonitors()
  }
  
  public static func stopScanningForPerformanceMonitors() {
    sharedInstance.stopScanningForPerformanceMonitors()
  }
  
  public static func connectPerformanceMonitor(_ performanceMonitor:PerformanceMonitor,
    exclusive:Bool) {
      sharedInstance.connectPerformanceMonitor(performanceMonitor, exclusive: exclusive)
  }
  
  public static func connectPerformanceMonitor(_ performanceMonitor:PerformanceMonitor) {
    sharedInstance.connectPerformanceMonitor(performanceMonitor)
  }
  
  public static func disconnectPerformanceMonitor(_ performanceMonitor:PerformanceMonitor) {
    sharedInstance.disconnectPerformanceMonitor(performanceMonitor)
  }
  
  public static var isReady:Subject<Bool> {
    get {
      return sharedInstance.isReady
    }
  }
  
  public static var performanceMonitors:Subject<Array<PerformanceMonitor>> {
    get {
      return sharedInstance.performanceMonitors
    }
  }
  
  fileprivate let isReady = Subject<Bool>(value: false)
  fileprivate let performanceMonitors = Subject<Array<PerformanceMonitor>>(value: Array<PerformanceMonitor>())
  
  // MARK: -
  fileprivate var centralManager:CBCentralManager
  fileprivate var centralManagerDelegate:CentralManagerDelegate
  fileprivate let centralManagerQueue = DispatchQueue(
    label: "com.boutfitness.concept2.bluetooth.central",
    attributes: DispatchQueue.Attributes.concurrent
  )
  
  // MARK: Initialization
  init() {
    centralManagerDelegate = CentralManagerDelegate()
    centralManager = CBCentralManager(delegate: centralManagerDelegate,
      queue: centralManagerQueue)
    
    self.isReady.value = (centralManager.state == CBManagerState.poweredOn)
    
    //
    NotificationCenter.default.addObserver(
      forName: NSNotification.Name(rawValue: PerformanceMonitorStoreDidAddItemNotification),
      object: PerformanceMonitorStore.sharedInstance,
      queue: nil) { [weak self] (notification) -> Void in
        if let weakSelf = self {
          DispatchQueue.main.async(execute: { () -> Void in
            weakSelf.performanceMonitors.value = Array(PerformanceMonitorStore.sharedInstance.performanceMonitors)
          })
        }
    }
  }
  
  func scanForPerformanceMonitors() {
    centralManager.scanForPeripherals(withServices: [Service.deviceDiscovery.UUID],
      options: nil)
  }
  
  func stopScanningForPerformanceMonitors() {
    centralManager.stopScan()
  }
  
  func connectPerformanceMonitor(_ performanceMonitor:PerformanceMonitor, exclusive:Bool) {
    // TODO: use the PerformanceMonitor abstraction instead of peripherals
    if exclusive == true {
      centralManager.retrieveConnectedPeripherals(withServices: [Service.deviceDiscovery.UUID])
        .forEach { (peripheral) -> () in
        if peripheral.state == .connected {
          if peripheral != performanceMonitor.peripheral {
            centralManager.cancelPeripheralConnection(peripheral)
          }
        }
      }
    }
    
    centralManager.connect(performanceMonitor.peripheral, options: nil)
  }
  
  func connectPerformanceMonitor(_ performanceMonitor:PerformanceMonitor) {
    self.connectPerformanceMonitor(performanceMonitor, exclusive: true)
  }
  
  func disconnectPerformanceMonitor(_ performanceMonitor:PerformanceMonitor) {
    centralManager.cancelPeripheralConnection(performanceMonitor.peripheral)
  }
}
