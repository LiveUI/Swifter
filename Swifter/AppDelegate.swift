//
//  AppDelegate.swift
//  Swifter
//
//  Created by Rafaj Design on 22/03/2017.
//  Copyright © 2017 Rafaj Design. All rights reserved.
//

import Cocoa
import AppKit
import SwiftShell


@NSApplicationMain


class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    let popover = NSPopover()
    var statusItem: NSStatusItem?
    
    var menuItems: [NSMenuItem] = []
    var subDirectories: [URL] = []
    
    var derivedFolderUrl: URL {
        let home: String = NSHomeDirectory()
        var url: URL = URL.init(fileURLWithPath: home)
        url.appendPathComponent("Library/Developer/Xcode/DerivedData")
        return url
    }
    
    var spmManager = ProjectManager()
    
    // MARK: Application delegate methods
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        self.statusItem?.image = NSImage(named: NSImage.Name(rawValue: "icon"))
        self.statusItem?.image?.isTemplate = true
        self.statusItem?.action = #selector(AppDelegate.didTapStatusBarIcon)
        
        popover.contentViewController = LogViewController.default
    }
    
    // MARK: Console popover
    
    @objc func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    func showPopover(sender: Any?) {
        if let button = statusItem!.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
    
    func closePopover(sender: Any?) {
        popover.performClose(sender)
    }
    
    // MARK: Actions
    
    @objc func didTapStatusBarIcon() {
        var menu: NSMenu = NSMenu()
        
        spmManager.addMenu(to: &menu)
        
        menu.addItem(NSMenuItem.separator())
        
        var item: NSMenuItem = NSMenuItem(title: "Derived data", action: nil, keyEquivalent: "")
        menu.addItem(item)
        
        item = NSMenuItem(title: "Clear all", action: #selector(AppDelegate.deleteAll), keyEquivalent: "")
        menu.addItem(item)
        
        item = NSMenuItem(title: "Open folder ...", action: #selector(AppDelegate.openFolder), keyEquivalent: "")
        menu.addItem(item)
        
        menu.addItem(NSMenuItem.separator())
        
        self.subDirectories = self.derivedFolderUrl.subDirectories
        self.menuItems = []
        for url: URL in self.subDirectories {
            var components: [String] = url.lastPathComponent.components(separatedBy: "-")
            if components.count > 1 {
                components.removeLast()
            }
            let title = components.joined(separator: "-")
            item = NSMenuItem(title: title, action: #selector(deleteOne), keyEquivalent: "")
            menu.addItem(item)
            self.menuItems.append(item)
        }

        menu.addItem(NSMenuItem.separator())
        
        item = NSMenuItem(title: "Quit", action: #selector(exit), keyEquivalent: "")
        menu.addItem(item)

        self.statusItem?.popUpMenu(menu)
    }
    
    // MARK: Terminal stuff
    
    private func runTerminal(command: String) {
        run(bash: "open -b com.apple.terminal ls /")
    }
    
    // MARK: System
    
    static var main: AppDelegate {
        return NSApplication.shared.delegate as! AppDelegate
    }
    
    @objc func exit(sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    // MARK: Working with derived data
    
    @objc func openFolder(sender: NSMenuItem) {
        NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: self.derivedFolderUrl.path)
    }
    
    @objc func deleteAll(sender: NSMenuItem) {
        deleteDerivedData()
    }
    
    @objc func deleteOne(sender: NSMenuItem) {
        let index: Int = self.menuItems.index(of: sender)!
        let url: URL = self.subDirectories[index]
        deleteDerivedData(url.lastPathComponent)
    }
    
    func deleteDerivedData(_ subfolder: String? = nil) {
        var url: URL = self.derivedFolderUrl
        if subfolder != nil {
            url.appendPathComponent(subfolder!)
        }
        Shell.run("rm", "-rf", url.path)
    }
    
}

