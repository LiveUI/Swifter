//
//  CarthageManager.swift
//  Vaporiser
//
//  Created by Ondrej Rafaj on 06/04/2018.
//  Copyright © 2018 Rafaj Design. All rights reserved.
//

import Foundation
import AppKit


class CarthageManager {
    
    struct Command {
        let project: SPM
        let command: String
    }
    
    static func all() -> [SPM] {
        return (try? SPM.query.sort(by: "name").all()) ?? []
    }
    
    func addMenu(to menu: inout NSMenu, project: SPM) {
        if cartfileExists(for: project.path!) {
            menu.addItem(NSMenuItem.separator())
            
            var item = NSMenuItem(title: "Carthage", action: nil, keyEquivalent: "")
            menu.addItem(item)
            
            item = NSMenuItem(title: "carthage update", action: #selector(command), keyEquivalent: "")
            item.target = self
            item.representedObject = Command(project: project, command: "update")
                
            let updateSubmenu = {
                let updateSubmenu = NSMenu()
                
                var updateItem = NSMenuItem(title: "All platforms", action: #selector(self.command), keyEquivalent: "")
                updateItem.target = self
                updateItem.representedObject = Command(project: project, command: "update")
                updateSubmenu.addItem(updateItem)
                
                updateItem = NSMenuItem(title: "--platform ios", action: #selector(self.command), keyEquivalent: "")
                updateItem.target = self
                updateItem.representedObject = Command(project: project, command: "update --platform ios")
                updateSubmenu.addItem(updateItem)
                
                updateItem = NSMenuItem(title: "--platform tvos", action: #selector(self.command), keyEquivalent: "")
                updateItem.target = self
                updateItem.representedObject = Command(project: project, command: "update --platform tvos")
                updateSubmenu.addItem(updateItem)
                
                updateItem = NSMenuItem(title: "--platform osx", action: #selector(self.command), keyEquivalent: "")
                updateItem.target = self
                updateItem.representedObject = Command(project: project, command: "update --platform osx")
                updateSubmenu.addItem(updateItem)
                
                item.submenu = updateSubmenu
            }
            updateSubmenu()
            
            menu.addItem(item)
            
            item = NSMenuItem(title: "Remove Carthage folder", action: #selector(removeCarthage), keyEquivalent: "")
            item.target = self
            item.representedObject = project
            menu.addItem(item)
            item = NSMenuItem(title: "Remove Cartfile.resolved", action: #selector(removeCarthageResolved), keyEquivalent: "")
            item.target = self
            item.representedObject = project
            menu.addItem(item)
        }
    }
    
    // MARK: Actions
    
    @objc func command(_ sender: NSMenuItem) {
        try? Shell.context(for: sender.carthageCommand.project.path!).runAndPrint("carthage", sender.carthageCommand.command)
    }
    
    @objc func removeCarthage(_ sender: NSMenuItem) {
        try? Shell.context(for: sender.projectItem.path!).runAndPrint("rm", "-rf", sender.projectItem.path("Carthage"))
    }
    
    @objc func removeCarthageResolved(_ sender: NSMenuItem) {
        try? Shell.context(for: sender.projectItem.path!).runAndPrint("rm", sender.projectItem.path("Cartfile.resolved"))
    }
    
    // MARK: Tests
    
    func cartfileExists(for path: String) -> Bool {
        let url = URL(fileURLWithPath: path)
        return FileManager.default.fileExists(atPath: url.appendingPathComponent("Cartfile").path)
    }
    
    func cartfileResolvedExists(for path: String) -> Bool {
        let url = URL(fileURLWithPath: path)
        return FileManager.default.fileExists(atPath: url.appendingPathComponent("Cartfile.resolved").path)
    }
    
}
