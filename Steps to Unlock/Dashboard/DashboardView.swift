import SwiftUI
import ManagedSettings
import DeviceActivity
import FamilyControls

struct DashboardView: View {
    @Environment(\.scenePhase) private var scenePhase

    // MARK: - App Group & Persistent State
    @AppStorage("isLocked", store: UserDefaults(suiteName: "group.com.kee.Steps-to-Unlock")) var lockStatus: Bool = false
    @AppStorage("selectedAppsUsageToday", store: UserDefaults(suiteName: "group.com.kee.Steps-to-Unlock")) private var selectedAppsUsageToday: Int = 0
    @AppStorage("lockActivatedAt", store: UserDefaults(suiteName: "group.com.kee.Steps-to-Unlock")) private var lockActivatedAt: Double = 0
    @AppStorage("stepGoals") private var stepGoals: Double = 200
    @AppStorage("timeEarned") private var timeEarned: Int = 30
    @AppStorage("secondsRemaining") private var secondsRemaining: Int = 1800
    @AppStorage("baselineSteps") private var baselineSteps: Int = 0
    @AppStorage("usageBaselineAtUnlock") private var usageBaselineAtUnlock: Double = 0
    @AppStorage("needsUsageBaselineInitialization") private var needsUsageBaselineInitialization: Bool = true

    // MARK: - View State
    @StateObject private var stepManager = StepManager()
    @State private var selectedApps = FamilyActivitySelection()
    @State private var showingSettings = false
    @State private var showingInfoAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    // MARK: - Computed Properties
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
        max(0, stepManager.liveSteps - baselineSteps)
    }

    private var allowanceSeconds: Int {
        timeEarned * 60
    }

    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            headerView
            progressSection
            statusSection
            cardsSection
            Spacer()
        }
        .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .alert(alertTitle, isPresented: $showingInfoAlert) {
            Button("Got it", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        .onAppear(perform: handleOnAppear)
        .onChange(of: stepManager.liveSteps) { _, _ in
            checkUnlockEligibility()
        }
        .onChange(of: lockStatus) { _, isLocked in
            handleLockStatusChange(isLocked: isLocked)
        }
        .onChange(of: selectedAppsUsageToday) { _, _ in
            handleUsageChange()
        }
        .onChange(of: timeEarned) { _, _ in
            handleTimeEarnedChange()
        }
        .onChange(of: showingSettings) { _, isShowing in
            if !isShowing {
                refreshDashboard()
            }
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                refreshDashboard()
            }
        }
    }

    // MARK: - Subviews

    private var headerView: some View {
        HStack(alignment: .center) {
            Text("Dashboard")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer()

            Button {
                showingSettings = true
            } label: {
                Image(systemName: "gearshape.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .foregroundStyle(Color(uiColor: .systemGray2))
                    .frame(width: 44, height: 44)
            }
        }
        .padding(.top, 24)
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
    }

    private var progressSection: some View {
        HeroProgressRing(
            isLocked: lockStatus,
            timeEarned: timeEarned,
            stepsWalked: currentSteps,
            stepTarget: Int(stepGoals)
        )
        .padding(.bottom, 28)
    }

    private var statusSection: some View {
        StatusIndicatorView(
            isLocked: lockStatus,
            stepTarget: Int(stepGoals),
            timeEarned: timeEarned
        )
        .padding(.bottom, 20)
    }

    private var cardsSection: some View {
        VStack(spacing: 16) {
            // Restricted Apps Card
            if totalSelectionsCount > 0 {
                restrictedAppsCard
            }
            
            // Steps Today Card
            StatCardView(
                icon: "figure.walk.motion",
                title: "Steps Today",
                value: "\(stepManager.liveSteps)",
                tintColor: .orange
            ) {
                alertTitle = "Steps Today"
                alertMessage = "Your total physical steps recorded today. Resets everyday at midnight."
                showingInfoAlert = true
            }
        }
        .padding(.horizontal, 24)
    }

    private var restrictedAppsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "app.shadow")
                    .foregroundStyle(.indigo)
                Text("Restricted Apps")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Button {
                    alertTitle = "Restricted Apps"
                    alertMessage = "These are the apps and categories that will automatically lock when your timer reaches zero."
                    showingInfoAlert = true
                } label: {
                    Image(systemName: "info.circle")
                        .font(.system(size: 20))
                        .foregroundStyle(Color(uiColor: .tertiaryLabel))
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(Array(selectedCategoryTokens.enumerated()), id: \.element) { _, token in
                        Label(token)
                            .labelStyle(.iconOnly)
                            .font(.largeTitle)
                    }
                    
                    ForEach(Array(selectedApplicationTokens.enumerated()), id: \.element) { _, token in
                        Label(token)
                            .labelStyle(.iconOnly)
                            .font(.largeTitle)
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

    // MARK: - Logic & Handlers

    private func handleOnAppear() {
        selectedApps = ScreenTimeManager.shared.loadSelection() ?? FamilyActivitySelection()
        stepManager.startTracking()
        recalculateAllowance()

        if lockStatus {
            refreshBaselineStepsForCurrentLock()
        } else {
            DeviceActivityManager.shared.startMonitoring(timeLimitMinutes: timeEarned)
        }
    }

    private func refreshDashboard() {
        selectedApps = ScreenTimeManager.shared.loadSelection() ?? FamilyActivitySelection()
        recalculateAllowance()
        if lockStatus {
            refreshBaselineStepsForCurrentLock()
        }
    }

    private func handleLockStatusChange(isLocked: Bool) {
        if isLocked {
            secondsRemaining = 0
            refreshBaselineStepsForCurrentLock()
        } else {
            baselineSteps = 0
            lockActivatedAt = 0
        }
    }

    private func handleUsageChange() {
        if needsUsageBaselineInitialization && !lockStatus {
            usageBaselineAtUnlock = Double(selectedAppsUsageToday)
            needsUsageBaselineInitialization = false
        }
        recalculateAllowance()
    }

    private func handleTimeEarnedChange() {
        recalculateAllowance()
        if !lockStatus {
            usageBaselineAtUnlock = Double(selectedAppsUsageToday)
            DeviceActivityManager.shared.startMonitoring(timeLimitMinutes: timeEarned)
        }
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
            checkUnlockEligibility()
            return
        }

        let lockDate = Date(timeIntervalSince1970: lockActivatedAt)
        Task {
            baselineSteps = await stepManager.stepsToday(upTo: lockDate)
            checkUnlockEligibility()
        }
    }

    private func checkUnlockEligibility() {
        guard lockStatus else { return }
        
        let targetGoal = Int(stepGoals)
        guard targetGoal > 0, currentSteps >= targetGoal else { return }

        // Unlock apps
        lockStatus = false
        usageBaselineAtUnlock = Double(selectedAppsUsageToday)
        needsUsageBaselineInitialization = false
        secondsRemaining = allowanceSeconds

        ScreenTimeManager.shared.unlockApps()
        DeviceActivityManager.shared.startMonitoring(timeLimitMinutes: timeEarned)

        // Deliver celebration notification (will now display even when app is open!)
        NotificationManager.shared.scheduleNotification(
            title: "Step Goals Reached! 🎯",
            body: "Great job! Your apps are unlocked for another \(timeEarned) minutes!"
        )
    }
}

#Preview {
    DashboardView()
}
