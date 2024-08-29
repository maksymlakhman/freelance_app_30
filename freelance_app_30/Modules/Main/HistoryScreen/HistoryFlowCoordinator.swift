import SwiftUI

protocol HistoryFlowStateProtocol: ObservableObject {
    var activeLink: HistoryLink? { get set }
    
}

enum HistoryLink: Hashable { 
    case reservationScreenLink
    
    var navigationLink: HistoryLink {
        switch self {
        case .reservationScreenLink:
            return .reservationScreenLink
        }
    }
}

struct HistoryFlowCoordinator<State: HistoryFlowStateProtocol, Content: View>: View {

    @ObservedObject var state: State
    let content: () -> Content
    
    private var activeLink: Binding<HistoryLink?> {
        $state.activeLink.map(get: { $0?.navigationLink }, set: { $0 })
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
        NavigationLink(tag: .reservationScreenLink, selection: activeLink, destination: reservationScreenDestination) { EmptyView() }
    }
    
    private func reservationScreenDestination() -> some View {
        let viewModel = ReservationViewModel()
        let view = ReservationScreen(viewModel: viewModel)
        return view
    }
}
