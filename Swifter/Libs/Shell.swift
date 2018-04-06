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
    
    static var running: Bool = false
    
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
        AppDelegate.main.togglePopover(self)
        
        LogViewController.default.textField.stringValue = "[Swifter]: \(command) \(args.joined(separator: " "))\n"
        
        Shell.running = true
        let output: SwiftShell.AsyncCommand
        if let project = project {
            output = Shell.context(for: project.path!).runAsync(command, args)
        } else {
            output = SwiftShell.runAsync(command, args)
        }
        output.onCompletion({ (command) in
            Shell.running = false
            DispatchQueue.main.async {
                LogViewController.default.textField.stringValue += "\n[Swifter] Exit code: \(command.exitcode())\n"
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                AppDelegate.main.togglePopover(self)
                LogViewController.default.textField.stringValue = ""
            }
        })
        output.stdout.onOutput { stream in
            if Shell.running {
                let string = stream.readSome()  ?? ""
                DispatchQueue.main.async {
                    LogViewController.default.textField.stringValue += string
                }
            }
        }
        
        do {
            try output.finish()
        } catch {
            if let err = error as? CommandError {
                Dialog.ok(message: "Error", text: err.description)
            } else {
                print(error)
                Dialog.ok(message: "Error", text: error.localizedDescription)
            }
        }
    }
    
}

