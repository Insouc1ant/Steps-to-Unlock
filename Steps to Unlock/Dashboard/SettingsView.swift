import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @AppStorage("stepGoals") private var stepGoals: Double = 200
    @AppStorage("timeEarned") private var timeEarned: Int = 30
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    
                    // MARK: - Section 1: APPS
                    SectionHeader(
                        icon: "app.shadow",
                        title: "RESTRICTED APPS",
                        subtitle: "Select apps to restrict once your allowance is reached. These apps require walking to unlock."
                    )
                    .padding(.top, 36)
                    
                    NavigationLink(destination: ManageAppsView()) {
                        HStack {
                            Text("Manage Locked Apps")
                                .font(.body)
                                .foregroundStyle(.primary)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color(uiColor: .tertiaryLabel))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                        .background(Color(uiColor: .secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                    .buttonStyle(.plain)
                    
                    
                    // MARK: STEP GOALS
                    SectionHeader(
                        icon: "figure.walk.motion",
                        title: "STEP GOALS",
                        subtitle: "Set the steps required to temporarily unlock the specific apps you chose to restrict"
                    )
                    .padding(.top, 36)
                    
                    VStack(spacing: 8) {
                        HStack {
                            Text("Steps")
                                .font(.body) // Native 17pt Regular
                            Spacer()
                            Text("\(Int(stepGoals))")
                                .font(.headline) // Native 17pt Bold
                                .foregroundStyle(.indigo)
                        }
                        
                        Slider(value: $stepGoals, in: 100...2000, step: 10)
                            .tint(.indigo)
                        
                        HStack {
                            Text("100")
                                .font(.caption) // Native 12pt Regular
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text("2000")
                                .font(.caption) // Native 12pt Regular
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    
                    // MARK: SCREEN TIME EARNED
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
                                Text("Debug").tag(1)
                                Text("15 Minutes").tag(15)
                                Text("30 Minutes").tag(30)
                                Text("45 Minutes").tag(45)
                                Text("1 Hour").tag(60)
                                Text("1.5 Hours").tag(90)
                                Text("2 Hours").tag(120)
                            }
                            .pickerStyle(.menu)
                            .tint(.white)
                            // This adds a light gray background to the clickable picker
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
            
            
            
            // MARK: - Navigation
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
