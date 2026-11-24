import SwiftUI
import FoundationModels


struct ContentView: View {
    
    private let systemLanguageModel = SystemLanguageModel.default

    
    var body: some View {
       
        switch systemLanguageModel.availability {
        case .available:
            HomeScreen()
            
        case .unavailable(.appleIntelligenceNotEnabled):
            Text("Travel app is not available because Apple Intelligence has not been turned on.")
        case .unavailable(.modelNotReady):
            Text("Travel app is not ready yet.")
        case .unavailable(.deviceNotEligible):
            Text("Your device is not eligible.")
        default:
            Text("")
        }
    }
}

#Preview {
    ContentView()
}
