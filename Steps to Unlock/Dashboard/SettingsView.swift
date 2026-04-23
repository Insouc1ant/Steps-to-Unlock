import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    // Save the stepTarget to device
    @AppStorage("dailyStepTarget") private var stepTarget: Double = 200
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    
                    // MARK: - Section 1: APPS
                    SectionHeader(
                        icon: "app.shadow",
                        title: "APPS",
                        subtitle: "Select the apps you want to lock"
                    )
                    .padding(.top, 24)
                    
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
                    .padding(.bottom, 48)
                    
                    
                    // MARK: - Section 2: STEP TARGET TO UNLOCK
                    SectionHeader(
                        icon: "figure.walk",
                        title: "STEP TARGET TO UNLOCK",
                        subtitle: "Hit this step goal to earn an extra 30 minutes when your daily allowance runs out"
                    )

                    VStack(spacing: 12) {
                        HStack {
                            Text("Steps")
                                .font(.body)
                            Spacer()
                            Text("\(Int(stepTarget))")
                                .font(.headline)
                                .foregroundStyle(.indigo)
                        }
                        
                        Slider(value: $stepTarget, in: 100...2000, step: 10)
                            .tint(.indigo)
                        
                        HStack {
                            Text("100")
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
                    
                    Spacer().frame(height: 60)
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
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
