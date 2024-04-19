//
//  beepserv-installerApp.swift
//  beepserv-installer
//
//  Created by Alfie on 22/03/2024.
//

import SwiftUI

@main
struct BeepServInstallerApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                // Force status bar to be white
                .preferredColorScheme(.dark)
        }
    }
}
