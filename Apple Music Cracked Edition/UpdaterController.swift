//
//  UpdaterController.swift
//  Apple Music Cracked Edition
//
//  Created for Sparkle framework integration
//

import Foundation
import Sparkle

// This class holds a reference to the SPUStandardUpdaterController for the app lifecycle.
final class UpdaterController {
    let updaterController: SPUStandardUpdaterController
    
    init() {
        // Create an updater controller with the standard user driver and the delegate
        updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
    }
}
