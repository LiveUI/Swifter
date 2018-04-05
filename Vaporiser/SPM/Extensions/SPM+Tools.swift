//
//  SPM+Tools.swift
//  Vaporiser
//
//  Created by Ondrej Rafaj on 05/04/2018.
//  Copyright © 2018 Rafaj Design. All rights reserved.
//

import Foundation


extension SPM {
    
    func path(_ pathToAppend: String) -> String {
        var url = URL(fileURLWithPath: path!)
        return url.appendingPathComponent(pathToAppend).path
    }
    
}
