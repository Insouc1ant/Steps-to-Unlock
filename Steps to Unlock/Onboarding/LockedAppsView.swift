import SwiftUI

struct LockedAppsView: View {
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
            
            Text("Select the apps you want to lock after your 30-minute allowance")
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
            NavigationLink(destination: TotalStepsView()) {
                Text("Continue (\(selectedApps.count))")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
            }
            .buttonStyle(LiquidGlassButtonStyle(isActive: !selectedApps.isEmpty))
            .disabled(selectedApps.isEmpty)
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
        .tint(.indigo)
    }
}

// Reusable Components

struct InlineSearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
                .font(.system(size: 18, weight: .medium))
            
            TextField("Search", text: $text)
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(.primary)
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

struct AppSelectionRow: View {
    let appName: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 44, height: 44)
            
            // Text
            Text(appName)
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(.primary)
            
            Spacer()
            
            // Toggle
            Toggle("", isOn: Binding(
                get: { isSelected },
                set: { _ in action() }
            ))
            .labelsHidden()
        }
        // Strict internal padding to prevent toggle cropping
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.clear)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                action()
            }
        }
    }
}

#Preview {
    LockedAppsView()
}

