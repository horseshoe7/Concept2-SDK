//
//  PerformanceMonitorViewController.swift
//  Example-iOS
//
//  Created by Jesse Curry on 10/28/15.
//  Copyright © 2015 Bout Fitness, LLC. All rights reserved.
//

import UIKit
import Concept2_PM5

class PerformanceMonitorViewController: UIViewController {
    var performanceMonitor:PerformanceMonitor?
    
    var nameDisposable:Disposable?
    @IBOutlet var nameLabel:UILabel!
    
    var beatsPerMinuteDisposable:Disposable?
    //@IBOutlet var beatsPerMinuteLabel:UILabel!
    
    var wattsDisposable:Disposable?
    @IBOutlet var wattsLabel:UILabel!
    
    var speedDisposable: Disposable?
    @IBOutlet var speedLabel: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        attachObservers()
        updateUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        detachObservers()
    }
    
    @IBAction func dismissAction(_ sender:AnyObject?) {
        self.dismiss(animated: true) { () -> Void in
        }
    }
    
    // MARK: View Updates
    fileprivate func updateUI() {
        nameLabel.text = performanceMonitor?.peripheralName ?? "Unknown"
    }
    
    // MARK: Notifications
    fileprivate func attachObservers() {
        detachObservers()
        
//        beatsPerMinuteDisposable = performanceMonitor?.heartRate.attach({
//            [weak self] (strokeRate:C2HeartRate) -> Void in
//            if let weakSelf = self {
//                DispatchQueue.main.async {
//                    weakSelf.beatsPerMinuteLabel.text = "\(strokeRate)"
//                }
//            }
//        })
        
        wattsDisposable = performanceMonitor?.strokePower.attach({
            [weak self] (distance:C2Power) -> Void in
            if let weakSelf = self {
                DispatchQueue.main.async {
                    weakSelf.wattsLabel.text = "\(distance)"
                }
            }
        })
        
        speedDisposable = performanceMonitor?.speed.attach({ [weak self] (speed: C2Speed) in
            guard let `self` = self else { return }
            
            DispatchQueue.main.async {
                self.speedLabel.text = "\(String(format: "%.1f", speed))"
            }
        })
    }
    
    fileprivate func detachObservers() {
        nameDisposable?.dispose()
        beatsPerMinuteDisposable?.dispose()
        wattsDisposable?.dispose()
    }
}
