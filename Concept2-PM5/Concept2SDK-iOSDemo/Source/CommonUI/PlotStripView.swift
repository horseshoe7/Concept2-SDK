//
//  PlotStripView.swift
//  Concept2SDK-iOSDemo
//
//  Created by Stephen O'Connor on 20.11.20.
//  Copyright © 2020 HomeTeam Software. All rights reserved.
//

import UIKit

public protocol PlotStripViewDelegate {
    
    /// return nil if you want to have PlotStripView generate its own
    /// and/or set `.displaysDotOnCurrentValue` to false to have no dot.
    func dotForCurrentValue(in plotStripView: PlotStripView) -> UIImage?
}

public class PlotStripView: UIView {
    
    // MARK: - Public Members
    
    /// aspects of the view that affect its appearance
    public struct Configuration {
        
        /// color of the plotted line
        public var lineColor: UIColor = .white
        
        /// width of the plotted line
        public var lineWidth: CGFloat = 1.0
        
        /// place a tick on the x axis after every deltaX...  set to  zero or less to have no ticks
        public var xAxisMinorTickEveryDeltaX: Double = 0.0
        
        /// will place a labeled tick every deltaX.  If coincident with a minor tick, minor tick ignored. Set to zero or less for no major ticks.
        public var xAxisMajorTickEveryDeltaX: Double = 0.0
        
        /// this guarantees that automatically generated ticks in non-dynamic modes won't end up squished together
        public var minimumTickDistanceInPoints: Double = 20
        
        /// if you want to display no dot, set `.displaysDotOnCurrentValue` to `false`
        public var dotColor: UIColor = .white
        
        /// the size of the dot for the current value.
        public var dotRadius: CGFloat = 5.0
        
        /// set to nil to show no baseline
        public var baselineColor: UIColor? = .lightGray
        
        /// the width of the drawn baseline
        public var baselineWidth: CGFloat = 1.0
        
        /// will be drawn as hairlines (width)
        public var minorTickColor: UIColor? = .darkGray
        
        /// will be drawn as hairlines (width)
        public var majorTickColor: UIColor? = .gray
    }
    
    public var configuration: Configuration = Configuration() {
        didSet {
            updateDisplay()
        }
    }

    /// How the data will be displayed
    public enum HorizontalContentMode: Int {
        /// the most current value being visible at the right
        case leading
        
        /// the most current value being visible at the center.  It's basically like leading except
        case centered
        
        /// this will ignore a lot of the axes settings and fit all data onto the plot.
        case fit
        
        var isDynamic: Bool {
            return self == .leading || self == .centered
        }
    }
    public var horizontalContentMode: HorizontalContentMode = .leading {
        didSet {
            updateDisplay()
        }
    }
    
    public enum VerticalContentMode: Int {
        // the entire range of the data will be fit, including zero.  If values cross baselineValue, then the y axis will be 2* the largest Y from that baseline.
        case fitFull
        
        // the entire range of the data will be fit, with // markers if well above zero.
        case fitRange
        
        // the data will be fit between .maxY and .minY and values outside of that range will be clamped to those values
        case clamp
    }
    public var verticalContentMode: VerticalContentMode = .clamp {
        didSet {
            updateDisplay()
        }
    }
    
    /// can also use delegate to provide a custom dot.  Otherwises Configuration
    public var displaysDotOnCurrentValue: Bool = false {
        didSet {
            updateDisplay()
        }
    }
    
    /// how much X of your data set takes up one point on screen
    /// is only relevant for dynamic horizontal modes
    /// this delta X determines how much data will be visible in the plot.
    /// you would typically set this to your data's x interval between points
    
    public var deltaXPerScreenPoint: CGFloat = 1.0 {
        didSet {
            updateDisplay()
        }
    }
    
    /// if `.verticalContentMode` is `.clamped`, then this is what it would get clamped to.
    public var maxY: CGFloat = 1.0 {
        didSet {
            updateDisplay()
        }
    }
    
    /// if `.verticalContentMode` is `.clamped`, then this is what it would get clamped to.
    public var minY: CGFloat = -1.0 {
        didSet {
            updateDisplay()
        }
    }
    
    public var baselineValue: CGFloat = 0.0 {
        didSet {
            updateDisplay()
        }
    }
    
    /// prevents the data array from getting too big.  basically during a rendering pass, if it gets to the end of the data set because of screen space, it will remove all those old entries
    public var removeDataNotDisplayed = true
    
    // MARK: - Private Members
    
    /// the underlying data set for rendering
    private var _data: RingBuffer<CGPoint>? = nil
    private var data: RingBuffer<CGPoint> {
        if _data == nil {
            let requiredCount = Int(ceil(self.bounds.size.width))  // assume we append at no more than deltaXPerPoint.
            _data = RingBuffer<CGPoint>(count: requiredCount)
        }
        return _data!
    }
    
    /// used for rendering
    private var _isViewDirty = false
    private var _leadingXMargin: CGFloat = 20
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        //createDisplayLink()
        applyDefaults()
    }
    
    private var displayLink: CADisplayLink?
    private func createDisplayLink() {
        let displayLink = CADisplayLink(target: self, selector: #selector(step))
        displayLink.preferredFramesPerSecond = 30
        displayLink.add(to: .current, forMode: .default)
        self.displayLink = displayLink
    }
    
    private func applyDefaults() {
        
    }
    
    // MARK: - Public Methods
    
    /// Clears plot history
    public func clear() {
        _data = nil
        self.updateDisplay()
    }
    
    public var dataCount: Int {
        return self.data.count
    }
    
    public func append(_ dataPoint: CGPoint) {
        _data?.write(dataPoint)
        self.updateDisplay()
    }
    
    private func updateDisplay() {
        _isViewDirty = true
        
        if self.displayLink == nil {
            self.setNeedsDisplay()
        }
    }
    
    @objc
    private func step(displayLink: CADisplayLink) {
        if _isViewDirty {
            self.setNeedsDisplay()
        }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override public func draw(_ rect: CGRect) {
        
        // enumerate data backwards
        
        // determine starting X in view based on horizontalContentMode
        let startingX: CGFloat
        if self.horizontalContentMode == .centered {
            startingX = self.bounds.size.width / 2
        } else if self.horizontalContentMode == .leading {
            startingX = max(CGFloat(0), self.bounds.size.width - _leadingXMargin)
        } else {
            startingX = self.bounds.size.width
        }
        
        let maxY: CGFloat
        let minY: CGFloat
        
        if self.verticalContentMode == .clamp {
            maxY = self.maxY
            minY = self.minY
        } else {
            // go through the data array and find the largest and smallest Y
            let values = self.data.array.compactMap({ $0 })
            maxY = values.reduce(-CGFloat.greatestFiniteMagnitude) { $1.y > $0 ? $1.y : $0 }
            minY = values.reduce(CGFloat.greatestFiniteMagnitude) { $1.y < $0 ? $1.y : $0 }
        }
        
        // reversed enumerated means index == 0 is the last element in the _data array and as index increases
        // you are going backwards in the array
        var viewPoint = CGPoint.zero
        var startingDataPoint: CGPoint = .zero
    
        let path = UIBezierPath()
        
        let count = self.dataCount
        self.data.forEach { (index, dataPoint) -> Bool in
            
            //print("Plotting point at index: \(index), numElements: \(count)")
            
            // dataY will be in between maxY and minY
            let dataY: CGFloat = max(minY, min(maxY, dataPoint.y))
            viewPoint.y = self.bounds.size.height * (1.0 - ((dataY - minY) / (maxY - minY)))
            
            if index == 0 {
                startingDataPoint = dataPoint
                viewPoint.x = startingX
                path.move(to: viewPoint)
            } else {
                
                // calculate the deltaX, then calculate, based on deltaXInPoints, where that new point should be from the old one
                let deltaX = startingDataPoint.x - dataPoint.x
                viewPoint.x = startingX - deltaX/self.deltaXPerScreenPoint
                path.addLine(to: viewPoint)
                
                // only draw what needs to be drawn
                if viewPoint.x < 0 {
                    return false
                }
            }
            return true
        }
        
        self.configuration.lineColor.setStroke()
        path.lineWidth = self.configuration.lineWidth
        path.stroke()
        
        _isViewDirty = false
    }
}


public struct RingBuffer<T> {
    fileprivate var array: [T?]
    fileprivate var writeIndex = 0
    
    public init(count: Int) {
        array = [T?](repeating: nil, count: count)
    }
    
    public mutating func write(_ element: T) {
        array[writeIndex] = element
        writeIndex += 1
        if writeIndex >= array.count {
            writeIndex = 0
        }
    }
    
    public var count: Int {
        let existingValues = self.array.compactMap({$0})
        return existingValues.count
    }
    
    // in your block you return a bool of whether it should continue
    public func forEach(each: ((_ indexFromCurrent: Int, _ element: T) -> Bool)) {
        // you basically want to start at writeIndex and go backwards
        
        let copiedArray = array
        var startIndex = writeIndex  // gets decremented in for loop
        
        var indexFromCurrent = 0
        let count = copiedArray.count
        enumeration: for i in 0..<count {

            startIndex = startIndex - 1
            if startIndex < 0 {
                startIndex = count - 1
            }
            
            if let element = copiedArray[startIndex] {
                let shouldContinue = each(indexFromCurrent, element)
                indexFromCurrent += 1
                if !shouldContinue {
                    break enumeration
                }
            }
        }
    }
}
