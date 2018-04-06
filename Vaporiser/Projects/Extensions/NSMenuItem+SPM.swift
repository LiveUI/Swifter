//
//  NSMenuItem+SPM.swift
//  Vaporiser
//
//  Created by Ondrej Rafaj on 05/04/2018.
//  Copyright © 2018 Rafaj Design. All rights reserved.
//

import Foundation
import AppKit


extension NSMenuItem {
    
    var projectItem: SPM {
        return representedObject as! SPM
    }
    
    var script: Script {
        return representedObject as! Script
    }
    
}
