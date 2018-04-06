//
//  NSMenuItem+Project.swift
//  Swifter
//
//  Created by Ondrej Rafaj on 05/04/2018.
//  Copyright © 2018 Rafaj Design. All rights reserved.
//

import Foundation
import AppKit


extension NSMenuItem {
    
    var projectItem: Project {
        return representedObject as! Project
    }
    
    var carthageCommand: CarthageManager.Command {
        return representedObject as! CarthageManager.Command
    }
    
    var script: Script {
        return representedObject as! Script
    }
    
}
