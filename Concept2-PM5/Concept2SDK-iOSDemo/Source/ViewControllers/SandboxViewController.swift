//
//  SandboxViewController.swift
//  Concept2SDK-iOSDemo
//
//  Created by Stephen O'Connor on 20.11.20.
//  Copyright © 2020 HomeTeam Software. All rights reserved.
//

import UIKit

class SandboxViewController: UIViewController {

    @IBOutlet weak var plotView: PlotStripView!
    
    var updateTimer: Timer?
    var timerTick = 0
    
    let interval = TimeInterval(0.01)
    let numIncrementsPerPeriod = TimeInterval(40)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.plotView.baselineValue = 0.0
        self.plotView.verticalContentMode = .fitFull
        self.plotView.deltaXPerScreenPoint = CGFloat(interval / 5)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startUpdates()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateTimer?.invalidate()
    }
    
    private func startUpdates() {
        self.plotView.clear()
        updateTimer?.invalidate()
        updateTimer = Timer.scheduledTimer(withTimeInterval: self.interval, repeats: true, block: { [weak self] (_) in
            guard let `self` = self else { return }
            let x: CGFloat = CGFloat(self.interval) * CGFloat(self.timerTick)
            
            // sine wave
            //let y: CGFloat = sin( (x / CGFloat(self.numIncrementsPerPeriod * self.interval)) * 2 * CGFloat.pi)  // 20 is how many points you want on the sine curve
            
            // random +ve scatter plot
            let y = CGFloat(arc4random_uniform(25) + 75)/100.0
            
            //log.debug("Append: (\(String(format: "%.2f", x)), \(String(format: "%.2f", y)))")
            self.plotView.append(CGPoint(x: x, y: y))
            self.timerTick += 1
        })
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
