//
//  RowingStatusSampleRate.swift
//  Pods
//
//  Created by Jesse Curry on 10/27/15.
//
//

struct RowingStatusSampleRate: CharacteristicModel, CustomDebugStringConvertible {
  let DataLength = 1
  
  /*

  */
  
  var sampleRate:RowingStatusSampleRateType
  
  init(fromData data: Data) {
    var arr = [UInt8](repeating: 0, count: DataLength)
    (data as NSData).getBytes(&arr, length: DataLength)
    
    sampleRate = RowingStatusSampleRateType(rawValue: arr[0])!
  }
  
  // MARK: PerformanceMonitor
  func updatePerformanceMonitor(_ performanceMonitor:PerformanceMonitor) {
    performanceMonitor.sampleRate.value = sampleRate
  }
  
  // MARK: -
  var debugDescription:String {
    return "[RowingStatusSampleRate]\n\tsampleRate: \(sampleRate)"
  }
}

/*
  NSData extension to allow writing of this value
 */
extension Data {
  init(rowingStatusSampleRate:RowingStatusSampleRateType) {
    let arr:[UInt8] = [rowingStatusSampleRate.rawValue];
    self.init(arr)
//    (self as NSData).init(bytes: arr, length: arr.count * sizeof(UInt8))
  }
}
