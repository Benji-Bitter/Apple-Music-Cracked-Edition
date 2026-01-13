//
//  ConnectivityGate.swift
//  Apple Music Cracked Edition
//
//  Created by Alexander McKelvey on 1/13/26.
//


import SwiftUI

struct ConnectivityGate<Content: View>: View {
    @StateObject private var monitor = NetworkMonitor.shared
    var onRetry: (() -> Void)?
    @ViewBuilder var content: () -> Content

    var body: some View {
        Group {
            if monitor.isOnline {
                content()
            } else {
                OfflineFallbackView(onRetry: onRetry)
            }
        }
    }
}
