//
//  Apple_Music_Cracked_EditionApp.swift
//  Apple Music Cracked Edition
//
//  Created by apmckelvey on 1/6/26.
//

import SwiftUI

@main
struct Apple_Music_Cracked_EditionApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
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
