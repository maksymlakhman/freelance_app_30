import SwiftUI

protocol SettingsFlowStateProtocol: ObservableObject {
    var activeLink: SettingsLink? { get set }
}

enum SettingsLink: Hashable { }

struct SettingsFlowCoordinator<State: SettingsFlowStateProtocol, Content: View>: View {

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
