//
//  DeviceActivityMonitorExtension.swift
//  AppMonitorExtension
//
//  Created by Ferdynand Kee on 27/04/26.
//

import DeviceActivity
import FamilyControls
import ManagedSettings
import Foundation

// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    private let store = ManagedSettingsStore()
    private let appGroupSuiteName = "group.com.kee.Steps-to-Unlock"
    private let savedAppTokensKey = "SavedAppTokens"
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        
        // Handle the start of the interval.
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        
        // Handle the end of the interval.
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        
        // Handle the event reaching its threshold: re-apply the shield to lock the apps.
        guard let data = UserDefaults(suiteName: appGroupSuiteName)?.data(forKey: savedAppTokensKey),
              let selection = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data) else {
            print("No saved app selection found to shield.")
            return
        }
        
        store.shield.applications = selection.applicationTokens
        store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(selection.categoryTokens)
        store.shield.webDomains = selection.webDomainTokens
        
        print("Threshold reached for \(event.rawValue) — apps re-locked.")
    }
    
    override func intervalWillStartWarning(for activity: DeviceActivityName) {
        super.intervalWillStartWarning(for: activity)
        
        // Handle the warning before the interval starts.
    }
    
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
        
        // Handle the warning before the interval ends.
    }
    
    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
        
        // Handle the warning before the event reaches its threshold.
    }
}
