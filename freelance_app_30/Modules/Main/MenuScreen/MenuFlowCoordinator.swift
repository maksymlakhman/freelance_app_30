import SwiftUI

protocol MenuFlowStateProtocol: ObservableObject {
    var activeLink: MenuLink? { get set }
}

enum MenuLink: Hashable{
}

struct MenuFlowCoordinator<State: MenuFlowStateProtocol, Content: View>: View {

    @ObservedObject var state: State
    let content: () -> Content

    var body: some View {
        NavigationView {
            ZStack {
                content()
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}
