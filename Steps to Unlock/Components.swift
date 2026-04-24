import SwiftUI

struct SectionHeader: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                Text(title)
                    .font(.footnote.weight(.bold)) // Native 13pt Bold
            }
            .foregroundStyle(.secondary)
            
            Text(subtitle)
                .font(.footnote) // Native 13pt Regular
                .foregroundStyle(.secondary)
                .padding(.bottom, 12)
        }
    }
}

struct InlineSearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
                .font(.system(size: 18, weight: .medium))
            
            TextField("Search", text: $text)
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(.primary)
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

struct AppSelectionRow: View {
    let appName: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 44, height: 44)
            
            // Text
            Text(appName)
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(.primary)
            
            Spacer()
            
            // Toggle
            Toggle("", isOn: Binding(
                get: { isSelected },
                set: { _ in action() }
            ))
            .labelsHidden()
        }
        // Strict internal padding to prevent toggle cropping
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.clear)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                action()
            }
        }
    }
}

struct HeroProgressRing: View {
    let isLocked: Bool
    let minutesRemaining: String
    let secRemaining: Int
    let totalSeconds: Int
    let stepsWalked: Int
    let stepTarget: Int
    
    var ringColor: Color {
        !isLocked ? .indigo : .orange
    }
    
    var progressAmount: Double {
        if !isLocked {
            return Double(secRemaining) / Double(totalSeconds)
        } else {
            return min(1.0, Double(stepsWalked) / Double(stepTarget))
        }
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
                if !isLocked {
                    Text(minutesRemaining)
                        .font(.system(size: 48, weight: .semibold, design: .rounded))
                    
                    Text("time remaining")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } else {
                    Text("\(stepsWalked)")
                        .font(.system(size: 48, weight: .semibold, design: .rounded))
                    
                    Text("of \(stepTarget) steps")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(width: 280, height: 280)
    }
}

struct StatusIndicatorView: View {
    let isLocked: Bool
    let stepTarget: Int
    let timeEarned: Int
    
    var body: some View {
        VStack(spacing: 6) {
            HStack(spacing: 8) {
                Image(systemName: isLocked ? "lock.fill" : "lock.open.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 18)
                
                Text(isLocked ? "Apps Locked" : "Apps Available")
                    .font(.system(size: 15, weight: .semibold))
            }
            .foregroundStyle(isLocked ? Color(uiColor: .systemRed) : Color(uiColor: .systemGreen))

            Text(isLocked
                 ? "Walk \(stepTarget) steps to unlock your restricted apps\nfor \(timeEarned) minutes."
                 : "Your restricted apps will automatically lock when\nthis timer reaches zero.")
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(Color(uiColor: .systemGray))
                .multilineTextAlignment(.center)
                .frame(height: 36, alignment: .top)
                .padding(.horizontal, 32)
        }
    }
}

struct StatCardView: View {
    let icon: String
    let title: String
    let value: String
    let tintColor: Color
    let infoAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(tintColor)
                
                Text(title)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Button(action: infoAction) {
                    Image(systemName: "info.circle")
                        .font(.system(size: 20))
                        .foregroundStyle(Color(uiColor: .tertiaryLabel))
                }
            }
            
            Text(value)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#Preview {
    DashboardView()
}
