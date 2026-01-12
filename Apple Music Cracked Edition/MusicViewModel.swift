//
//  MusicViewModel.swift
//  Apple Music Cracked Edition
//
//  Created by Alexander McKelvey on 1/5/26.
//

import Foundation
import WebKit
import Combine
import MediaPlayer

class MusicViewModel: NSObject, ObservableObject, WKNavigationDelegate, WKUIDelegate {
    let webView: WKWebView
    private var titleObservation: NSKeyValueObservation?
    
    override init() {
        let configuration = WKWebViewConfiguration()
        // Essential for Control Center recognition
        configuration.allowsAirPlayForMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        
        self.webView = WKWebView(frame: .zero, configuration: configuration)
        super.init()
        
        webView.navigationDelegate = self
        setupRemoteCommandCenter()
        setupTitleObserver()
    }
    
    func loadMusic() {
        guard let url = URL(string: "https://music.apple.com") else { return }
        webView.load(URLRequest(url: url))
    }

    func setupRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        // Remove existing targets to prevent duplicate triggers
        commandCenter.playCommand.removeTarget(nil)
        commandCenter.pauseCommand.removeTarget(nil)
        commandCenter.nextTrackCommand.removeTarget(nil)
        commandCenter.previousTrackCommand.removeTarget(nil)
        
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { [weak self] _ in
            self?.webView.evaluateJavaScript("document.querySelector('button[aria-label*=\"Play\"]').click()")
            return .success
        }
        
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.webView.evaluateJavaScript("document.querySelector('button[aria-label*=\"Pause\"]').click()")
            return .success
        }
        
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.nextTrackCommand.addTarget { [weak self] _ in
            self?.webView.evaluateJavaScript("document.querySelector('button[aria-label*=\"Next\"]').click()")
            return .success
        }
        
        commandCenter.previousTrackCommand.isEnabled = true
        commandCenter.previousTrackCommand.addTarget { [weak self] _ in
            self?.webView.evaluateJavaScript("document.querySelector('button[aria-label*=\"Previous\"]').click()")
            return .success
        }
    }
    
    private func setupTitleObserver() {
        titleObservation = webView.observe(\.title, options: .new) { [weak self] _, change in
            if let title = change.newValue as? String {
                self?.updateNowPlaying(title: title)
            }
        }
    }
    
    private func updateNowPlaying(title: String) {
        let cleanTitle = title.replacingOccurrences(of: " — Apple Music", with: "")
                             .replacingOccurrences(of: "Apple Music", with: "")
        
        var info = [String: Any]()
        info[MPMediaItemPropertyTitle] = cleanTitle
        info[MPNowPlayingInfoPropertyPlaybackRate] = 1.0
        
        // REQUIRED: Tell macOS the state is actually 'playing' to wake up Control Center
        MPNowPlayingInfoCenter.default().playbackState = .playing
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
    }
}
