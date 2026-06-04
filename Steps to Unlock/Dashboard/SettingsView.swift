import SwiftUI
import ManagedSettings
import FamilyControls

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @AppStorage("stepGoals") private var stepGoals: Double = 200
    @AppStorage("timeEarned") private var timeEarned: Int = 30
    
    @State private var isPickerPresented = false
    @State private var selectedApps = FamilyActivitySelection()
    
    // MARK: - Computed Properties for the List
    private let rowHeight: CGFloat = 56
    private let maxListHeight: CGFloat = 336 // 56 * 6 rows
    
    private var selectedCategoryTokens: [ActivityCategoryToken] {
        Array(selectedApps.categoryTokens)
    }

    private var selectedApplicationTokens: [ApplicationToken] {
        Array(selectedApps.applicationTokens)
    }

    private var totalSelectionsCount: Int {
        selectedCategoryTokens.count + selectedApplicationTokens.count
    }

    private var hasValidSelection: Bool {
        totalSelectionsCount > 0
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    
                    // MARK: - Section 1: APPS
                    SectionHeader(
                        icon: "app.shadow",
                        title: "RESTRICTED APPS",
                        subtitle: "Select apps to restrict once your allowance is reached.\nThese apps require walking to unlock."
                    )
                    .padding(.top, 36)
                    
                    Button {
                        isPickerPresented = true
                    } label: {
                        HStack {
                            // 🐛 BUG FIXED: Now counts Categories AND Apps correctly
                            Text(!hasValidSelection ? "Manage Locked Apps" : "\(totalSelectionsCount) Selections Added")
                                .font(.body)
                                .foregroundStyle(.primary)
                                .tint(.indigo)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color(uiColor: .tertiaryLabel))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                        .background(Color(uiColor: .secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                    
                    // 📦 COMBINED LIST: Categories + Individual Apps
                    if hasValidSelection {
                        Spacer().frame(height: 16)

                        Text("Selected Items")
                            .font(.headline)
                            .foregroundStyle(.primary)
                            .padding(.horizontal, 8)
                            .padding(.bottom, 8)

                        ScrollView(showsIndicators: totalSelectionsCount > 6) {
                            VStack(spacing: 0) {
                                
                                // 1. Loop through Categories First
                                ForEach(Array(selectedCategoryTokens.enumerated()), id: \.element) { index, token in
                                    VStack(spacing: 0) {
                                        HStack(spacing: 12) {
                                            Label(token)
                                                .labelStyle(.titleAndIcon)
                                                .font(.body)
                                                .foregroundStyle(.primary)

                                            Spacer()
                                        }
                                        .frame(height: rowHeight)
                                        .padding(.horizontal, 16)

                                        if index < selectedCategoryTokens.count - 1 || !selectedApplicationTokens.isEmpty {
                                            Divider().padding(.leading, 52)
                                        }
                                    }
                                }
                                
                                // 2. Loop through Individual Apps Second
                                ForEach(Array(selectedApplicationTokens.enumerated()), id: \.element) { index, token in
                                    VStack(spacing: 0) {
                                        HStack(spacing: 12) {
                                            Label(token)
                                                .labelStyle(.titleAndIcon)
                                                .font(.body)
                                                .foregroundStyle(.primary)

                                            Spacer()
                                        }
                                        .frame(height: rowHeight)
                                        .padding(.horizontal, 16)

                                        if index < selectedApplicationTokens.count - 1 {
                                            Divider().padding(.leading, 52)
                                        }
                                    }
                                }
                            }
                        }
                        // Dynamically size the box based on total items, max 6 rows
                        .frame(height: min(CGFloat(totalSelectionsCount) * rowHeight, maxListHeight))
                        .background(Color(uiColor: .secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                    
                    
                    // MARK: - Section 2: STEP GOALS
                    SectionHeader(
                        icon: "figure.walk.motion",
                        title: "STEP GOALS",
                        subtitle: "Set the steps required to temporarily unlock the specific apps you chose to restrict"
                    )
                    .padding(.top, 36)
                    
                    VStack(spacing: 8) {
                        HStack {
                            Text("Steps")
                                .font(.body)
                            Spacer()
                            Text("\(Int(stepGoals))")
                                .font(.headline)
                                .foregroundStyle(.indigo)
                        }
                        
                        Slider(value: $stepGoals, in: 50...2000, step: 10)
                            .tint(.indigo)
                        
                        HStack {
                            Text("50")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text("2000")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    
                    // MARK: - Section 3: SCREEN TIME EARNED
                    SectionHeader(
                        icon: "clock.fill",
                        title: "SCREEN TIME EARNED",
                        subtitle: "Choose how much extra screen time you are rewarded with after successfully completing your step goals"
                    )
                    .padding(.top, 36)

                    VStack(spacing: 12) {
                        HStack {
                            Text("Allowance Duration")
                                .font(.body)
                            
                            Spacer()
                            
                            Picker("Reward Time", selection: $timeEarned) {
                                Text("1 Minute").tag(1)
                                Text("15 Minutes").tag(15)
                                Text("30 Minutes").tag(30)
                                Text("45 Minutes").tag(45)
                                Text("1 Hour").tag(60)
                                Text("1.5 Hours").tag(90)
                                Text("2 Hours").tag(120)
                            }
                            .pickerStyle(.menu)
                            .tint(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color(uiColor: .systemIndigo))
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 18)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .padding(.bottom, 32)
                }
                .padding(.horizontal, 24)

            }
            .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
            
            // MARK: - Modifiers
            .familyActivityPicker(
                isPresented: $isPickerPresented,
                selection: $selectedApps
            )
            .onChange(of: selectedApps) { oldValue, newValue in
                ScreenTimeManager.shared.saveSelection(newValue)
            }
            .onAppear {
                if let data = UserDefaults.standard.data(forKey: "SavedAppTokens"),
                   let savedSelection = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data) {
                    selectedApps = savedSelection
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(Color(uiColor: .tertiaryLabel))
                        .contentShape(Rectangle())
                        .onTapGesture {
                            dismiss()
                        }
                }
            }
        }
    }
}

#Preview {
    Color.clear.sheet(isPresented: .constant(true)) {
        SettingsView()
    }
}
