import SwiftUI

struct TotalStepsView: View {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @AppStorage("dailyStepTarget") private var stepTarget: Double = 200
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                
                Text("Review your plan!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 12)
                    .padding(.bottom, 32)
                
                // STEP TARGET TO UNLOCK
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
                        Text("\(Int(stepTarget))")
                            .font(.headline) // Native 17pt Bold
                            .foregroundStyle(.indigo)
                    }
                    
                    Slider(value: $stepTarget, in: 100...2000, step: 10)
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
    TotalStepsView()
}
