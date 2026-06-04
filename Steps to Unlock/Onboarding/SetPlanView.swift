import SwiftUI

struct SetPlanView: View {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @AppStorage("stepGoals") private var stepGoals: Double = 200
    @AppStorage("timeEarned") private var timeEarned: Int = 30
    @AppStorage("secondsRemaining") private var secondsRemaining: Int = 1800
    @AppStorage("usageBaselineAtUnlock") private var usageBaselineAtUnlock: Double = 0
    @AppStorage("needsUsageBaselineInitialization") private var needsUsageBaselineInitialization: Bool = true
    @AppStorage("baselineSteps") private var baselineSteps: Int = 0
    @AppStorage("isLocked", store: UserDefaults(suiteName: "group.com.kee.Steps-to-Unlock")) private var lockStatus: Bool = false
    @AppStorage("lockActivatedAt", store: UserDefaults(suiteName: "group.com.kee.Steps-to-Unlock")) private var lockActivatedAt: Double = 0
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                
                Text("Set Your Plan!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 12)
                    .padding(.bottom, 32)
                
                // MARK: STEP GOALS
                SectionHeader(
                    icon: "figure.walk.motion",
                    title: "STEP GOALS",
                    subtitle: "Set the steps required to temporarily unlock the specific apps you chose to restrict"
                )
                
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
                .padding(16)
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .padding(.bottom, 32)
                
                // MARK: SCREEN TIME EARNED
                SectionHeader(
                    icon: "clock.fill",
                    title: "SCREEN TIME EARNED",
                    subtitle: "Choose how much extra screen time you are rewarded with after successfully completing your step goals"
                )

                VStack(spacing: 8) {
                    HStack {
                        Text("Duration")
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
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
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
        
        .overlay(alignment: .bottom) {
            Button(action: {
                secondsRemaining = timeEarned * 60
                usageBaselineAtUnlock = 0
                needsUsageBaselineInitialization = true
                baselineSteps = 0
                lockStatus = false
                lockActivatedAt = 0
                hasCompletedOnboarding = true
                DeviceActivityManager.shared.startMonitoring(timeLimitMinutes: timeEarned)
            }) {
                Text("Start Plan")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .tint(.indigo)
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
    }
}

#Preview {
    SetPlanView()
}
