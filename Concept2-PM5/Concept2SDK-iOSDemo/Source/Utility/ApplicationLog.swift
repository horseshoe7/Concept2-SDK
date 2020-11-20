//
//  ApplicationLog.swift
//  Concept2SDK-iOSDemo
//
//  Created by Stephen O'Connor on 20.11.20.
//  Copyright © 2020 HomeTeam Software. All rights reserved.
//

import Foundation
import Concept2_PM5
import XCGLogger

let log: XCGLogger = {
    let log = XCGLogger(identifier: "Concept2-iOS-Log", includeDefaultDestinations: false)
    
    // Create a destination for the system console log (via NSLog)
    let systemDestination = ConsoleDestination(identifier: log.identifier+".console")
    
    let verbose = true
    
    if !verbose {
        // Optionally set some configuration options
        systemDestination.outputLevel = .debug
        systemDestination.showLogIdentifier = false
        systemDestination.showFunctionName = true
        systemDestination.showThreadName = false
        systemDestination.showLevel = true
        systemDestination.showFileName = false
        systemDestination.showLineNumber = false
        systemDestination.showDate = true
    } else {
        // Optionally set some configuration options
        systemDestination.outputLevel = .verbose
        systemDestination.showLogIdentifier = false
        systemDestination.showFunctionName = false
        systemDestination.showThreadName = false
        systemDestination.showLevel = false
        systemDestination.showFileName = false
        systemDestination.showLineNumber = false
        systemDestination.showDate = false
    }
    

    
    // Add the destination to the logger
    log.add(destination: systemDestination)
    
    DispatchQueue.main.async {
        addTextViewLogger(to: log)
    }
    
    // Create a file log destination
    
    var useFileLogger = true
    if useFileLogger {
    
        truncateExistingLogFileIfNecessary()
        
        let fileDestination = FileDestination(owner: nil,
                                              writeToFile: defaultLogFilePath(),
                                              identifier: log.identifier+".fileLog",
                                              shouldAppend: true,
                                              appendMarker: "-- ** ** ** --",
                                              attributes: nil)
        
        // Optionally set some configuration options
        fileDestination.outputLevel = .debug
        fileDestination.showLogIdentifier = false
        fileDestination.showFunctionName = true
        fileDestination.showThreadName = true
        fileDestination.showLevel = true
        fileDestination.showFileName = true
        fileDestination.showLineNumber = true
        fileDestination.showDate = true
        
        // Process this destination in the background
        fileDestination.logQueue = XCGLogger.logQueue
        
        // Add the destination to the logger
        log.add(destination: fileDestination)
        
    }
    
    Concept2_PM5.log = log
    
    // Add basic app info, version info etc, to the start of the logs
    log.logAppDetails()
    
    return log
}()

func defaultLogFilePath() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let cachesPath = paths.first!
    let logPath = (cachesPath as NSString).appendingPathComponent("applicationLog.txt")
    return logPath
}

// if the log has grown to exceed a certain size, the file will be opened and only the latter half of its data retained.
// test it by putting in a low default value, like 600.  So far it's verfied to work.
func truncateExistingLogFileIfNecessary(dataLimitInBytes: Int = 1048576) {
    
    guard FileManager.default.fileExists(atPath: defaultLogFilePath()) else {
        return
    }
    
    let logFilePath = defaultLogFilePath()
    if let fileSize = (try? FileManager.default.attributesOfItem(atPath: logFilePath))?[.size] as? Int {
        if fileSize > dataLimitInBytes {
            // load the content, get a substring at the halfway point, write that content out to the same location.
            // we know that the string is written in utf8
            if let existingContent = try? String(contentsOfFile: logFilePath, encoding: .utf8) {
                let newContent = "---TRUNCATED BEFORE---\n\n" + (existingContent as NSString).substring(from: existingContent.count / 2)
                
                if let data = newContent.data(using: .utf8) {
                    let writeURL = URL(fileURLWithPath: logFilePath)
                    try? data.write(to: writeURL)
                }
            }
        }
    }
}


// MARK: - Extensions for TextView Logging

var loggingTextView: UITextView?

func addTextViewLogger(to log: XCGLogger) {
    
    let textView = UITextView()
    textView.font = UIFont(name: "Courier", size: 11)!
    textView.isEditable = false
    
    loggingTextView = textView
    
    log.add(destination: XCGLogger.XCGTextViewLogDestination(textView: textView, owner: log, identifier: "advancedLogger.textview"))
}


extension XCGLogger {
    
    public class XCGTextViewLogDestination: DestinationProtocol {
        
        public var owner: XCGLogger?
        public var identifier: String
        public var outputLevel: XCGLogger.Level = .debug
        
        public var showThreadName: Bool = false
        public var showFileName: Bool = true
        public var showLineNumber: Bool = true
        public var showLogLevel: Bool = true
        
        public var haveLoggedAppDetails: Bool = false
        public var formatters: [LogFormatterProtocol]? = []
        public var filters: [FilterProtocol]? = []
        
        public var textView: UITextView
        
        public init(textView: UITextView, owner: XCGLogger, identifier: String = "") {
            self.textView = textView
            self.owner = owner
            self.identifier = identifier
        }
        
        public func process(logDetails: LogDetails) {
            var extendedDetails: String = ""
            
            if showThreadName {
                extendedDetails += "[" + (Thread.isMainThread ? "main": (Thread.current.name! != "" ? Thread.current.name! : String(format: "%p", Thread.current))) + "] "
            }
            
            if showLogLevel {
                extendedDetails += "[" + logDetails.level.description + "] "
            }
            
            if showFileName {
                let filename = NSURL(fileURLWithPath: logDetails.fileName).lastPathComponent!
                extendedDetails += "[" + filename + (showLineNumber ? ":" + String(logDetails.lineNumber) : "") + "] "
            } else if showLineNumber {
                extendedDetails += "[" + String(logDetails.lineNumber) + "] "
            }
            
            var formattedDate: String = logDetails.date.description
            if let dateFormatter = owner!.dateFormatter {
                formattedDate = dateFormatter.string(from: logDetails.date)
            }
            
            let fullLogMessage: String =  "\(formattedDate) \(extendedDetails)\(logDetails.functionName): \(logDetails.message)\n"
            
            DispatchQueue.main.async { [weak self] in
                self?.textView.text += fullLogMessage
            }
        }
        
        public func processInternal(logDetails: LogDetails) {
            var extendedDetails: String = ""
            if showLogLevel {
                extendedDetails += "[" + logDetails.level.description + "] "
            }
            
            var formattedDate: String = logDetails.date.description
            if let dateFormatter = owner!.dateFormatter {
                formattedDate = dateFormatter.string(from: logDetails.date)
            }
            
            let fullLogMessage: String =  "\(formattedDate) \(extendedDetails): \(logDetails.message)\n"
            
            DispatchQueue.main.async { [weak self] in
                self?.textView.text += fullLogMessage
            }
        }
        
        // MARK: - Misc methods
        public func isEnabledFor(level: XCGLogger.Level) -> Bool {
            return level >= self.outputLevel
        }
        
        // MARK: - DebugPrintable
        public var debugDescription: String {
            return "XCGTextViewLogDestination: \(identifier) - LogLevel: \(outputLevel.description) showThreadName: \(showThreadName) showLogLevel: \(showLogLevel) showFileName: \(showFileName) showLineNumber: \(showLineNumber)"
        }
    }
}
