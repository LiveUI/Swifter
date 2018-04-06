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
    
}

