//
//  MusicViewModel.swift
//  Apple Music Cracked Edition
//
//  Created by Alesander McKelvey on 1/6/26.
//

import Foundation
import WebKit
import Combine
import SwiftUI

class MusicViewModel: NSObject, ObservableObject, WKNavigationDelegate, WKUIDelegate {
    let webView: WKWebView
    @Published var isLoading = false
    @AppStorage("musicChannel") private var channelRaw: String = MusicChannel.production.rawValue
    private var lastObservedChannelRaw: String = MusicChannel.production.rawValue
    private var baseURL: URL {
        let ch = MusicChannel(rawValue: channelRaw) ?? .production
        return ch.baseURL
    }
    
    override init() {
        let configuration = WKWebViewConfiguration()
        
        // Standard preferences for a stable web experience
        configuration.preferences.isElementFullscreenEnabled = true
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        configuration.websiteDataStore = WKWebsiteDataStore.default() // Use persistent store so login/2FA trust can stick
        configuration.applicationNameForUserAgent = "AppleMusicCracked/1.0"
        
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
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        
        self.lastObservedChannelRaw = self.channelRaw
        NotificationCenter.default.addObserver(self, selector: #selector(defaultsDidChange), name: UserDefaults.didChangeNotification, object: nil)
    }
    
    func loadMusic() {
        webView.load(URLRequest(url: baseURL))
    }
    
    @objc private func defaultsDidChange() {
        let current = channelRaw
        if current != lastObservedChannelRaw {
            lastObservedChannelRaw = current
            loadMusic()
        }
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
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        DispatchQueue.main.async { self.isLoading = false }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        DispatchQueue.main.async { self.isLoading = false }
    }
    
    // MARK: - WKUIDelegate popup handling
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        // Open new window requests in the same web view to keep login flows consistent
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UserDefaults.didChangeNotification, object: nil)
    }
}

