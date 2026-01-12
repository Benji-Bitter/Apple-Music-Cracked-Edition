//
//  ContentView.swift
//  Apple Music Cracked Edition
//
//  Created by apmckelvey on 1/5/26.
//

import SwiftUI
import WebKit
import AppKit  // For NSWindow and NSApplication access

// Delegate to intercept the close button and hide the app instead
class HideOnCloseDelegate: NSObject, NSWindowDelegate {
    static let shared = HideOnCloseDelegate()
    
    private override init() {
        super.init()
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        // Hide the entire app instead of closing/quitting
        NSApplication.shared.hide(nil)
        return false  // Prevent actual window close and app quit
    }
}

struct ContentView: View {
    @StateObject private var viewModel = MusicViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                WebViewRepresentable(webView: viewModel.webView)
                    .ignoresSafeArea(edges: .bottom)

                if viewModel.isLoading {
                    ProgressView()
                        .tint(.gray)
                }
            }
        }
        .onAppear {
            viewModel.loadMusic()
            
            // Assign the delegate after the window is created
            DispatchQueue.main.async {
                if let window = NSApplication.shared.windows.first {
                    window.delegate = HideOnCloseDelegate.shared
                }
            }
        }
    }
}

struct WebViewRepresentable: NSViewRepresentable {
    let webView: WKWebView
    func makeNSView(context: Context) -> WKWebView { webView }
    func updateNSView(_ nsView: WKWebView, context: Context) {}
}
