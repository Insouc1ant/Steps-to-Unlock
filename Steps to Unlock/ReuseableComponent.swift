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
