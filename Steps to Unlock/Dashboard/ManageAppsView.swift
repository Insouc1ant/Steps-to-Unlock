import SwiftUI

struct ManageAppsView: View {
    // 1. The Environment variable that allows the screen to dismiss itself
    @Environment(\.dismiss) private var dismiss
    
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
        ScrollView(showsIndicators: true) {
            VStack(alignment: .leading, spacing: 0) {
                
                Text("Select apps to restrict once your allowance is reached. These apps require walking to unlock.")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(.secondary)
                    .padding(.top, 8)
                    .padding(.horizontal, 24)
                
                InlineSearchBar(text: $searchText)
                    .padding(.top, 24)
                    .padding(.bottom, 32)
                    .padding(.horizontal, 24)
                
                VStack(spacing: 0) {
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
                        
                        // Custom Divider (Hidden on the last item)
                        if index < filteredApps.count - 1 {
                            Divider()
                                .padding(.leading, 76)
                        }
                    }
                }
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
        
        .navigationTitle("Manage Apps")
        .navigationBarTitleDisplayMode(.inline) // Forces the title to center
        .navigationBarBackButtonHidden(true) // Hides the default Apple back button
        
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "chevron.left") // Native arrow
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Color(uiColor: .tertiaryLabel)) // Native gray
                    .contentShape(Rectangle())
                    .onTapGesture {
                        dismiss() // Navigates back to the Settings sheet
                    }
            }
        }
        .tint(.indigo)
    }
}

#Preview {
    NavigationStack {
        ManageAppsView()
    }
}
