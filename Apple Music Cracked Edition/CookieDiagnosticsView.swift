import SwiftUI
import WebKit

struct CookieDiagnosticsView: View {
    @State private var cookies: [HTTPCookie] = []
    @State private var isLoading = false
    @State private var statusMessage: String = ""

    private let appleDomains = ["apple.com", "icloud.com", "itunes.apple.com", "music.apple.com", "idmsa.apple.com"]

    private func isAppleDomain(_ cookieDomain: String) -> Bool {
        let cd = cookieDomain.trimmingCharacters(in: CharacterSet(charactersIn: "."))
        return appleDomains.contains { base in cd == base || cd.hasSuffix("." + base) }
    }

    var body: some View {
        VStack(spacing: 0) {
            if isLoading {
                ProgressView("Loading cookies…").padding()
            }
            List {
                Section(header: Text("Apple-related cookies (") + Text("\(cookies.count)").bold() + Text(")")) {
                    ForEach(Array(cookies.enumerated()), id: \.offset) { _, cookie in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(cookie.name).font(.headline)
                            Text(cookie.domain).font(.subheadline).foregroundStyle(.secondary)
                            Text("Value: \(cookie.value.prefix(80))\(cookie.value.count > 80 ? "…" : "")").font(.caption)
                            HStack(spacing: 12) {
                                if let expires = cookie.expiresDate {
                                    Text("Expires: \(expires.formatted(date: .abbreviated, time: .shortened))")
                                } else {
                                    Text("Session cookie")
                                }
                                Text(cookie.isSecure ? "Secure" : "Not Secure")
                                Text(cookie.isHTTPOnly ? "HTTPOnly" : "JS-readable")
                            }
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }
                        .textSelection(.enabled)
                    }
                }
            }
            .listStyle(.inset)

            HStack {
                Text(statusMessage)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Spacer()
                Button("Refresh") { loadCookies() }
                Button("Clear Apple Cookies", role: .destructive) { clearAppleCookies() }
            }
            .padding()
        }
        .onAppear { loadCookies() }
        .navigationTitle("Cookie Diagnostics")
        .frame(minWidth: 480, minHeight: 360)
    }

    private func loadCookies() {
        isLoading = true
        statusMessage = ""
        let store = WKWebsiteDataStore.default().httpCookieStore
        store.getAllCookies { all in
            let fetched = all.filter { cookie in
                isAppleDomain(cookie.domain)
            }.sorted { $0.domain < $1.domain || ($0.domain == $1.domain && $0.name < $1.name) }
            DispatchQueue.main.async {
                self.cookies = fetched
                self.isLoading = false
                self.statusMessage = "Loaded \(fetched.count) Apple-related cookies."
            }
        }
    }

    private func clearAppleCookies() {
        isLoading = true
        statusMessage = ""
        let store = WKWebsiteDataStore.default().httpCookieStore
        store.getAllCookies { all in
            let targets = all.filter { cookie in
                isAppleDomain(cookie.domain)
            }
            let group = DispatchGroup()
            targets.forEach { cookie in
                group.enter()
                store.delete(cookie) {
                    group.leave()
                }
            }
            group.notify(queue: .main) {
                self.statusMessage = "Deleted \(targets.count) Apple-related cookies."
                self.loadCookies()
            }
        }
    }
}
