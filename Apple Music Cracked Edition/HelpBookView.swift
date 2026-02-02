import SwiftUI

struct HelpTopic: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let content: String
}

struct HelpBookView: View {
    @State private var query: String = ""
    @State private var topics: [HelpTopic] = HelpBookView.defaultTopics
    @State private var selectionID: HelpTopic.ID? = HelpBookView.defaultTopics.first?.id

    var body: some View {
        NavigationSplitView {
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search Help", text: $query)
                        .textFieldStyle(.roundedBorder)
                }
                .padding([.top, .horizontal])
                List(filteredTopics, selection: $selectionID) { topic in
                    Text(topic.title)
                        .tag(topic.id)
                }
                .listStyle(.sidebar)
                .onChange(of: query) { _ in
                    if let id = selectionID, !filteredTopics.contains(where: { $0.id == id }) {
                        selectionID = filteredTopics.first?.id
                    }
                }
                .onAppear {
                    if selectionID == nil {
                        selectionID = filteredTopics.first?.id
                    }
                }
            }
            .navigationTitle("Help")
        } detail: {
            ScrollView {
                if let sel = selectedTopic {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(sel.title).font(.title).bold()
                        Divider()
                        Text(sel.content)
                            .textSelection(.enabled)
                    }
                    .padding()
                } else {
                    Text("Select a help topic")
                        .foregroundStyle(.secondary)
                        .padding()
                }
            }
        }
    }

    private var filteredTopics: [HelpTopic] {
        if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return topics }
        return topics.filter { $0.title.localizedCaseInsensitiveContains(query) }
    }
    
    private var selectedTopic: HelpTopic? {
        guard let id = selectionID else { return nil }
        return filteredTopics.first(where: { $0.id == id }) ?? topics.first(where: { $0.id == id })
    }
}

extension HelpBookView {
    static let defaultTopics: [HelpTopic] = [
        HelpTopic(title: "Welcome to Apple Music (Web)", content: """
        Apple Music on the web lets you listen, search, and manage your library from any browser. This app wraps the web experience in a lightweight macOS window.
        
        • Browse and search the Apple Music catalog
        • Sign in with your Apple ID to access your library and playlists
        • Control playback with the on-screen controls
        """),
        HelpTopic(title: "Sign in and trust this browser", content: """
        To sign in, click Sign In in the upper-right corner. If prompted for two-factor authentication, complete the verification and choose Trust this browser to reduce future prompts. If you're repeatedly asked to verify, check cookie settings, disable private browsing, and ensure VPN/relay services are off while signing in.
        """),
        HelpTopic(title: "Play and control music", content: """
        Use the play, pause, and next/previous controls to manage playback. You can also use the spacebar unless an editable text field is focused.
        """),
        HelpTopic(title: "Make and edit playlists", content: """
        Create playlists from the sidebar by selecting New Playlist, then add songs by searching or browsing your library.
        """),
        HelpTopic(title: "Troubleshooting sign-in and cookies", content: """
        If the site asks for two-factor authentication frequently:
        
        • Ensure cookies are allowed and not cleared on quit
        • Avoid Private/Incognito windows
        • Temporarily disable VPN/Private Relay
        • Keep your system date/time correct
        • Use the Developer > Cookies… tool to inspect or clear Apple-related cookies
        """),
        HelpTopic(title: "Media key access & privacy", content: """
        When you first launch the app, macOS may ask to allow it to monitor keyboard input even when you’re not using the app. This request is specifically for handling the hardware media keys (Play/Pause, Next, Previous, Fast Forward, Rewind) so you can control playback while the app is in the background.
        
        What it’s used for:
        • Listening for media key events and mapping them to the web player’s controls inside the app
        
        What it does NOT do:
        • It does not capture or log your typing
        • It does not read passwords or other text input
        • It only listens for media key events
        
        Is this permission required?
        • No. The app works without this permission. If you deny it, you can still control playback using the on‑screen controls in the app window.
        • Granting permission simply enables convenient control using your keyboard’s media keys while the app is in the background.
        
        You can change this later in System Settings > Privacy & Security > Input Monitoring.
        """)
    ]
}

#Preview {
    HelpBookView()
}

