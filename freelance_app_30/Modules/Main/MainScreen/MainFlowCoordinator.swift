import SwiftUI

protocol MainFlowStateProtocol: ObservableObject {
    var activeLink: MainLink? { get set }
    var menuItems: [FoodAndDrinksModel] { get set }
}

enum MainLink: Hashable {
    case settingsScreenLink
    case menuScreenLink
    case menuScreenLinkParametrized
    case ourLocationScreenLink
    case historyScreenLink
    case reservationScreenLink
}

struct MainFlowCoordinator<State: MainFlowStateProtocol, Content: View>: View {
    @ObservedObject var state: State
    let content: () -> Content

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
        NavigationLink(tag: .settingsScreenLink, selection: $state.activeLink, destination: settingsScreenDestination) { EmptyView() }
        NavigationLink(tag: .menuScreenLink, selection: $state.activeLink, destination: menuScreenDestination) { EmptyView() }
        NavigationLink(tag: .menuScreenLinkParametrized, selection: $state.activeLink, destination: menuScreenDestination) { EmptyView() }
        NavigationLink(tag: .ourLocationScreenLink, selection: $state.activeLink, destination: ourLocationScreenDestination) { EmptyView() }
        NavigationLink(tag: .historyScreenLink, selection: $state.activeLink, destination: historyScreenDestination) { EmptyView() }
        NavigationLink(tag: .reservationScreenLink, selection: $state.activeLink, destination: reservationScreenDestination) { EmptyView() }
    }
    
    private func settingsScreenDestination() -> some View {
        let viewModel = SettingsViewModel()
        let view = SettingsScreen(viewModel: viewModel)
        return view
    }
    
    private func menuScreenDestination() -> some View {
        let items: [FoodAndDrinksModel] = state.menuItems
        let viewModel = MenuViewModel(menuItems: items)
        let view = MenuScreen(viewModel: viewModel)
        return view
    }
    
    private func ourLocationScreenDestination() -> some View {
        let viewModel = OurLocationViewModel()
        let view = OurLocationScreen(viewModel: viewModel)
        return view
    }
    
    private func historyScreenDestination() -> some View {
        let viewModel = HistoryViewModel()
        let view = HistoryScreen(viewModel: viewModel)
        return view
    }
    
    private func reservationScreenDestination() -> some View {
        let viewModel = ReservationViewModel()
        let view = ReservationScreen(viewModel: viewModel)
        return view
    }
}

