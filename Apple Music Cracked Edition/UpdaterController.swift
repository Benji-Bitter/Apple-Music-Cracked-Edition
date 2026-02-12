//
//  UpdaterController.swift
//  Apple Music Cracked Edition
//
//  Created for Sparkle framework integration
//

import SwiftUI
import Sparkle

// This class is used to make the updater visible to SwiftUI and provide a reference to the SPUStandardUpdaterController.
final class UpdaterController: ObservableObject {
    let updaterController: SPUStandardUpdaterController
    
    init() {
        // Create an updater controller with the standard user driver and the delegate
        updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
    }
}
