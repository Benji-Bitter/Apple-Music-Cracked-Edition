//
//  MediaKeyTap.swift
//  Apple Music Cracked Edition
//
//  Created by apmckelvey on 1/30/26.
//


import Foundation
import IOKit.hid

/// MediaKeyTap listens to macOS Consumer Control (media) keys and exposes closures for handling presses.
/// Call `start()` early in app launch and set the `onPlayPause`, `onNext`, etc. closures to react.
final class MediaKeyTap {
    private var manager: IOHIDManager?
    private let consumerUsagePage: UInt32 = 0x0C

    // consumer usages
    private let usagePlayPause: UInt32 = 0xCD
    private let usageNext: UInt32 = 0xB5
    private let usagePrevious: UInt32 = 0xB6
    private let usageFastForward: UInt32 = 0xB3
    private let usageRewind: UInt32 = 0xB4

    // Callbacks you will set from your app
    var onPlayPause: (() -> Void)?
    var onNext: (() -> Void)?
    var onPrevious: (() -> Void)?
    var onFastForward: (() -> Void)?
    var onRewind: (() -> Void)?

    init() {
        setup()
    }

    deinit {
        stop()
    }

    private func setup() {
        manager = IOHIDManagerCreate(kCFAllocatorDefault, IOOptionBits(kIOHIDOptionsTypeNone))
        guard let mgr = manager else { return }

        let matching: [String: Any] = [
            kIOHIDDeviceUsagePageKey as String: consumerUsagePage,
            kIOHIDDeviceUsageKey as String: 1 // Consumer Control
        ]
        IOHIDManagerSetDeviceMatching(mgr, matching as CFDictionary)
        IOHIDManagerSetInputValueMatchingMultiple(mgr, [matching] as CFArray)

        let context = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        IOHIDManagerRegisterInputValueCallback(mgr, { context, result, sender, value in
            guard let context = context else { return }
            let me = Unmanaged<MediaKeyTap>.fromOpaque(context).takeUnretainedValue()
            me.handleInput(value: value)
        }, context)

        IOHIDManagerScheduleWithRunLoop(mgr, CFRunLoopGetMain(), CFRunLoopMode.defaultMode.rawValue)
        IOHIDManagerOpen(mgr, IOOptionBits(kIOHIDOptionsTypeNone))
    }

    func start() {
        if manager == nil { setup() }
    }

    func stop() {
        if let mgr = manager {
            IOHIDManagerUnscheduleFromRunLoop(mgr, CFRunLoopGetMain(), CFRunLoopMode.defaultMode.rawValue)
            IOHIDManagerClose(mgr, IOOptionBits(kIOHIDOptionsTypeNone))
        }
        manager = nil
    }

    private func handleInput(value: IOHIDValue!) {
        let element: IOHIDElement = IOHIDValueGetElement(value)

        let usagePage = IOHIDElementGetUsagePage(element)
        guard usagePage == consumerUsagePage else { return }

        let usage = IOHIDElementGetUsage(element)
        let intValue = IOHIDValueGetIntegerValue(value)
        // react on press only (non-zero)
        guard intValue != 0 else { return }

        switch usage {
        case usagePlayPause:
            onPlayPause?()
        case usageNext:
            onNext?()
        case usagePrevious:
            onPrevious?()
        case usageFastForward:
            onFastForward?()
        case usageRewind:
            onRewind?()
        default:
            break
        }
    }

    // Optional advanced helper: attempt to "seize" matched devices (risky).
    // Call this if you want to try blocking other apps/rcd from receiving the events.
    // Note: may not succeed on all devices/OS, and may require privileges. Use with caution.
    func attemptSeizeDevices() {
        guard let mgr = manager else { return }
        if let devs = IOHIDManagerCopyDevices(mgr) as? Set<IOHIDDevice> {
            for device in devs {
                // kIOHIDOptionsTypeSeizeDevice = 1 << 0
                let openResult = IOHIDDeviceOpen(device, IOOptionBits(kIOHIDOptionsTypeSeizeDevice))
                if openResult != kIOReturnSuccess {
                    // ignore or log
                }
            }
        }
    }
}
