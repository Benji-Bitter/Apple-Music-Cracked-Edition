//
//  MusicViewModel.swift
//  Apple Music Cracked Edition
//
//  Created by apmckelvey on 1/6/26.
//

import Foundation
import WebKit
import Combine

class MusicViewModel: NSObject, ObservableObject, WKNavigationDelegate, WKUIDelegate {
    let webView: WKWebView
    @Published var isLoading = false
    
    override init() {
        let configuration = WKWebViewConfiguration()
        
        // Standard preferences for a stable web experience
        configuration.preferences.isElementFullscreenEnabled = true
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        configuration.websiteDataStore = WKWebsiteDataStore.default()
        
        // Prevent spacebar from toggling playback inside the Apple Music web app
        let blockSpacebarScriptSource = """
        (function(){
            function isEditable(el){
                if (!el) return false;
                const tag = el.tagName ? el.tagName.toLowerCase() : "";
                const editable = el.isContentEditable;
                const inputTypesAllowingSpace = new Set([
                    "text","search","url","tel","password","email","number","date","datetime-local","month","time","week"]);
                if (tag === "textarea") return true;
                if (tag === "input") {
                    const type = (el.getAttribute("type") || "text").toLowerCase();
                    return inputTypesAllowingSpace.has(type);
                }
                return !!editable;
            }
            function handler(e){
                // Only consider plain spacebar (no modifiers)
                if (!(e.code === 'Space' || e.key === ' ' || e.keyCode === 32)) return;
                if (e.ctrlKey || e.metaKey || e.altKey) return;
                const active = document.activeElement;
                // Allow spacebar inside editable fields
                if (isEditable(active)) return;
                // Otherwise, block to prevent play/pause toggling
                e.stopPropagation();
                e.preventDefault();
                return false;
            }
            window.addEventListener('keydown', handler, { capture: true });
        })();
        """
        let blockSpacebarScript = WKUserScript(source: blockSpacebarScriptSource, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        configuration.userContentController.addUserScript(blockSpacebarScript)
        
        self.webView = WKWebView(frame: .zero, configuration: configuration)
        
        super.init()
        
        // Modern User Agent to ensure Apple Music loads the high-quality interface
        webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15"
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = true
    }
    
    func loadMusic() {
        guard let url = URL(string: "https://music.apple.com") else { return }
        webView.load(URLRequest(url: url))
    }
    
    func togglePlayPause() {
        let script = """
        (function(){
            const play = document.querySelector('button[aria-label*="Play" i]');
            const pause = document.querySelector('button[aria-label*="Pause" i]');
            if (pause) { pause.click(); return; }
            if (play) { play.click(); return; }
        })();
        """
        webView.evaluateJavaScript(script) { _, _ in }
    }
    
    // MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        DispatchQueue.main.async { self.isLoading = true }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async { self.isLoading = false }
    }
}

