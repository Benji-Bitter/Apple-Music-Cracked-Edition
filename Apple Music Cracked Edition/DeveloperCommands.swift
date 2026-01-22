import SwiftUI
import AppKit

struct DeveloperCommands: Commands {
    @Environment(\.openWindow) private var openWindow
    @AppStorage("musicChannel") private var channelRaw: String = MusicChannel.production.rawValue

    private var channel: Binding<MusicChannel> {
        Binding<MusicChannel>(
            get: { MusicChannel(rawValue: channelRaw) ?? .production },
            set: { channelRaw = $0.rawValue }
        )
    }

    var body: some Commands {
        CommandMenu("Developer") {
            Menu("Channel") {
                ForEach(MusicChannel.allCases) { ch in
                    Button(action: { channel.wrappedValue = ch }) {
                        Label(ch.displayName, systemImage: (channel.wrappedValue == ch ? "checkmark" : ""))
                    }
                }
            }
            Divider()
            Button("Cookies…") { openWindow(id: "cookieDiagnostics") }
                .keyboardShortcut("c", modifiers: [.command, .option])
        }
    }
}
