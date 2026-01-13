//
//  OfflineFallbackView.swift
//  Apple Music Cracked Edition
//
//  Created by Alexander McKelvey on 1/13/26.
//


import SwiftUI

struct OfflineFallbackView: View {
    var title: String = "You're offline"
    var message: String = "We can't load content right now. Please check your connection and try again."
    var retryTitle: String = "Try Again"
    var tips: String? = "- Make sure Airplane Mode is off\n- Turn Wi‑Fi or Cellular Data on\n- Try moving to an area with better signal"
    var onRetry: (() -> Void)?

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "wifi.slash")
                .font(.system(size: 48, weight: .semibold))
                .foregroundStyle(.secondary)
                .padding(.bottom, 8)

            Text(title)
                .font(.title2).bold()

            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal)

            Button(action: { onRetry?() }) {
                Text(retryTitle)
                    .font(.headline)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 8)

            if let tips = tips {
                VStack(spacing: 6) {
                    Text("Tips")
                        .font(.footnote).bold()
                        .foregroundStyle(.secondary)
                    Text(tips)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 8)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(.background)
    }
}

#Preview {
    OfflineFallbackView(onRetry: {})
}
