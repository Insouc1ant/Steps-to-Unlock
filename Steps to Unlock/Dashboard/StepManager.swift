import SwiftUI
import Foundation
import CoreMotion
internal import Combine

class StepManager: ObservableObject {
    private let pedometer = CMPedometer()
    
    // @Published means whenever this number changes, the UI updates instantly
    @Published var liveSteps: Int = 0
    
    func startTracking() {
        // 1. Check if the device actually has a step counter
        guard CMPedometer.isStepCountingAvailable() else {
            print("Step counting is not available on this device.")
            return
        }
        
        // 2. We only want steps taken TODAY, so we find midnight of the current day
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        
        // 3. Start the live feed
        pedometer.startUpdates(from: startOfDay) { [weak self] pedometerData, error in
            guard let data = pedometerData, error == nil else {
                print("Error tracking steps: \(String(describing: error))")
                return
            }
            
            // 4. CoreMotion runs in the background. We MUST push UI updates to the Main thread
            DispatchQueue.main.async {
                self?.liveSteps = data.numberOfSteps.intValue
            }
        }
    }
    
    func stopTracking() {
        pedometer.stopUpdates()
    }
}
