import SwiftUI

struct OccupationView: View {
    // 1. The State Property
    @State private var selectedOccupation: Occupation? = nil
    
    // Enum to keep our data structured and clean
    enum Occupation: String, CaseIterable {
        case student = "Student"
        case worker = "Worker"
        case unemployed = "Unemployed"
        
        var iconName: String {
            switch self {
            case .student: return "graduationcap"
            case .worker: return "briefcase"
            case .unemployed: return "house"
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            // 2. Typography & Top Spacing
            Text("What best describes\nyour day?")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 42)
            
            Text("We use this to customize your walking step\ntargets and daily focus limits")
                .font(.body)
                .foregroundStyle(.secondary)
                .padding(.top, 8)
                .padding(.bottom, 40)
            
            // 3. The Occupation Cards
            VStack(spacing: 12) {
                ForEach(Occupation.allCases, id: \.self) { occupation in
                    OccupationCard(
                        title: occupation.rawValue,
                        iconName: occupation.iconName,
                        isSelected: selectedOccupation == occupation
                    ) {
                        // Smooth Animation
                        withAnimation(.snappy) {
                            selectedOccupation = occupation
                        }
                    }
                }
            }
            
            Spacer()
            
            // 4. The Liquid Glass Continue Button
            NavigationLink(destination: LockedAppsView()) {
                Text("Continue")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
            }
            .buttonStyle(LiquidGlassButtonStyle(isActive: selectedOccupation != nil))
            .disabled(selectedOccupation == nil)
            .padding(.bottom, 16)
            
        }
        .padding(.horizontal, 24)
        
        // Native Background
        .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
    }
}

// Reusable Components

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

#Preview {
    OccupationView()
}
