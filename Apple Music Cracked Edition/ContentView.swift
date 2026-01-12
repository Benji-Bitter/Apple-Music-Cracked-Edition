//
//  ContentView.swift
//  Apple Music Cracked Edition
//
//  Created by Alexander McKelvey on 1/5/26.
//

import SwiftUI
import WebKit

struct ContentView: View {
    @ObservedObject var viewModel: MusicViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            WebViewRepresentable(webView: viewModel.webView)
        }
        .onAppear {
            // FIX: Access the underlying object directly
            if viewModel.webView.url == nil {
                viewModel.loadMusic()
            }
        }
        .frame(minWidth: 800, minHeight: 600)
    }
}

struct WebViewRepresentable: NSViewRepresentable {
    let webView: WKWebView
    func makeNSView(context: Context) -> WKWebView { webView }
    func updateNSView(_ nsView: WKWebView, context: Context) {}
}
