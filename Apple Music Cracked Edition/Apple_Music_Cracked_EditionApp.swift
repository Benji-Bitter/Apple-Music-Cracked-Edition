//
//  Apple_Music_Cracked_Edition.swift
//  Apple Music Cracked Edition
//
//  Created by Alexander McKelvey on 1/5/26.
//

import SwiftUI

@main
struct Apple_Music_Cracked_EditionApp: App {
    @StateObject private var viewModel = MusicViewModel()
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup(id: "main") {
            ContentView(viewModel: viewModel)
                .onAppear {
                    appDelegate.viewModel = viewModel
                    // Delay ensuring the window is ready to accept the delegate
                    DispatchQueue.main.async {
                        if let window = NSApp.windows.first {
                            window.delegate = appDelegate
                            window.identifier = NSUserInterfaceItemIdentifier("main")
                        }
                    }
                }
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    var viewModel: MusicViewModel?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
    }

    // Keep the app running in the background for music
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }

    // Intercept close button: Hide instead of Close
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        NSApp.hide(nil)
        return false
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        // 1. Fully unhide the application
        NSApp.unhide(nil)
        
        // 2. Find and force the window to the front
        if let window = sender.windows.first {
            window.setIsVisible(true)
            window.makeKeyAndOrderFront(self)
        }
        
        // 3. Re-sync media keys to ensure Control Center wakes up
        viewModel?.setupRemoteCommandCenter()
        
        return false
    }
}
