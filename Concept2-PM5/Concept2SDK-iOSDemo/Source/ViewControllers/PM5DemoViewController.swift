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
 
    [timeElapsed]      | [strokeRateValue] [strokeRateUnit]
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
    @IBOutlet weak var strokeRateValueLabel: UILabel!
    @IBOutlet weak var strokeRateUnitLabel: UILabel!
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
    
    @IBOutlet weak var displayModeButton: UIButton!
    
    // MARK: Observers / Disposables
    var elapsedTimeObserver: Disposable?
    var strokeRateObserver: Disposable?
    var projectedWorkDistanceObserver: Disposable?
    var currentPaceObserver: Disposable?
    var distanceObserver: Disposable?
    var averagePaceObserver: Disposable?
    var intervalDistanceObserver: Disposable?
    var intervalAveragePaceObserver: Disposable?
    var wattsObserver: Disposable?
    var intervalPowerObserver: Disposable?
    var averageCaloriesObserver: Disposable?
    var totalCaloriesObserver: Disposable?
    var intervalTotalCaloriesObserver: Disposable?
    
    // Types:
    
    struct Units {
        static let strokesPerMinute = "s/m"
        static let splitTime = "/ 500m"
        static let avgSplitTime = "ave\n/ 500m"
        static let currentSplitTime = "split\n/ 500m"
        static let meters = "m"
        static let splitMeters = "split\nmeters"
        static let projectedDistance = "projected\nm  30:00"
        static let watts = "watt"
        static let avgWatts = "ave\nwatt"
        static let splitWatt = "split\nwatt"
        static let caloriesPerHr = "Cal/hr"
        static let calories = "Cal"
        static let splitCalories = "split\nCal"
    }
    
    enum DisplayMode: Int {
        case speedAndDistance
        case speed
        case power
        case energy
    }
    
    var displayMode: DisplayMode = .speedAndDistance {
        didSet {
            updateUI(with: self.performanceMonitor)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        attachObservers()
        updateUI(with: self.performanceMonitor)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        detachObservers()
    }
    
    deinit {
        detachObservers()
    }
    
    // MARK: View Updates
    fileprivate func updateUI(with performanceMonitor: PerformanceMonitor?) {
        
        guard let pm = performanceMonitor else {
            return
        }
        
        self.title = pm.peripheralName
        
        // SET UNIT LABELS
        
        // common to all modes
        self.strokeRateUnitLabel.text = Units.strokesPerMinute
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
        self.timeElapsedLabel.text = pm.elapsedTime.value.asMinutesAndSeconds()
        self.strokeRateValueLabel.text = "\(pm.strokeRate.value)"
        self.stat3ValueLabel.text = "\(Int(pm.projectedWorkDistance.value))"
        
        // individual modes
        switch self.displayMode {
        case .speedAndDistance:
            self.primaryValueLabel.text = pm.currentPace.value.asMinutesAndSeconds()
            self.secondaryValueLabel.text = "\(Int(pm.distance.value))"
            self.stat1ValueLabel.text = pm.averagePace.value.asMinutesAndSeconds(decimalPlaces: 1)
            self.stat2ValueLabel.text = "\(Int(pm.intervalDistance.value))"
            
        case .speed:
            self.primaryValueLabel.text = pm.currentPace.value.asMinutesAndSeconds()
            self.secondaryValueLabel.text = pm.averagePace.value.asMinutesAndSeconds(decimalPlaces: 1)
            self.stat1ValueLabel.text = "\(Int(pm.intervalDistance.value))"
            self.stat2ValueLabel.text = pm.intervalAveragePace.value.asMinutesAndSeconds(decimalPlaces: 1)
            
        case .power:
            self.primaryValueLabel.text = "\(pm.watts.value)"
            self.secondaryValueLabel.text = "NaN" // ?? Unclear what goes here.
            self.stat1ValueLabel.text = "\(Int(pm.distance.value))"
            self.stat2ValueLabel.text = "\(pm.intervalPower.value)"
            
        case .energy:
            self.primaryValueLabel.text = "\(pm.averageCalories.value)"
            self.secondaryValueLabel.text = "\(pm.totalCalories.value)"
            self.stat1ValueLabel.text = "\(Int(pm.distance.value))"
            self.stat2ValueLabel.text = "\(pm.intervalTotalCalories.value)"
        }
    }
    
    // MARK: Notifications
    fileprivate func attachObservers() {
        detachObservers()
        
        elapsedTimeObserver = performanceMonitor?.elapsedTime.attach({ [weak self] (elapsedTime: C2TimeInterval) in
            guard let `self` = self else { return }
            DispatchQueue.main.async { [unowned self] in
                self.timeElapsedLabel.text = elapsedTime.asMinutesAndSeconds()
            }
        })
        strokeRateObserver = performanceMonitor?.strokeRate.attach({ [weak self] (strokeRate: C2StrokeRate) in
            guard let `self` = self else { return }
            DispatchQueue.main.async { [unowned self] in
                self.strokeRateValueLabel.text = "\(strokeRate)"
            }
        })
        projectedWorkDistanceObserver = performanceMonitor?.projectedWorkDistance.attach({ [weak self] (projectedWorkDistance: C2Distance) in
            guard let `self` = self else { return }
            DispatchQueue.main.async { [unowned self] in
                self.stat3ValueLabel.text = "\(Int(projectedWorkDistance))"
            }
        })
        currentPaceObserver = performanceMonitor?.currentPace.attach({ [weak self] (currentPace: C2Pace) in
            guard let `self` = self else { return }
            DispatchQueue.main.async { [unowned self] in
                switch self.displayMode {
                case .speed, .speedAndDistance:
                    self.primaryValueLabel.text = currentPace.asMinutesAndSeconds()
                    default:
                        break
                }
            }
        })
        distanceObserver = performanceMonitor?.distance.attach({ [weak self] (distance: C2Distance) in
            guard let `self` = self else { return }
            DispatchQueue.main.async { [unowned self] in
                switch self.displayMode {
                case .speed:
                    self.secondaryValueLabel.text = "\(Int(distance))"
                case .energy, .power:
                    self.stat1ValueLabel.text = "\(Int(distance))"
                    default:
                        break
                }
            }
        })
        averagePaceObserver = performanceMonitor?.averagePace.attach({ [weak self] (averagePace: C2Pace) in
            guard let `self` = self else { return }
            DispatchQueue.main.async { [unowned self] in
                switch self.displayMode {
                case .speed:
                    self.secondaryValueLabel.text = averagePace.asMinutesAndSeconds(decimalPlaces: 1)
                case .speedAndDistance:
                    self.stat1ValueLabel.text = averagePace.asMinutesAndSeconds(decimalPlaces: 1)
                    default:
                        break
                }
            }
        })
        intervalDistanceObserver = performanceMonitor?.intervalDistance.attach({ [weak self] (intervalDistance: C2Distance) in
            guard let `self` = self else { return }
            DispatchQueue.main.async { [unowned self] in
                switch self.displayMode {
                    case .speedAndDistance:
                        self.stat2ValueLabel.text = "\(Int(intervalDistance))"
                    case .speed:
                        self.stat1ValueLabel.text = "\(Int(intervalDistance))"
                    default:
                        break
                }
            }
        })
        intervalAveragePaceObserver = performanceMonitor?.intervalAveragePace.attach({ [weak self] (intervalAveragePace: C2Pace) in
            guard let `self` = self else { return }
            DispatchQueue.main.async { [unowned self] in
                switch self.displayMode {
                    case .speed:
                        self.stat2ValueLabel.text = intervalAveragePace.asMinutesAndSeconds(decimalPlaces: 1)
                    default:
                        break
                }
            }
        })
        wattsObserver = performanceMonitor?.watts.attach({ [weak self] (watts: C2Power) in
            guard let `self` = self else { return }
            DispatchQueue.main.async { [unowned self] in
                switch self.displayMode {
                case .power:
                    self.primaryValueLabel.text = "\(watts)"
                default:
                        break
                }
            }
        })
        intervalPowerObserver = performanceMonitor?.intervalPower.attach({ [weak self] (intervalPower: C2Power) in
            guard let `self` = self else { return }
            DispatchQueue.main.async { [unowned self] in
                switch self.displayMode {
                    case .power:
                    self.stat2ValueLabel.text = "\(intervalPower)"
                    default:
                        break
                }
            }
        })
        averageCaloriesObserver = performanceMonitor?.averageCalories.attach({ [weak self] (averageCalories: C2CalorieCount) in
            guard let `self` = self else { return }
            DispatchQueue.main.async { [unowned self] in
                switch self.displayMode {
                    case .energy:
                        self.primaryValueLabel.text = "\(averageCalories)"
                    default:
                        break
                }
            }
        })
        totalCaloriesObserver = performanceMonitor?.totalCalories.attach({ [weak self] (totalCalories: C2CalorieCount) in
            guard let `self` = self else { return }
            DispatchQueue.main.async { [unowned self] in
                switch self.displayMode {
                    case .energy:
                    self.secondaryValueLabel.text = "\(totalCalories)"
                    default:
                        break
                }
            }
        })
        intervalTotalCaloriesObserver = performanceMonitor?.intervalTotalCalories.attach({ [weak self] (intervalTotalCalories: C2CalorieCount) in
            guard let `self` = self else { return }
            DispatchQueue.main.async { [unowned self] in
                switch self.displayMode {
                    case .energy:
                    self.stat2ValueLabel.text = "\(intervalTotalCalories)"
                    default:
                        break
                }
            }
        })
    }
    
    fileprivate func detachObservers() {
        
        elapsedTimeObserver?.dispose()
        strokeRateObserver?.dispose()
        projectedWorkDistanceObserver?.dispose()
        currentPaceObserver?.dispose()
        distanceObserver?.dispose()
        averagePaceObserver?.dispose()
        intervalDistanceObserver?.dispose()
        intervalAveragePaceObserver?.dispose()
        wattsObserver?.dispose()
        intervalPowerObserver?.dispose()
        averageCaloriesObserver?.dispose()
        totalCaloriesObserver?.dispose()
        intervalTotalCaloriesObserver?.dispose()
    }
    
    
    
    // MARK: Button Actions
    @IBAction
    func dismissAction(_ sender:AnyObject?) {
        self.dismiss(animated: true) { () -> Void in
        }
    }
    
    @IBAction
    func displayButtonPressed(_ sender: Any?) {
        var currentRawMode = self.displayMode.rawValue
        currentRawMode += 1
        if let newMode = DisplayMode(rawValue: currentRawMode) {
            self.displayMode = newMode
        } else {
            currentRawMode = 0
            self.displayMode = DisplayMode(rawValue: 0)!
        }
    }
    
}

fileprivate let formatter: NumberFormatter = {
   let formatter = NumberFormatter()
    formatter.minimumIntegerDigits = 2 // leading zeroes.
    formatter.allowsFloats = true
    formatter.maximumFractionDigits = 0
    return formatter
}()

extension Double {
    
    public func asMinutesAndSeconds(decimalPlaces: Int = 0) -> String {
        
        if self.isNaN {
            return ""
        }
        
        let fullSeconds = Int(self)
        
        let wholeNumberFormat = "%02d"  // will have leading zeroes, i.e. 01
        if fullSeconds < 60 {
            return ":\(String(format: wholeNumberFormat, fullSeconds))"
        }

        let minutes = fullSeconds / 60
        let seconds = fullSeconds % 60

        if decimalPlaces <= 0 {
            return "\(minutes):\(String(format: wholeNumberFormat, seconds))"
        } else {
            let floatingSeconds = self.fraction + Double(seconds)
            formatter.maximumFractionDigits = decimalPlaces
            let secondsString = formatter.string(from: floatingSeconds as NSNumber) ?? ""
            return "\(minutes):\(secondsString)"
        }
    }
}

extension FloatingPoint {
    var whole: Self { modf(self).0 }
    var fraction: Self { modf(self).1 }
}
