import SwiftUI
import ManagedSettings
import DeviceActivity
import FamilyControls
internal import Combine

extension DeviceActivityReport.Context {
    static let totalActivity = Self("Total Activity")
}

struct DashboardView: View {
    @Environment(\.scenePhase) private var scenePhase

    private let usageRefreshTimer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()

    @State private var selectedApps = FamilyActivitySelection()
    @State private var reportRefreshID = UUID()
    @AppStorage("selectedAppsUsageToday", store: UserDefaults(suiteName: "group.com.kee.Steps-to-Unlock")) private var selectedAppsUsageToday: Int = 0
    @AppStorage("lockActivatedAt", store: UserDefaults(suiteName: "group.com.kee.Steps-to-Unlock")) private var lockActivatedAt: Double = 0
    @AppStorage("stepGoals") private var stepGoals: Double = 200
    @AppStorage("timeEarned") private var timeEarned: Int = 30
    @AppStorage("isLocked", store: UserDefaults(suiteName: "group.com.kee.Steps-to-Unlock")) var lockStatus: Bool = false
    @AppStorage("secondsRemaining") private var secondsRemaining: Int = 1800
    @AppStorage("baselineSteps") private var baselineSteps: Int = 0
    @AppStorage("usageBaselineAtUnlock") private var usageBaselineAtUnlock: Double = 0
    @AppStorage("needsUsageBaselineInitialization") private var needsUsageBaselineInitialization: Bool = true
    
    
    @StateObject private var stepManager = StepManager()
    @State private var showingSettings = false
    @State private var showingInfoAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
//    var formattedTimeUsed: String {
//            let hours = selectedAppsUsageToday / 3600
//            let minutes = (selectedAppsUsageToday % 3600) / 60
//            
//            if hours > 0 {
//                return "\(hours) h \(minutes) m"
//            } else {
//                return "\(minutes) m"
//            }
//        }
    // MARK: - App Selection Helpers
    private var selectedCategoryTokens: [ActivityCategoryToken] {
        Array(selectedApps.categoryTokens)
    }

    private var selectedApplicationTokens: [ApplicationToken] {
        Array(selectedApps.applicationTokens)
    }

    private var totalSelectionsCount: Int {
        selectedCategoryTokens.count + selectedApplicationTokens.count
    }

    var currentSteps: Int {
        // Prevent negative numbers
        max(0, stepManager.liveSteps - baselineSteps)
    }

    private var allowanceSeconds: Int {
        timeEarned * 60
    }

    private var reportFilter: DeviceActivityFilter? {
        guard !selectedApps.applicationTokens.isEmpty
                || !selectedApps.categoryTokens.isEmpty
                || !selectedApps.webDomainTokens.isEmpty else {
            return nil
        }

        let today = Calendar.current.dateInterval(of: .day, for: .now) ?? DateInterval(start: .now, end: .now)

        return DeviceActivityFilter(
            segment: .daily(during: today),
            users: .all,
            devices: .init([.iPhone, .iPad]),
            applications: selectedApps.applicationTokens,
            categories: selectedApps.categoryTokens,
            webDomains: selectedApps.webDomainTokens
        )
    }

//    @ViewBuilder
//    private var usageReportPanel: some View {
//        if let reportFilter {
//            DeviceActivityReport(.totalActivity, filter: reportFilter)
//                .id(reportRefreshID)
//                .frame(height: 28)
//            .padding(.horizontal, 24)
//            .padding(.top, 12)
//        }
//    }

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
                }) {
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
                timeEarned: timeEarned,
                stepsWalked: currentSteps,
                stepTarget: Int(stepGoals)
            )
            .padding(.bottom, 36)
            
            // App Status Indicator
            StatusIndicatorView(isLocked: lockStatus, stepTarget: Int(stepGoals), timeEarned: timeEarned)
                .padding(.bottom, 16)
            
            // Stat Cards
            VStack(spacing: 16) {
                // RESTRICTED APPS CARD
                if totalSelectionsCount > 0 {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "app.shadow")
                                .foregroundStyle(.indigo)
                            Text("Restricted Apps")
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(.secondary)
                            
                            Spacer()
                            
                            Button {
                                self.alertTitle = "Restricted Apps"
                                self.alertMessage = "These are the apps and categories that will automatically lock when your timer reaches zero."
                                self.showingInfoAlert = true
                            } label: {
                                Image(systemName: "info.circle")
                                    .font(.system(size: 20)) // Matches the Steps Today button size
                                    .foregroundStyle(Color(uiColor: .tertiaryLabel)) // Matches the Steps Today button color
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        
                        // Horizontal Icon Scroll
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                // Categories
                                ForEach(Array(selectedCategoryTokens.enumerated()), id: \.element) { _, token in
                                    Label(token)
                                        .labelStyle(.iconOnly)
                                        .font(.largeTitle) // Makes the Apple icon larger
                                }
                                
                                // Apps
                                ForEach(Array(selectedApplicationTokens.enumerated()), id: \.element) { _, token in
                                    Label(token)
                                        .labelStyle(.iconOnly)
                                        .font(.largeTitle) // Makes the Apple icon larger
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        .frame(height: 50)
                        .padding(.bottom, 12)
                    }
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                
                // 🏃‍♂️ STEPS TODAY CARD
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

//            usageReportPanel
            
            Spacer()
        }
        .alert(alertTitle, isPresented: $showingInfoAlert) {
                        Button("Got it", role: .cancel) { }
                    } message: {
                        Text(alertMessage)
                    }
        .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .onAppear {
            loadSelectedApps()
            stepManager.startTracking()
            
            // Ask for notification permission
            NotificationManager.shared.requestPermission()

            refreshUsageFromSharedStore()
            refreshUsageReport()
            recalculateAllowance()
            if lockStatus {
                refreshBaselineStepsForCurrentLock()
            }

            if !lockStatus {
                DeviceActivityManager.shared.startMonitoring(timeLimitMinutes: timeEarned)
            }
        }
        // MARK: LOGIC
        .onChange(of: stepManager.liveSteps) { _, _ in
            if lockStatus {
                if currentSteps >= Int(stepGoals) {
                    lockStatus = false
                    usageBaselineAtUnlock = Double(selectedAppsUsageToday)
                    needsUsageBaselineInitialization = false
                    secondsRemaining = allowanceSeconds
                    ScreenTimeManager.shared.unlockApps()
                    DeviceActivityManager.shared.startMonitoring(timeLimitMinutes: timeEarned)
                    NotificationManager.shared.scheduleNotification(
                        title: "Step Goals Reached! 🎯",
                        body: "Great job! Your apps are unlocked for another \(timeEarned) minutes!"
                    )
                }
            }
        }
        .onChange(of: lockStatus) { _, isLocked in
            if isLocked {
                secondsRemaining = 0
                refreshBaselineStepsForCurrentLock()
            } else {
                baselineSteps = 0
                lockActivatedAt = 0
            }
        }
        .onChange(of: selectedAppsUsageToday) { _, _ in
            if needsUsageBaselineInitialization && !lockStatus {
                usageBaselineAtUnlock = Double(selectedAppsUsageToday)
                needsUsageBaselineInitialization = false
            }

            recalculateAllowance()
        }
        .onChange(of: timeEarned) { _, _ in
            recalculateAllowance()
            if !lockStatus {
                usageBaselineAtUnlock = Double(selectedAppsUsageToday)
                DeviceActivityManager.shared.startMonitoring(timeLimitMinutes: timeEarned)
            }
        }
        .onChange(of: showingSettings) { _, isShowingSettings in
            if !isShowingSettings {
                loadSelectedApps()
                refreshUsageReport()
                refreshUsageFromSharedStore()
                recalculateAllowance()
            }
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                refreshUsageReport()
                refreshUsageFromSharedStore()
                recalculateAllowance()
            }
        }
        .onReceive(usageRefreshTimer) { _ in
            guard scenePhase == .active, !lockStatus else { return }
            refreshUsageReport()
            refreshUsageFromSharedStore()
        }
    }

    private func loadSelectedApps() {
        selectedApps = ScreenTimeManager.shared.loadSelection() ?? FamilyActivitySelection()
    }

    private func recalculateAllowance() {
        guard !lockStatus else {
            secondsRemaining = 0
            return
        }

        let usedThisCycle = max(0, selectedAppsUsageToday - Int(usageBaselineAtUnlock))
        secondsRemaining = max(0, allowanceSeconds - usedThisCycle)
    }

    private func refreshBaselineStepsForCurrentLock() {
        guard lockActivatedAt > 0 else {
            baselineSteps = stepManager.liveSteps
            return
        }

        let lockDate = Date(timeIntervalSince1970: lockActivatedAt)

        Task {
            baselineSteps = await stepManager.stepsToday(upTo: lockDate)
        }
    }

    private func refreshUsageReport() {
        reportRefreshID = UUID()
    }

    private func refreshUsageFromSharedStore() {
        guard let appGroupDefaults = UserDefaults(suiteName: "group.com.kee.Steps-to-Unlock") else { return }
        selectedAppsUsageToday = appGroupDefaults.integer(forKey: "selectedAppsUsageToday")
    }
}

#Preview {
    DashboardView()
}
