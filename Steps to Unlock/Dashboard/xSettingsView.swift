import SwiftUI

struct xSettingsView: View {
    // 1. Native Modal Dismissal
    @Environment(\.dismiss) private var dismiss
    
    // 2. Shared State Management
    @State private var weeklyRules: [DailyFocusRule] = Array(repeating: .defaultRule(), count: 7)
    @State private var selectedDayIndex: Int = 0
    
    let daysOfWeek = ["M", "T", "W", "T", "F", "S", "S"]

    var body: some View {
        // 3. NavigationStack for Header and Toolbar
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    
                    // Section: APPS
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
                    .padding(.bottom, 32)
                    
                    // Section: DAYS ACTIVE
                    SectionHeader(
                        icon: "calendar",
                        title: "DAYS ACTIVE",
                        subtitle: "Customize your focus rules for each specific day"
                    )
                    
                    HStack(spacing: 13) {
                        ForEach(0..<7, id: \.self) { index in
                            DayCircleView(
                                day: daysOfWeek[index],
                                isSelected: selectedDayIndex == index
                            ) {
                                withAnimation(.snappy) {
                                    selectedDayIndex = index
                                }
                            }
                        }
                    }
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .padding(.bottom, 32)
                    
                    // Section: FOCUS SCHEDULE
                    SectionHeader(
                        icon: "clock.fill",
                        title: "FOCUS SCHEDULE",
                        subtitle: "Apps are fully blocked during this window"
                    )
                    
                    VStack(spacing: 0) {
                        HStack {
                            Text("Start time")
                                .font(.body)
                            Spacer()
                            DatePicker("", selection: $weeklyRules[selectedDayIndex].startTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        
                        Divider().padding(.leading, 16)
                        
                        HStack {
                            Text("End time")
                                .font(.body)
                            Spacer()
                            DatePicker("", selection: $weeklyRules[selectedDayIndex].endTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                    }
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .padding(.bottom, 32)
                    
                    // Section: STEP TARGET TO UNLOCK
                    SectionHeader(
                        icon: "figure.walk",
                        title: "STEP TARGET TO UNLOCK",
                        subtitle: "Hit this step goal to earn an extra 30 minutes when your daily allowance runs out"
                    )
                    
                    VStack(spacing: 8) {
                        HStack {
                            Text("Steps")
                                .font(.body)
                            Spacer()
                            Text("\(Int(weeklyRules[selectedDayIndex].stepTarget))")
                                .font(.headline)
                                .foregroundStyle(.indigo)
                        }
                        
                        Slider(value: $weeklyRules[selectedDayIndex].stepTarget, in: 100...3000, step: 100)
                            .tint(.indigo)
                        
                        HStack {
                            Text("100")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text("3000")
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
            }
            .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
            
            // Native Modifier for Title and Done Button
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
        xSettingsView()
    }
}
