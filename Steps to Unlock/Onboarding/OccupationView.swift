// MARK: OPTIONAL FEATURE

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


#Preview {
    OccupationView()
}
