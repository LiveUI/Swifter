//
//  Shell.swift
//  Swifter
//
//  Created by Ondrej Rafaj on 06/04/2018.
//  Copyright © 2018 Rafaj Design. All rights reserved.
//

import Foundation
import SwiftShell


class Shell {
    
    static var context: CustomContext {
        var context = CustomContext(main)
        context.env["PATH"] = "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
        context.env["LANG"] = "en_US.UTF-8"
        context.currentdirectory = main.tempdirectory
        return context
    }
    
    static func context(for path: String) -> CustomContext {
        var c = context
        c.currentdirectory = path
        return c
    }
    
    static func run(project: SPM? = nil, _ command: String, _ args: String...) {
//        do {
//            if let project = project {
//                try Shell.context(for: project.path!).runAndPrint(command, args)
//            } else {
//                try runAndPrint(command, args)
//            }
//        } catch {
//            if let err = error as? CommandError {
//                Dialog.ok(message: "Error", text: err.description)
//            } else {
//                print(error)
//                Dialog.ok(message: "Error", text: error.localizedDescription)
//            }
//        }
        
        let output: SwiftShell.RunOutput
        if let project = project {
            output = Shell.context(for: project.path!).run(command, args)
        } else {
            output = SwiftShell.run(command, args)
        }
        
        AppDelegate.main.togglePopover(self)
        
        LogViewController.default.textField.stringValue = output.stdout
    }
    
}

