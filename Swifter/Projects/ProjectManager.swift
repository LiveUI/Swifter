//
//  ProjectManager.swift
//  Swifter
//
//  Created by Ondrej Rafaj on 05/04/2018.
//  Copyright © 2018 Rafaj Design. All rights reserved.
//

import Foundation
import AppKit
import Reloaded
import SwiftShell


extension SPM: Entity { }


class ProjectManager {
    
    let carthageManager = CarthageManager()
    
    static func all() -> [SPM] {
        return (try? SPM.query.sort(by: "name").all()) ?? []
    }
    
    func addMenu(to menu: inout NSMenu) {
        var item = NSMenuItem(title: "Projects", action: nil, keyEquivalent: "")
        menu.addItem(item)
        
        for project in ProjectManager.all() {
            let spmItem = NSMenuItem(title: project.name!, action: nil, keyEquivalent: "")
            
            var subMenu = NSMenu(title: project.name!)
            
            var exists = buildExists(for: project.path!)
            item = NSMenuItem(title: "Delete .build folder", action: exists ? #selector(deleteBuildFolder) : nil, keyEquivalent: "")
            item.target = self
            item.representedObject = project
            subMenu.addItem(item)
            
            if packageExists(for: URL(fileURLWithPath: project.path!)) {
                exists = packageResolvedExists(for: project.path!)
                item = NSMenuItem(title: "Delete Package.resolved", action: exists ? #selector(deletePackageResolved) : nil, keyEquivalent: "")
                item.target = self
                item.representedObject = project
                subMenu.addItem(item)
                
                // If Vapor exists
                if Shell.context.run("which", "vapor").stdout.count > 5 {
                    subMenu.addItem(NSMenuItem.separator())
                    
                    item = NSMenuItem(title: "Vapor clean", action: #selector(vaporClean), keyEquivalent: "")
                    item.target = self
                    item.representedObject = project
                    subMenu.addItem(item)
                    item = NSMenuItem(title: "Vapor Xcode", action: #selector(vaporGenerateXcode), keyEquivalent: "")
                    item.target = self
                    item.representedObject = project
                    subMenu.addItem(item)
                    item = NSMenuItem(title: "Upgrade all packages", action: #selector(vaporUpgradeAll), keyEquivalent: "")
                    item.target = self
                    item.representedObject = project
                    subMenu.addItem(item)
                }
                
                subMenu.addItem(NSMenuItem.separator())
                
                item = NSMenuItem(title: "swift run", action: #selector(run), keyEquivalent: "")
                item.target = self
                item.representedObject = project
                subMenu.addItem(item)
                item = NSMenuItem(title: "swift build", action: #selector(build), keyEquivalent: "")
                item.target = self
                item.representedObject = project
                subMenu.addItem(item)
                item = NSMenuItem(title: "swift test", action: #selector(test), keyEquivalent: "")
                item.target = self
                item.representedObject = project
                subMenu.addItem(item)
                item = NSMenuItem(title: "Generate Xcode file", action: #selector(generateXcode), keyEquivalent: "")
                item.target = self
                item.representedObject = project
                subMenu.addItem(item)
            } else {
                item = NSMenuItem(title: "Create Package.swift", action: #selector(initPackage), keyEquivalent: "")
                item.target = self
                item.representedObject = project
                subMenu.addItem(item)
            }
            
            carthageManager.addMenu(to: &subMenu, project: project)
            
            if podfileExists(for: project.path!) {
                subMenu.addItem(NSMenuItem.separator())
                
                var item = NSMenuItem(title: "CocoaPods", action: nil, keyEquivalent: "")
                subMenu.addItem(item)
                
                item = NSMenuItem(title: "pod install", action: #selector(podInstall), keyEquivalent: "")
                item.target = self
                item.representedObject = project
                subMenu.addItem(item)
                item = NSMenuItem(title: "pod update", action: #selector(podUpdate), keyEquivalent: "")
                item.target = self
                item.representedObject = project
                subMenu.addItem(item)
                item = NSMenuItem(title: "Remove Podfile.lock", action: #selector(removePodLock), keyEquivalent: "")
                item.target = self
                item.representedObject = project
                subMenu.addItem(item)
            }
            
            let enableScripts = (true == false)
            let rootScripts = ScriptsManager.scripts(for: project.path!)
            let scripts = ScriptsManager.scripts(for: project.path("scripts"))
            if (!rootScripts.isEmpty || !scripts.isEmpty) && enableScripts {
                subMenu.addItem(NSMenuItem.separator())
                
                if !scripts.isEmpty {
                    item = NSMenuItem(title: "Scripts", action: nil, keyEquivalent: "")
                    let scriptsMenu = NSMenu(title: "Scripts")
                    item.submenu = scriptsMenu
                    subMenu.addItem(item)
                    
                    for script in scripts {
                        item = NSMenuItem(title: script, action: #selector(runScript), keyEquivalent: "")
                        item.target = self
                        item.representedObject = Script(project: project, path: "scripts/\(script)")
                        scriptsMenu.addItem(item)
                    }
                }
                else {
                    item = NSMenuItem(title: "Scripts", action: nil, keyEquivalent: "")
                    subMenu.addItem(item)
                }
                
                for script in rootScripts {
                    item = NSMenuItem(title: script, action: #selector(runScript), keyEquivalent: "")
                    item.target = self
                    item.representedObject = Script(project: project, path: script)
                    subMenu.addItem(item)
                }
            }
            
            subMenu.addItem(NSMenuItem.separator())
            
            item = NSMenuItem(title: "Remove project", action: #selector(remove), keyEquivalent: "")
            item.target = self
            item.representedObject = project
            subMenu.addItem(item)
            
            spmItem.submenu = subMenu
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
            let name = dialog.url!.lastPathComponent
            let spm = try! SPM.new()
            spm.name = name
            spm.path = dialog.url!.path
            try! spm.save()
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
    
    func podfileExists(for path: String) -> Bool {
        let url = URL(fileURLWithPath: path)
        return FileManager.default.fileExists(atPath: url.appendingPathComponent("Podfile").path)
    }
    
    func podfileLockExists(for path: String) -> Bool {
        let url = URL(fileURLWithPath: path)
        return FileManager.default.fileExists(atPath: url.appendingPathComponent("Podfile.lock").path)
    }
    
    func buildExists(for path: String) -> Bool {
        let url = URL(fileURLWithPath: path)
        return FileManager.default.fileExists(atPath: url.appendingPathComponent(".build").path)
    }
    
    // MARK: Actions
    
    @objc func deleteBuildFolder(_ sender: NSMenuItem) {
        try! runAndPrint("rm", "-rf", sender.projectItem.path(".build"))
    }
    
    @objc func deletePackageResolved(_ sender: NSMenuItem) {
        try! runAndPrint("rm", sender.projectItem.path("Package.resolved"))
    }
    
    // MARK: Swift
    
    @objc func run(_ sender: NSMenuItem) {
        try? Shell.context(for: sender.projectItem.path!).runAndPrint("swift", "run")
    }
    
    @objc func build(_ sender: NSMenuItem) {
        try? Shell.context(for: sender.projectItem.path!).runAndPrint("swift", "build")
    }
    
    @objc func test(_ sender: NSMenuItem) {
        try? Shell.context(for: sender.projectItem.path!).runAndPrint("swift", "test")
    }
    
    @objc func generateXcode(_ sender: NSMenuItem) {
        try? Shell.context(for: sender.projectItem.path!).runAndPrint("swift", "package", "generate-xcodeproj")
    }
    
    @objc func initPackage(_ sender: NSMenuItem) {
        try? Shell.context(for: sender.projectItem.path!).runAndPrint("swift", "package", "init", "--type", "executable")
    }
    
    @objc func updatePackage(_ sender: NSMenuItem) {
        try? Shell.context(for: sender.projectItem.path!).runAndPrint("swift", "package", "update")
    }
    
    // MARK: Vapor
    
    @objc func vaporClean(_ sender: NSMenuItem) {
        try! Shell.context(for: sender.projectItem.path!).runAndPrint("vapor", "clean", "-y")
    }
    
    @objc func vaporGenerateXcode(_ sender: NSMenuItem) {
        try! Shell.context(for: sender.projectItem.path!).runAndPrint("vapor", "xcode", "--verbose", "-y")
    }
    
    @objc func vaporUpgradeAll(_ sender: NSMenuItem) {
        try? Shell.context(for: sender.projectItem.path!).runAndPrint("vapor", "clean", "-y")
        try? Shell.context(for: sender.projectItem.path!).runAndPrint("rm", "-rf", ".build")
        try? Shell.context(for: sender.projectItem.path!).runAndPrint("rm", "Package.resolved")
        try? Shell.context(for: sender.projectItem.path!).runAndPrint("vapor", "xcode", "--verbose", "-y")
    }
    
    // MARK: Pods
    
    @objc func podInstall(_ sender: NSMenuItem) {
        try! Shell.context(for: sender.projectItem.path!).runAndPrint("pod", "install")
    }
    
    @objc func podUpdate(_ sender: NSMenuItem) {
        try! Shell.context(for: sender.projectItem.path!).runAndPrint("pod", "update")
    }
    
    @objc func removePodLock(_ sender: NSMenuItem) {
        try! Shell.context(for: sender.projectItem.path!).runAndPrint("rm", "Podfile.lock")
    }
    
    // MARK: Scripts
    
    @objc func runScript(_ sender: NSMenuItem) {
        do {
            try Shell.context(for: sender.script.project.path!).runAndPrint(sender.script.path)
        } catch {
            if let err = error as? CommandError {
                Dialog.ok(message: "Error", text: err.description)
            } else {
                print(error)
                Dialog.ok(message: "Error", text: error.localizedDescription)
            }
        }
    }
    
    // MARK: System
    
    @objc func remove(_ sender: NSMenuItem) {
        try! sender.projectItem.delete()
    }
    
}
