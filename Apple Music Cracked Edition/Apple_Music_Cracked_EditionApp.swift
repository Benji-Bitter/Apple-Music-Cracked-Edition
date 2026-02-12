//
//  Apple_Music_Cracked_EditionApp.swift
//  Apple Music Cracked Edition
//
//  Created by apmckelvey on 1/6/26.
//

import SwiftUI
import AppKit

@main
struct Apple_Music_Cracked_EditionApp: App {
    @StateObject private var updaterController = UpdaterController()
    @State private var mediaKeyTap = MediaKeyTap()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // Wire media keys to the web view actions via NotificationCenter
                    // Find the root ContentView's view model if accessible, otherwise post notifications.
                    // For simplicity, we'll broadcast notifications and let ContentView/MusicViewModel subscribe.
                    mediaKeyTap.onPlayPause = {
                        NotificationCenter.default.post(name: .mediaKeyPlayPause, object: nil)
                    }
                    mediaKeyTap.onNext = {
                        NotificationCenter.default.post(name: .mediaKeyNext, object: nil)
                    }
                    mediaKeyTap.onPrevious = {
                        NotificationCenter.default.post(name: .mediaKeyPrevious, object: nil)
                    }
                    mediaKeyTap.onFastForward = {
                        NotificationCenter.default.post(name: .mediaKeyFastForward, object: nil)
                    }
                    mediaKeyTap.onRewind = {
                        NotificationCenter.default.post(name: .mediaKeyRewind, object: nil)
                    }
                    mediaKeyTap.start()
                }
        }
        .commands {
            UpdaterCommands(updaterController: updaterController.updaterController)
            DeveloperCommands()
            AppHelpCommands()
        }

        // Small secondary window for cookie diagnostics
        Window("Cookie Diagnostics", id: "cookieDiagnostics") {
            CookieDiagnosticsView()
        }
        .defaultSize(width: 520, height: 420)

        Window("App Help", id: "appHelp") {
            HelpBookView()
        }
        .defaultSize(width: 720, height: 520)
    }
}
extension Notification.Name {
    static let mediaKeyPlayPause = Notification.Name("MediaKeyPlayPause")
    static let mediaKeyNext = Notification.Name("MediaKeyNext")
    static let mediaKeyPrevious = Notification.Name("MediaKeyPrevious")
    static let mediaKeyFastForward = Notification.Name("MediaKeyFastForward")
    static let mediaKeyRewind = Notification.Name("MediaKeyRewind")
}

