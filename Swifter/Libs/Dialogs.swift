//
//  Dialogs.swift
//  Swifter
//
//  Created by Ondrej Rafaj on 05/04/2018.
//  Copyright © 2018 Rafaj Design. All rights reserved.
//

import Foundation
import AppKit


class Dialog {
    
    @discardableResult static func ok(message: String, text: String) -> Bool {
        let alert = NSAlert()
        alert.messageText = message
        alert.informativeText = text
        alert.alertStyle = NSAlert.Style.warning
        alert.addButton(withTitle: "OK")
        return alert.runModal() == NSApplication.ModalResponse.alertFirstButtonReturn
    }

}
