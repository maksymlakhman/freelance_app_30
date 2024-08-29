import SwiftUI

struct OnboardingScreen<VM: OnboardingViewModelProtocol & OnboardingFlowStateProtocol>: View {
    @StateObject var viewModel: VM
    init(viewModel: VM) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        OnboardingFlowCoordinator(state: viewModel, content: content)
            .environmentObject(viewModel)
    }

    @ViewBuilder private func content() -> some View {
            OnboardingView()
                .navigationBarHidden(true)
    }
}

#Preview {
    OnboardingScreen(viewModel: OnboardingViewModel())
}
