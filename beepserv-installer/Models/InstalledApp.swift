//
//  InstalledApp.swift
//  beepserv-installer
//
//  Created by Alfie on 29/03/2024.
//

import SwiftUI

struct InstalledApp: Hashable {
    let displayName: String
    let bundleName: String
    let bundleIdentifier: String
    var bundlePath: String?
    
    var isInstalled: Bool
    
    var icon: UIImage?
    
    init(displayName: String, bundleName: String, bundleIdentifier: String) {
        self.displayName = displayName
        self.bundleName = bundleName
        self.bundleIdentifier = bundleIdentifier
        
        self.bundlePath = find_path_for_app(bundleName)
        self.isInstalled = !(bundlePath == nil)
        if bundlePath != nil {
            let fm = FileManager.default
            if fm.fileExists(atPath: bundlePath! + "/AppIcon60x60@2x.png") { self.icon = UIImage(contentsOfFile: bundlePath! + "/AppIcon60x60@2x.png") }
            if fm.fileExists(atPath: bundlePath! + "/AppIcon@2x.png") { self.icon = UIImage(contentsOfFile: bundlePath! + "/AppIcon@2x.png") }
            if fm.fileExists(atPath: bundlePath! + "/iOSAppIcon60x60@2x.png") { self.icon = UIImage(contentsOfFile: bundlePath! + "/iOSAppIcon60x60@2x.png") }
        }
    }
}

var persistenceHelperCandidates = [
    InstalledApp(displayName: "Tips", bundleName: "Tips", bundleIdentifier: "com.apple.tips")
]

class HelperAlert: ObservableObject {
    static let shared = HelperAlert()
    @Published var showAlert: Bool = false
}
