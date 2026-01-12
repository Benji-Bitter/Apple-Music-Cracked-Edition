//
//  ContentView.swift
//  Apple Music
//
//  Created by apmckelvey on 1/5/26.
//

import SwiftUI
import WebKit

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
        }
    }
}

struct WebViewRepresentable: NSViewRepresentable {
    let webView: WKWebView
    func makeNSView(context: Context) -> WKWebView { webView }
    func updateNSView(_ nsView: WKWebView, context: Context) {}
}
