import SwiftUI

protocol ReservationFlowStateProtocol: ObservableObject {
    var activeLink: ReservationLink? { get set }
}

enum ReservationLink: Hashable {
    case mainScreenLink
}

struct ReservationFlowCoordinator<State: ReservationFlowStateProtocol, Content: View>: View {

    @ObservedObject var state: State
    let content: () -> Content
    
    private var activeLink: Binding<ReservationLink?> {
        Binding<ReservationLink?>(
            get: { state.activeLink },
            set: { state.activeLink = $0 }
        )
    }

    var body: some View {
        NavigationView {
            ZStack {
                content()
                navigationLinks
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    @ViewBuilder private var navigationLinks: some View {
        NavigationLink(
            tag: .mainScreenLink,
            selection: activeLink,
            destination: mainScreenDestination
        ) { EmptyView() }
    }
    
    private func mainScreenDestination() -> some View {
        let viewModel = MainViewModel()
        return MainScreen(viewModel: viewModel)
    }
}
