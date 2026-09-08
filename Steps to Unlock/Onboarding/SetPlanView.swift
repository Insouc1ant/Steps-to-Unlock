import SwiftUI

struct SetPlanView: View {
    @Environment(\.dismiss) private var dismiss
    
    // 🛡️ Pure in-memory @State: Zero disk writes or background sync until user taps "Start Plan"!
    @State private var stepGoals: Double = 200
    @State private var timeEarned: Int = 30
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Set Your Plan!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 12)
                .padding(.bottom, 28)
            
            // MARK: STEP GOALS
            SectionHeader(
                icon: "figure.walk.motion",
                title: "STEP GOALS",
                subtitle: "Set the steps required to temporarily unlock the specific apps you chose to restrict"
            )
            
            StepGoalCard(stepGoals: $stepGoals)
                .padding(.bottom, 28)
            
            // MARK: SCREEN TIME EARNED
            SectionHeader(
                icon: "clock.fill",
                title: "SCREEN TIME EARNED",
                subtitle: "Choose how much extra screen time you are rewarded with after successfully completing your step goals"
            )

            ScreenTimeEarnedCard(timeEarned: $timeEarned)
                .padding(.bottom, 28)

            Spacer()

            Button(action: startPlan) {
                Text("Start Plan")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .tint(.indigo)
            .padding(.bottom, 16)
        }
        .padding(.horizontal, 24)
        .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Back")
                            .font(.body)
                    }
                    .foregroundStyle(.indigo)
                }
            }
        }
    }

    private func startPlan() {
        let appGroupDefaults = UserDefaults(suiteName: "group.com.kee.Steps-to-Unlock")
        appGroupDefaults?.set(Int(stepGoals), forKey: "stepGoals")
        appGroupDefaults?.set(timeEarned, forKey: "timeEarned")
        appGroupDefaults?.set(false, forKey: "isLocked")
        appGroupDefaults?.set(0, forKey: "lockActivatedAt")

        UserDefaults.standard.set(stepGoals, forKey: "stepGoals")
        UserDefaults.standard.set(timeEarned, forKey: "timeEarned")
        UserDefaults.standard.set(timeEarned * 60, forKey: "secondsRemaining")
        UserDefaults.standard.set(0, forKey: "usageBaselineAtUnlock")
        UserDefaults.standard.set(true, forKey: "needsUsageBaselineInitialization")
        UserDefaults.standard.set(0, forKey: "baselineSteps")

        DeviceActivityManager.shared.startMonitoring(timeLimitMinutes: timeEarned)

        NotificationManager.shared.requestPermission { _ in
            DispatchQueue.main.async {
                UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
            }
        }
    }
}

// MARK: - Isolated Slider Card (Prevents main screen re-rendering on drag)
struct StepGoalCard: View {
    @Binding var stepGoals: Double

    var body: some View {
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
    }
}

// MARK: - Isolated Screen Time Card
struct ScreenTimeEarnedCard: View {
    @Binding var timeEarned: Int

    var body: some View {
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
    }
}

#Preview {
    SetPlanView()
}
