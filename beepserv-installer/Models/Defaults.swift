//
//  Defaults.swift
//  beepserv-installer
//
//  Created by Alfie on 31/03/2024.
//

import Foundation

var tixUserDefaults: UserDefaults? = nil
public func TIXDefaults() -> UserDefaults {
    if tixUserDefaults == nil {
        let tixDefaultsPath = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0].path + "/Preferences/com.Alfie.beepserv-installer.plist"
        tixUserDefaults = UserDefaults.init(suiteName: tixDefaultsPath)
        tixUserDefaults!.register(defaults: [
            "verbose": false,
        ])
    }
    return tixUserDefaults!
}
