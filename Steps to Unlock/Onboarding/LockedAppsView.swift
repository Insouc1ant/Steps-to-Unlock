import SwiftUI

struct LockedAppsView: View {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    
    @State private var searchText = ""
    @State private var selectedApps: Set<String> = []
    
    let allMockApps = [
        "Discord", "Facebook", "Instagram", "TikTok", "Reddit", "X", "YouTube"
    ]
    
    var filteredApps: [String] {
        if searchText.isEmpty {
            return allMockApps
        } else {
            return allMockApps.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Text("Which apps distract\nyou?")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 12)
            
            Text("Select apps to restrict once your allowance is reached. These apps require walking to unlock.")
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(.secondary)
                .padding(.top, 8)
            
            InlineSearchBar(text: $searchText)
                .padding(.top, 24)
                .padding(.bottom, 32)
            
            ScrollView(showsIndicators: true) {
                
                // 1. The Unified Card Container
                VStack(spacing: 0) {
                    
                    // Use enumerated() so we know which item is the last one
                    ForEach(Array(filteredApps.enumerated()), id: \.element) { index, appName in
                        
                        AppSelectionRow(
                            appName: appName,
                            isSelected: selectedApps.contains(appName)
                        ) {
                            if selectedApps.contains(appName) {
                                selectedApps.remove(appName)
                            } else {
                                selectedApps.insert(appName)
                            }
                        }
                        
                        // 2. The Custom Divider (Hidden on the last item)
                        if index < filteredApps.count - 1 {
                            Divider()
                                // 16px row padding + 44px icon + 16px spacing = 76px
                                .padding(.leading, 76)
                        }
                    }
                }
                
                // Card Styling
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .padding(.bottom, 100)
            }
        }
        .padding(.horizontal, 24)
        .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
        
        .overlay(alignment: .bottom) {
            NavigationLink(destination: SetPlanView())
            {
                Text("Continue (\(selectedApps.count))")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .tint(.indigo)
            .disabled(selectedApps.isEmpty)
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
    }
}

#Preview {
    LockedAppsView()
}

