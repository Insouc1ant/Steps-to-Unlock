import SwiftUI
internal import Combine

struct DashboardView: View {
    @AppStorage("stepGoals") private var stepGoals: Double = 200
    @AppStorage("timeEarned") private var timeEarned: Int = 30
    @AppStorage("isLocked") private var lockStatus: Bool = false
    @AppStorage("secondsRemaining") private var secondsRemaining: Int = 1800
    @AppStorage("baselineSteps") private var baselineSteps: Int = 0
    @AppStorage("timeUsedToday") private var timeUsedToday: Int = 0
    @AppStorage("lastOpenedDate") private var lastOpenedDate: String = ""
    
    
    @StateObject private var stepManager = StepManager()
    @State private var showingSettings = false
    @State private var showingInfoAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    // Timer
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // Helper to format "MM:SS"
    var formattedTime: String {
        let minutes = secondsRemaining / 60
        let seconds = secondsRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var formattedTimeUsed: String {
            let hours = timeUsedToday / 3600
            let minutes = (timeUsedToday % 3600) / 60
            
            if hours > 0 {
                return "\(hours) h \(minutes) m"
            } else {
                return "\(minutes) m"
            }
        }
    
    var currentSteps: Int {
        // Prevent negative numbers
        max(0, stepManager.liveSteps - baselineSteps)
    }

    var body: some View {
        VStack(spacing: 0) {
            
            // Header (Title & Gear)
            HStack(alignment: .center) {
                Text("Dashboard")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
                Button(action: {
                    showingSettings = true
                }){
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 38, height: 38)
                        .foregroundStyle(Color(uiColor: .systemGray2))
                        .frame(width: 44, height: 44)
                }
            }
            .padding(.top, 24)
            .padding(.horizontal, 18)
            .padding(.bottom, 32)
            
            // Circular Progress
            HeroProgressRing(
                isLocked : lockStatus,
                minutesRemaining: formattedTime,
                secRemaining: secondsRemaining,
                totalSeconds: timeEarned * 60,
                stepsWalked: currentSteps,
                stepTarget: Int(stepGoals)
            )
            .padding(.bottom, 36)
            
            // App Status Indicator
            StatusIndicatorView(isLocked: lockStatus, stepTarget: Int(stepGoals), timeEarned: timeEarned)
                .padding(.bottom, 16)
            
            // Stat Cards
            VStack(spacing: 16) {
                StatCardView(
                    icon: "clock.fill",
                    title: "Allowance Used Today",
                    value: formattedTimeUsed,
                    tintColor: .indigo
                ) {
                    alertTitle = "Allowance Used Today"
                    alertMessage = "This tracks the total time your restricted apps have been unlocked today.\n\nResets everyday at midnight."
                    showingInfoAlert = true
                }
                
                StatCardView(
                    icon: "figure.walk.motion",
                    title: "Steps Today",
                    value: "\(stepManager.liveSteps)",
                    tintColor: .orange
                ) {
                    alertTitle = "Steps Today"
                    alertMessage = "Your total physical steps recorded today. Keep walking!\n\nResets everyday at midnight."
                    showingInfoAlert = true
                }
            }
            .padding(.horizontal, 24)
            .alert(alertTitle, isPresented: $showingInfoAlert) {
                            Button("Got it", role: .cancel) { }
                        } message: {
                            Text(alertMessage)
                        }
            
            Spacer()
        }
        .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .onAppear {
            stepManager.startTracking()
            
            // New day Reset
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let todayString = dateFormatter.string(from: Date())
    
            if lastOpenedDate != todayString {
                timeUsedToday = 0
                lastOpenedDate = todayString
            }
            
            // First time app opens check
            if secondsRemaining == 0 && !lockStatus {
                secondsRemaining = timeEarned * 60
            }
        }
        // MARK: LOGIC
        .onReceive(timer) { _ in
            if !lockStatus && secondsRemaining > 0 {
                
                // Time Countdown
                secondsRemaining -= 1
                
                // Stats Tracking
                timeUsedToday += 1
                
                // Out ot time
                if secondsRemaining == 0 {
                    lockStatus = true
                    baselineSteps = stepManager.liveSteps
                }
            }
        }
        .onChange(of: stepManager.liveSteps) {
            if lockStatus {
                if currentSteps >= Int(stepGoals) {
                    lockStatus = false
                    secondsRemaining = timeEarned * 60
                }
            }
        }
        
        // Reset timer when settings updated
        .onChange(of: timeEarned) {
                    if !lockStatus {
                        secondsRemaining = timeEarned * 60
                    }
                }
    }
}

#Preview {
    DashboardView()
}
