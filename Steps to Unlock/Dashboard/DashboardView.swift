import SwiftUI

// 1. The State Enum
enum AppStatus {
    case unlocked
    case locked
}

struct DashboardView: View {
    @State private var showingSettings = false
    // 2. The Unified State Variable (Tap the title to toggle this for testing)
    @State private var currentStatus: AppStatus = .unlocked
    
    // Mock Data
    let minutesRemaining = "11:18"
    let stepsWalked = 288
    
    @AppStorage("dailyStepTarget") private var stepTarget: Double = 200
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Header (Title & Gear)
            HStack(alignment: .center) {
                Text("Dashboard")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    // DEBUG TOGGLE: Tap the title to switch states!
                    .onTapGesture {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            currentStatus = currentStatus == .unlocked ? .locked : .unlocked
                        }
                    }
                
                Spacer()
                Button(action: {
                    showingSettings = true
                }){
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .scaledToFit()
                        // Visual size is 38x38 per your Sketch
                        .frame(width: 38, height: 38)
                        .foregroundStyle(Color(uiColor: .systemGray2))
                        // Accessibility hit target increased to 44x44
                        .frame(width: 44, height: 44)
                }
            }
            .padding(.top, 42)
            .padding(.horizontal, 24)
            .padding(.bottom, 48)
            
            // Circular Progress
            HeroProgressRing(
                status: currentStatus,
                minutesRemaining: minutesRemaining,
                stepsWalked: stepsWalked,
                stepTarget: Int(stepTarget)
            )
            .padding(.bottom, 40)
            
            // App Status Indicator
            HStack(spacing: 8) {
                Image(systemName: currentStatus == .unlocked ? "lock.open.fill" : "lock.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
                
                Text(currentStatus == .unlocked ? "Apps Unlocked" : "Apps Locked")
                    .font(.footnote.weight(.semibold)) // Native 13pt
            }
            // App Status Color
            .foregroundStyle(currentStatus == .unlocked ? .green : .red)
            .padding(.bottom, 17)
            
            // Stat Cards
            HStack(spacing: 16) {
                StatCardView(
                    icon: "clock.fill",
                    title: "Time Used",
                    value: "1h 18m",
                    tintColor: .indigo
                )
                
                StatCardView(
                    icon: "figure.walk",
                    title: "Steps Today",
                    value: "1888",
                    tintColor: .orange
                )
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
        .sheet(isPresented: $showingSettings) {
            xSettingsView()
        }
    }
}

// Reusable Components

struct HeroProgressRing: View {
    let status: AppStatus
    let minutesRemaining: String
    let stepsWalked: Int
    let stepTarget: Int
    
    // Time and Steps Color Change
    var ringColor: Color {
        status == .unlocked ? .indigo : .orange
    }
    
    var progressAmount: Double {
        status == .unlocked
            ? 0.35 // Example: 35% time remaining
            : Double(stepsWalked) / Double(stepTarget)
    }
    
    var body: some View {
        ZStack {
            // Background Track
            Circle()
                .stroke(Color.gray.opacity(0.15), lineWidth: 24)
            
            // Progress Fill
            Circle()
                .trim(from: 0.0, to: progressAmount)
                .stroke(ringColor, style: StrokeStyle(lineWidth: 24, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 1.0, dampingFraction: 0.8), value: progressAmount)

            // Dynamic Text inside the circle
            VStack(spacing: 4) {
                if status == .unlocked {
                    Text(minutesRemaining)
                        .font(.system(size: 48, weight: .semibold, design: .rounded))
                    
                    Text("minutes remaining")
                        .font(.subheadline) // Native 15pt
                        .foregroundStyle(.secondary)
                } else {
                    Text("\(stepsWalked)")
                        .font(.system(size: 48, weight: .semibold, design: .rounded))
                    
                    Text("of \(stepTarget) steps")
                        .font(.subheadline) // Native 15pt
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(width: 280, height: 280)
    }
}

struct StatCardView: View {
    let icon: String
    let title: String
    let value: String
    let tintColor : Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) { // 24px padding before the value
            
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(tintColor)
                
                Text(title)
                    .font(.footnote.weight(.semibold)) // Native 13pt
                
                Spacer()
            }
            .foregroundStyle(.secondary)
            
            Text(value)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
        }
        .padding(16)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}


#Preview {
    DashboardView()
}
