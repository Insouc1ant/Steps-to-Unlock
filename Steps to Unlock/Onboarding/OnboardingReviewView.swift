// MARK: OPTIONAl FEATURE

import SwiftUI

// 1. The Data Model to hold unique settings for each day
struct DailyFocusRule {
    var startTime: Date
    var endTime: Date
    var stepTarget: Double
    
    // Helper to generate default times
    static func defaultRule() -> DailyFocusRule {
        return DailyFocusRule(
            startTime: Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date()) ?? Date(),
            endTime: Calendar.current.date(bySettingHour: 17, minute: 0, second: 0, of: Date()) ?? Date(),
            stepTarget: 700
        )
    }
}

struct OnboardingReviewView: View {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    // 2. State Management: An array of 7 rules, and an index to track which day we are viewing
    
    @State private var weeklyRules: [DailyFocusRule] = Array(repeating: .defaultRule(), count: 7)
    @State private var selectedDayIndex: Int = 0 // Defaults to Monday (Index 0)
    
    let daysOfWeek = ["M", "T", "W", "T", "F", "S", "S"]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                
                Text("Review your plan!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 12)
                    .padding(.bottom, 32)
                
                // Section 1: DAYS ACTIVE
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
                            // Now this acts like a Tab selector
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
                
                // Section 2: FOCUS SCHEDULE
                SectionHeader(
                    icon: "clock.fill",
                    title: "FOCUS SCHEDULE",
                    subtitle: "Apps are fully blocked during this window"
                )
                
                VStack(spacing: 0) {
                    HStack {
                        Text("Start time")
                            .font(.body) // Native 17pt Regular
                        Spacer()
                        // Binding directly to the specific day's data
                        DatePicker("", selection: $weeklyRules[selectedDayIndex].startTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    
                    Divider().padding(.leading, 16)
                    
                    HStack {
                        Text("End time")
                            .font(.body) // Native 17pt Regular
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
                
                // Section 3: STEP TARGET TO UNLOCK
                SectionHeader(
                    icon: "figure.walk",
                    title: "STEP TARGET TO UNLOCK",
                    subtitle: "Hit this step goal to earn an extra 30 minutes when your daily allowance runs out"
                )
                
                VStack(spacing: 8) {
                    HStack {
                        Text("Steps")
                            .font(.body) // Native 17pt Regular
                        Spacer()
                        Text("\(Int(weeklyRules[selectedDayIndex].stepTarget))")
                            .font(.headline) // Native 17pt Bold
                            .foregroundStyle(.indigo)
                    }
                    
                    Slider(value: $weeklyRules[selectedDayIndex].stepTarget, in: 100...3000, step: 100)
                        .tint(.indigo)
                    
                    HStack {
                        Text("100")
                            .font(.caption) // Native 12pt Regular
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text("3000")
                            .font(.caption) // Native 12pt Regular
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(16)
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                
                Spacer().frame(height: 120)
            }
            .padding(.horizontal, 24)
        }
        .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
        
        .overlay(alignment: .bottom) {
            Button(action: {
                print("Starting plan...")
                hasCompletedOnboarding = true
            }) {
                Text("Continue")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
            }
            .buttonStyle(LiquidGlassButtonStyle(isActive: true))
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
        .tint(.indigo)
    }
}

#Preview {
    OnboardingReviewView()
}
