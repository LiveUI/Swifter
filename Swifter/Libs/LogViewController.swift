//
//  LogViewController.swift
//  Swifter
//
//  Created by Ondrej Rafaj on 06/04/2018.
//  Copyright © 2018 Rafaj Design. All rights reserved.
//

import Foundation
import AppKit
import SnapKit


class LogViewController: NSViewController {
    
    static let `default` = LogViewController()
    
    var didRequestStop: (() -> Void)?
    
    var textField: NSTextField!
    var stop: NSButton!
    
    // MARK: View lifecycle
    
    override func loadView() {
        self.view = NSView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Test field
        textField = NSTextField()
        textField.isBezeled = false
        textField.drawsBackground = false
        textField.isEditable = false
        textField.isSelectable = false
        textField.stringValue = "TEST"
        view.addSubview(textField)
        
        textField.snp.makeConstraints { (make) in
            make.top.left.equalTo(10)
            make.right.bottom.equalTo(-10)
            make.width.lessThanOrEqualTo(700)
            make.height.lessThanOrEqualTo(550)
            
            make.width.greaterThanOrEqualTo(400)
            make.height.greaterThanOrEqualTo(300)
        }
        
        // Adding stop button
        stop = NSButton(title: "Stop", target: self, action: #selector(stop(_:)))
        view.addSubview(stop)
        stop.sizeToFit()
        
        stop.snp.makeConstraints { (make) in
            make.right.equalTo(textField.snp.right)
            make.bottom.equalTo(textField.snp.bottom)
        }
    }
    
    // MARK: Actions
    
    @objc func stop(_ sender: NSButton) {
        sender.isHidden = true
        didRequestStop?()
    }
    
    // MARK: Events
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        
        AppDelegate.main.closePopover(sender: self)
    }
    
}
