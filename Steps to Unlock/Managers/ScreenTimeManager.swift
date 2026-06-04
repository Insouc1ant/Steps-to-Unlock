import Foundation
import FamilyControls
import ManagedSettings
internal import Combine

@MainActor
class ScreenTimeManager: ObservableObject {
    static let shared = ScreenTimeManager()
    private let savedAppTokensKey = "SavedAppTokens"
    private let appGroupSuiteName = "group.com.kee.Steps-to-Unlock"
    
    @Published var hasPermission: Bool = false

    let store = ManagedSettingsStore()

    func requestAuthorization() {
        Task {
            do {
                try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
                hasPermission = true
            } catch {
                print("Permission denied: \(error.localizedDescription)")
            }
        }
    }
    
    // Function to lock apps
    func lockApps(selections: FamilyActivitySelection) {
        // 1. Lock specific apps (like Instagram)
        store.shield.applications = selections.applicationTokens
        
        // 2. Lock entire categories (like "All Social Media")
        store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(selections.categoryTokens)
        
        // 3. Lock websites (like reddit.com on Safari)
        store.shield.webDomains = selections.webDomainTokens
        
        print("Successfully lock \(selections.applicationTokens.count)apps!")
    }
    
    // Function to unlock apps
    func unlockApps() {
        store.clearAllSettings()
        print("All apps unlocked!")
    }

    // 1. SAVE the selection to the iPhone's hard drive
    func saveSelection(_ selection: FamilyActivitySelection) {
        if let encoded = try? JSONEncoder().encode(selection) {
            UserDefaults.standard.set(encoded, forKey: savedAppTokensKey)
            UserDefaults(suiteName: appGroupSuiteName)?.set(encoded, forKey: savedAppTokensKey)
            print("App selections saved to hard drive.")
        }
    }

    func loadSelection() -> FamilyActivitySelection? {
        let sharedDefaults = UserDefaults(suiteName: appGroupSuiteName)

        guard let data = sharedDefaults?.data(forKey: savedAppTokensKey)
            ?? UserDefaults.standard.data(forKey: savedAppTokensKey),
              let savedSelection = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data) else {
            return nil
        }

        return savedSelection
    }
    
    // 2. LOAD the selection and DROP THE SHIELDS
    func loadAndLockApps() {
        guard let savedSelection = loadSelection() else {
            print("No apps were saved to block.")
            return
        }
        
        // Use the existing function to lock them
        lockApps(selections: savedSelection)
    }
}
