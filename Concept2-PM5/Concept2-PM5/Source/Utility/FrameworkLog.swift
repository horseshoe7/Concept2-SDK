//
//  FrameworkLog.swift
//  Concept2-PM5
//
//  Created by Stephen O'Connor on 20.11.20.
//  Copyright © 2020 HomeTeam Software. All rights reserved.
//

import XCGLogger

/// NOTE: This is a public variable, so what you do in your application that also uses XCGLogger,
/// you set this Module's log to  your application log.
/// i.e. Concept2_PM5.log = myOtherLog
public var log: XCGLogger = {
    
    let log = XCGLogger(identifier: "Concept2SDK-Logger", includeDefaultDestinations: false)
    
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
    
    // Add basic app info, version info etc, to the start of the logs
    log.logAppDetails()
    
    return log
}()


