//
//  UpdaterCommands.swift
//  Apple Music Cracked Edition
//
//  Created for Sparkle framework integration
//

import SwiftUI
import Sparkle

struct UpdaterCommands: Commands {
    let updaterController: SPUStandardUpdaterController
    
    var body: some Commands {
        CommandGroup(after: .appInfo) {
            CheckForUpdatesView(updater: updaterController.updater)
        }
    }
}

// This view provides the "Check for Updates..." menu item
struct CheckForUpdatesView: View {
    let updater: SPUUpdater
    
    var body: some View {
        Button("Check for Updates…") {
            updater.checkForUpdates()
        }
        .disabled(!updater.canCheckForUpdates)
    }
}
