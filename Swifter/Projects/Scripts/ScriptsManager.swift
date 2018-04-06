//
//  ScriptsManager.swift
//  Swifter
//
//  Created by Ondrej Rafaj on 06/04/2018.
//  Copyright © 2018 Rafaj Design. All rights reserved.
//

import Foundation


struct Script {
    let project: Project
    let path: String
}


class ScriptsManager {
    
    static func hasScriptsFolder(path: String) -> Bool {
        let url = URL(fileURLWithPath: path)
        var isDir: ObjCBool = false
        FileManager.default.fileExists(atPath: url.appendingPathComponent("scripts").path, isDirectory: &isDir)
        return isDir.boolValue
    }
    
    static func scripts(for path: String) -> [String] {
        let files = (try? FileManager.default.contentsOfDirectory(atPath: path).filter { (file) -> Bool in
            file.hasSuffix(".sh")
        }) ?? []
        return files
    }
    
    
    
}
