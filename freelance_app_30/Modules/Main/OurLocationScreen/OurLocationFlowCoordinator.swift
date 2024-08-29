import SwiftUI

protocol OurLocationFlowStateProtocol: ObservableObject {
    var activeLink: OurLocationLink? { get set }
}

enum OurLocationLink: Hashable{
}

struct OurLocationFlowCoordinator<State: OurLocationFlowStateProtocol, Content: View>: View {

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

