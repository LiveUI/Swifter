//
//  AppDelegate.swift
//  DDDestroyer
//
//  Created by Rafaj Design on 22/03/2017.
//  Copyright © 2017 Rafaj Design. All rights reserved.
//

import Cocoa
import AppKit


@NSApplicationMain


class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    var statusItem: NSStatusItem?
    
    var menuItems: [NSMenuItem] = []
    var subDirectories: [URL] = []
    
    var derivedFolderUrl: URL {
        let home: String = NSHomeDirectory()
        var url: URL = URL.init(fileURLWithPath: home)
        url.appendPathComponent("Library/Developer/Xcode/DerivedData")
        return url
    }
    
    // MARK: Application delegate methods
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        self.statusItem?.image = NSImage(named: NSImage.Name(rawValue: "icon"))
        self.statusItem?.image?.isTemplate = true
        self.statusItem?.action = #selector(AppDelegate.didTapStatusBarIcon)
    }
    
    // MARK: Actions
    
    @objc func didTapStatusBarIcon() {
        let menu: NSMenu = NSMenu.init()
        
        var item: NSMenuItem = NSMenuItem(title: "Derived data", action: nil, keyEquivalent: "")
        menu.addItem(item)
        
        item = NSMenuItem(title: "Clear all", action: #selector(AppDelegate.deleteAll), keyEquivalent: "")
        menu.addItem(item)
        
        item = NSMenuItem(title: "Open folder ...", action: #selector(AppDelegate.openFolder), keyEquivalent: "")
        menu.addItem(item)
        
        menu.addItem(NSMenuItem.separator())
        
        item = NSMenuItem(title: "SPM", action: nil, keyEquivalent: "")
        menu.addItem(item)
        
        item = NSMenuItem(title: "Add project ...", action: #selector(AppDelegate.selectSPM), keyEquivalent: "")
        menu.addItem(item)
        
        menu.addItem(NSMenuItem.separator())
        
        item = NSMenuItem(title: "Modules", action: nil, keyEquivalent: "")
        menu.addItem(item)
        
        self.subDirectories = self.derivedFolderUrl.subDirectories
        self.menuItems = []
        for url: URL in self.subDirectories {
            var components: [String] = url.lastPathComponent.components(separatedBy: "-")
            if components.count > 1 {
                components.removeLast()
            }
            let title = components.joined(separator: "-")
            item = NSMenuItem(title: title, action: #selector(AppDelegate.deleteOne), keyEquivalent: "")
            menu.addItem(item)
            self.menuItems.append(item)
        }

        menu.addItem(NSMenuItem.separator())
        
        item = NSMenuItem(title: "Quit", action: #selector(AppDelegate.exit), keyEquivalent: "")
        menu.addItem(item)

        self.statusItem?.popUpMenu(menu)
    }
    
    // SPM
    
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
            guard let result = dialog.url else {
                return
            }
            print(result)
        } else {
            return
        }
    }
    
    // MARK: System
    
    @objc func exit(sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    // MARK: Working with derived data
    
    @objc func openFolder(sender: NSMenuItem) {
        NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: self.derivedFolderUrl.path)
    }
    
    @objc func deleteAll(sender: NSMenuItem) {
        self.deleteDerivedData()
    }
    
    @objc func deleteOne(sender: NSMenuItem) {
        let index: Int = self.menuItems.index(of: sender)!
        let url: URL = self.subDirectories[index]
        self.deleteDerivedData(url.lastPathComponent)
    }
    
    func deleteDerivedData(_ subfolder: String? = nil) {
        do {
            var url: URL = self.derivedFolderUrl
            if subfolder != nil {
                url.appendPathComponent(subfolder!)
            }
            try FileManager.default.removeItem(at: url)
        }
        catch {
            print(error)
        }
    }
    
}

