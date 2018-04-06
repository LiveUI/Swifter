//
//  URL+Tools.swift
//  Swifter
//
//  Created by Rafaj Design on 22/03/2017.
//  Copyright © 2017 Rafaj Design. All rights reserved.
//

import Foundation


extension URL {
    
    var isDirectory: Bool {
        guard isFileURL else { return false }
        var directory: ObjCBool = false
        return FileManager.default.fileExists(atPath: path, isDirectory: &directory) ? directory.boolValue : false
    }
    
    var subDirectories: [URL] {
        guard isDirectory else { return [] }
        return (try? FileManager.default.contentsOfDirectory(at: self, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles]).filter{ $0.isDirectory }) ?? []
    }
    
}
