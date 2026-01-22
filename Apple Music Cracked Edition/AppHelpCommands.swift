import SwiftUI
import AppKit

struct AppHelpCommands: Commands {
    @Environment(\.openWindow) private var openWindow

    var body: some Commands {
        CommandGroup(after: .help) {
            Divider()
            Button("Apple Music Web Help (Online)") {
                if let url = URL(string: "https://support.apple.com/guide/music-web/welcome/web") {
                    NSWorkspace.shared.open(url)
                }
            }
            Button("App Help (In-App)") {
                openWindow(id: "appHelp")
            }
            Button("About This App") {
                NSApplication.shared.orderFrontStandardAboutPanel(nil)
            }
        }
    }
}
