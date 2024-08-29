import SwiftUI

class SharedData: ObservableObject {
    @Published var isToastShowing: Bool = false
    @Published var deviceID: String? = UserDefaults.standard.string(forKey: "deviceID")
}

#Preview {
    MainScreen(viewModel: MainViewModel())
        .environmentObject(SharedData())
}
