//
//  PM5DemoViewController.swift
//  Concept2SDK-iOSDemo
//
//  Created by Stephen O'Connor on 23.11.20.
//  Copyright © 2020 HomeTeam Software. All rights reserved.
//

import UIKit
import Concept2_PM5

/**
 
 View Legend of labels and names
 
    [timeElapsed]      | [paceValue] [paceUnit]
 ----------------------------------------------
           [primaryValue]   [primaryUnit]
 ----------------------------------------------
     [secondaryValue] [secondaryUnit]  |
 ==============================================
        [stat1Value] [stat1Unit]
 ----------------------------------------------
        [stat2Value] [stat2Unit]
 ----------------------------------------------
        [stat3Value] [stat3Unit]
 -
 
 */


/**
 On the PM5, there is a displayButton that toggles 4 modes:
 
 1:  Speed and Distance
 2: Speed
 3: Power
 4: Energy
 
 
 */

class PM5DemoViewController: UIViewController {

    var performanceMonitor: PerformanceMonitor?
    
    // MARK: Outlets
    @IBOutlet weak var timeElapsedLabel: UILabel!
    @IBOutlet weak var paceValueLabel: UILabel!
    @IBOutlet weak var paceUnitLabel: UILabel!
    @IBOutlet weak var primaryValueLabel: UILabel!
    @IBOutlet weak var primaryUnitLabel: UILabel!
    @IBOutlet weak var secondaryValueLabel: UILabel!
    @IBOutlet weak var secondaryUnitLabel: UILabel!
    @IBOutlet weak var stat1ValueLabel: UILabel!
    @IBOutlet weak var stat1UnitLabel: UILabel!
    @IBOutlet weak var stat2ValueLabel: UILabel!
    @IBOutlet weak var stat2UnitLabel: UILabel!
    @IBOutlet weak var stat3ValueLabel: UILabel!
    @IBOutlet weak var stat3UnitLabel: UILabel!
    
    // MARK: Observers / Disposables
    var speedObserver: Disposable?
    
    // Types:
    enum DisplayMode: Int {
        case speedAndDistance
        case speed
        case power
        case energy
    }
    
    struct Units {
        static let strokesPerMinute = "s/m"
        static let splitTime = "/ 500m"
        static let avgSplitTime = "ave\n/ 500m"
        static let currentSplitTime = "split\n/ 500m"
        static let meters = "m"
        static let splitMeters = "split/nmeters"
        static let projectedDistance = "projected\nm  30:00"
        static let watts = "watt"
        static let avgWatts = "ave\nwatt"
        static let splitWatt = "split\nwatt"
        static let caloriesPerHr = "Cal/hr"
        static let calories = "Cal"
        static let splitCalories = "split\nCal"
    }
    
    var displayMode: DisplayMode = .speedAndDistance {
        didSet {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        attachObservers()
        updateUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        detachObservers()
    }
    
    deinit {
        detachObservers()
    }
    
    // MARK: View Updates
    fileprivate func updateUI() {
        self.title = performanceMonitor?.peripheralName ?? "Unknown"
        
        // SET UNIT LABELS
        
        // common to all modes
        self.paceUnitLabel.text = Units.strokesPerMinute
        self.stat3UnitLabel.text = Units.projectedDistance
        
        // individual modes
        switch self.displayMode {
        case .speedAndDistance:
            self.primaryUnitLabel.text = Units.splitTime
            self.secondaryUnitLabel.text = Units.meters
            self.stat1UnitLabel.text = Units.avgSplitTime
            self.stat2UnitLabel.text = Units.splitMeters
            
        case .speed:
            self.primaryUnitLabel.text = Units.splitTime
            self.secondaryUnitLabel.text = Units.avgSplitTime
            self.stat1UnitLabel.text = Units.meters
            self.stat2UnitLabel.text = Units.currentSplitTime
            
        case .power:
            self.primaryUnitLabel.text = Units.watts
            self.secondaryUnitLabel.text = Units.avgWatts
            self.stat1UnitLabel.text = Units.meters
            self.stat2UnitLabel.text = Units.splitWatt
            
        case .energy:
            self.primaryUnitLabel.text = Units.caloriesPerHr
            self.secondaryUnitLabel.text = Units.calories
            self.stat1UnitLabel.text = Units.meters
            self.stat2UnitLabel.text = Units.splitCalories
        }
        
        
        // SET VALUE LABELS
        // common to all modes
        self.timeElapsedLabel.text = "Not Done"
        self.paceValueLabel.text = "NaN"
        self.stat3ValueLabel.text = "NaN"
        
        // individual modes
        switch self.displayMode {
        case .speedAndDistance:
            self.primaryValueLabel.text = "NaN"
            self.secondaryValueLabel.text = "NaN"
            self.stat1ValueLabel.text = "NaN"
            self.stat2ValueLabel.text = "NaN"
            
        case .speed:
            self.primaryValueLabel.text = "NaN"
            self.secondaryValueLabel.text = "NaN"
            self.stat1ValueLabel.text = "NaN"
            self.stat2ValueLabel.text = "NaN"
            
        case .power:
            self.primaryValueLabel.text = "NaN"
            self.secondaryValueLabel.text = "NaN"
            self.stat1ValueLabel.text = "NaN"
            self.stat2ValueLabel.text = "NaN"
            
        case .energy:
            self.primaryValueLabel.text = "NaN"
            self.secondaryValueLabel.text = "NaN"
            self.stat1ValueLabel.text = "NaN"
            self.stat2ValueLabel.text = "NaN"
        }
        
    }
    
    // MARK: Notifications
    fileprivate func attachObservers() {
        detachObservers()
        
        speedObserver = performanceMonitor?.speed.attach({ [weak self] (speed: C2Speed) in
            guard let `self` = self else { return }
            
            DispatchQueue.main.async { [unowned self] in
                
                switch self.displayMode {
                    case .speedAndDistance, .speed:
                        self.primaryValueLabel.text = "\(String(format: "%.1f", speed))"
                    default:
                        break
                }
            }
        })
    }
    
    fileprivate func detachObservers() {
        speedObserver?.dispose()
        
    }
    
    
    
    // MARK: Navigation
    @IBAction func dismissAction(_ sender:AnyObject?) {
        self.dismiss(animated: true) { () -> Void in
        }
    }
}
