//
//  SPMManager.swift
//  Vaporiser
//
//  Created by Ondrej Rafaj on 05/04/2018.
//  Copyright © 2018 Rafaj Design. All rights reserved.
//

import Foundation
import AppKit
import Reloaded
import SwiftShell


extension SPM: Entity { }


class SPMManager {
    
    static func all() -> [SPM] {
        return (try? SPM.query.sort(by: "name").all()) ?? []
    }
    
    func addMenu(to menu: inout NSMenu) {
        var item = NSMenuItem(title: "Swift Package Manager", action: nil, keyEquivalent: "")
        menu.addItem(item)
        
        for spm in SPMManager.all() {
            let spmItem = NSMenuItem(title: spm.name!, action: nil, keyEquivalent: "")
            
            let submenu = NSMenu(title: spm.name!)
            
            var exists = buildExists(for: spm.path!)
            item = NSMenuItem(title: "Delete .build folder", action: exists ? #selector(deleteBuildFolder) : nil, keyEquivalent: "")
            item.target = self
            item.representedObject = spm
            submenu.addItem(item)
            
            exists = packageResolvedExists(for: spm.path!)
            item = NSMenuItem(title: "Delete Package.resolved", action: exists ? #selector(deletePackageResolved) : nil, keyEquivalent: "")
            item.target = self
            item.representedObject = spm
            submenu.addItem(item)
            
            submenu.addItem(NSMenuItem.separator())
            
            item = NSMenuItem(title: "Swift build", action: #selector(build), keyEquivalent: "")
            item.target = self
            item.representedObject = spm
            submenu.addItem(item)
            item = NSMenuItem(title: "Swift test", action: #selector(test), keyEquivalent: "")
            item.target = self
            item.representedObject = spm
            submenu.addItem(item)
            item = NSMenuItem(title: "Generate Xcode file", action: #selector(generateXcode), keyEquivalent: "")
            item.target = self
            item.representedObject = spm
            submenu.addItem(item)
            
            submenu.addItem(NSMenuItem.separator())
            
            item = NSMenuItem(title: "Remove project", action: #selector(remove), keyEquivalent: "")
            item.target = self
            item.representedObject = spm
            submenu.addItem(item)
            
            spmItem.submenu = submenu
            menu.addItem(spmItem)
        }
        
        item = NSMenuItem(title: "Add project ...", action: #selector(selectSPM), keyEquivalent: "")
        item.target = self
        menu.addItem(item)
    }
    
    // MARK: Actions
    
    @objc func selectSPM(sender: NSMenuItem) {
        let dialog = NSOpenPanel()
        dialog.title = "Select SPM folder"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.canChooseDirectories = true
        dialog.canChooseFiles = false
        dialog.canCreateDirectories = false
        dialog.allowsMultipleSelection = false
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            if packageExists(for: dialog.url!) {
                let name = dialog.url!.lastPathComponent
                let spm = try! SPM.new()
                spm.name = name
                spm.path = dialog.url!.path
                try! spm.save()
            }
            else {
                Dialog.ok(message: "Error", text: "This is not a Swift Package Manager compatible folder.")
            }
        } else {
            return
        }
    }
    
    func packageExists(for path: URL) -> Bool {
        return FileManager.default.fileExists(atPath: path.appendingPathComponent("Package.swift").path)
    }
    
    func packageResolvedExists(for path: String) -> Bool {
        let url = URL(fileURLWithPath: path)
        return FileManager.default.fileExists(atPath: url.appendingPathComponent("Package.resolved").path)
    }
    
    func buildExists(for path: String) -> Bool {
        let url = URL(fileURLWithPath: path)
        return FileManager.default.fileExists(atPath: url.appendingPathComponent(".build").path)
    }
    
    @objc func deleteBuildFolder(_ sender: NSMenuItem) {
        try! runAndPrint("rm", "-rf", sender.spmItem.path(".build"))
    }
    
    @objc func deletePackageResolved(_ sender: NSMenuItem) {
        try! runAndPrint("rm", sender.spmItem.path("Package.resolved"))
    }
    
    @objc func build(_ sender: NSMenuItem) {
        
    }
    
    @objc func test(_ sender: NSMenuItem) {
        
    }
    
    @objc func generateXcode(_ sender: NSMenuItem) {
        
    }
    
    @objc func remove(_ sender: NSMenuItem) {
        try! sender.spmItem.delete()
    }
    
}
