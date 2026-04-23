import SwiftUI

struct SectionHeader: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.footnote.weight(.bold))
                Text(title)
                    .font(.footnote.weight(.bold)) // Native 13pt Bold
            }
            .foregroundStyle(.secondary)
            
            Text(subtitle)
                .font(.footnote) // Native 13pt Regular
                .foregroundStyle(.secondary)
                .padding(.bottom, 8)
        }
    }
}

struct OccupationCard: View {
    let title: String
    let iconName: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(.indigo)
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: iconName)
                        .font(.system(size: 22))
                        .foregroundStyle(.white)
                }
                
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(.indigo)
                }
            }
            .padding(12)
            
            // Native Background
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            
            // Selected State Border
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(isSelected ? Color.indigo : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain) // Prevents the whole card from flashing grey on tap
    }
}

struct LiquidGlassButtonStyle: ButtonStyle {
    let isActive: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(isActive ? .white : .secondary)
            .background(
                ZStack {
                    // Base color
                    isActive ? Color.indigo : Color.gray.opacity(0.3)
                    
                    // The "Glass" material effect
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .opacity(isActive ? 0.0 : 0.5)
                    
                    // Tap effect
                    if configuration.isPressed {
                        Color.black.opacity(0.15)
                    }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            // Adds a subtle scale bounce when tapped
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct DayCircleView: View {
    let day: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(day)
                .font(.footnote.weight(.bold)) // Native 13pt Bold
                .foregroundStyle(isSelected ? .white : .secondary)
                .frame(width: 36, height: 36)
                .background(isSelected ? Color.indigo : Color.gray.opacity(0.15))
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
}
