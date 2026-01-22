import Foundation

enum MusicChannel: String, CaseIterable, Identifiable {
    case production
    case beta

    var id: String { rawValue }

    var baseURL: URL {
        switch self {
        case .production: return URL(string: "https://music.apple.com")!
        case .beta: return URL(string: "https://beta.music.apple.com")!
        }
    }

    var displayName: String {
        switch self {
        case .production: return "Production"
        case .beta: return "Beta"
        }
    }
}
