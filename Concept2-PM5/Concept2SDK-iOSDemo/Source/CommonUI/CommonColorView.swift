//
//  CommonColorView.swift
//  Concept2SDK-iOSDemo
//
//  Created by Stephen O'Connor on 23.11.20.
//  Copyright © 2020 HomeTeam Software. All rights reserved.
//

import UIKit

/// A view that will set the background color of all its subviews to its `primaryColor` setting.
/// this view is useful if you have a whole bunch of subviews that are drawing lines and you want to play
/// with their color all in one place
class CommonColorControlView: UIView {

    @IBInspectable var primaryColor: UIColor = .black {
        didSet {
            updateSubviews()
        }
    }

    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        updateSubviews()
    }
    
    func updateSubviews() {
        self.subviews.forEach { (subview) in
            if subview is CommonColorView {
                subview.backgroundColor = self.primaryColor
            }
        }
    }
}

class CommonColorView: UIView {
    
    
}
