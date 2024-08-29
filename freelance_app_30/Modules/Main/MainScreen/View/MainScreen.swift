import SwiftUI


fileprivate struct Constants {
    struct Animation {
        static let duration: CGFloat = 0.5
        static let delay: CGFloat = 2
    }
}

struct MainScreen<VM: MainViewModelProtocol & MainFlowStateProtocol>: View {
    @StateObject var viewModel: VM
    @EnvironmentObject var sharedData: SharedData

    init(viewModel: VM) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        MainFlowCoordinator(state: viewModel, content: content)
            .environmentObject(viewModel)
            .environmentObject(ToastViewModel())
            .configureNavigationBar()
    }

    @ViewBuilder private func content() -> some View {
        ZStack {
            MainView()
            VStack {
                NavigationLink(destination: HistoryScreen(viewModel: HistoryViewModel()), isActive: $viewModel.navigateToHistoryView) {
                    EmptyView()
                }
            }
            
            if sharedData.isToastShowing {
                withAnimation(.easeInOut(duration: Constants.Animation.duration)) {
                    ToastView(navigateToHistoryView: $viewModel.navigateToHistoryView)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.Animation.delay) {
                                withAnimation {
                                    sharedData.isToastShowing = false
                                }
                            }
                        }
                }
            }
        }
        .toolbar {
            leadingNavItems()
            trailingNavItems()
        }
    }
}

extension MainScreen {

    @ToolbarContentBuilder
    private func leadingNavItems() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            leadingNavView()
        }
    }
    
    @ViewBuilder
    private func leadingNavView() -> some View {
        let navConstants = NavigationBarConstants()
        HStack(spacing: navConstants.leadingSpacing) {
            Image(viewModel.leftNavBarIcon)
            VStack(alignment: .leading, spacing: navConstants.leadingDefaultSpacing) {
                Group {
                    Text(viewModel.leftNavBarTextOne)
                        .font(.inter(.regular, size: navConstants.leadingSmallestFont))
                        .fixedSize()
                    Text(viewModel.leftNavBarTextTwo)
                        .font(.inter(.medium, size: navConstants.leadingLargestFont))
                        .fixedSize()
                }
                .foregroundStyle(.layerOne)
                
            }
        }
        .navigationBarPaddingBottomPercentage()
    }
    
    @ToolbarContentBuilder
    private func trailingNavItems() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: viewModel.settingsScreenAction) {
                trailingNavView()
            }
        }
    }
    
    @ViewBuilder
    private func trailingNavView() -> some View {
        let navConstants = NavigationBarConstants()
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: navConstants.trailingCornerRadius)
                .fill(Color.layerThree)
            Image(systemName: viewModel.rightNavBarIcon)
                .frame(width: navConstants.trailingImageWidth, height: navConstants.trailingImageHeight)
        }
        .frame(width: navConstants.trailingStackWidth, height: navConstants.trailingStackHeight)
        .navigationBarPaddingBottomPercentage()
    }
    
    private struct NavigationBarConstants {
        let leadingSpacing: CGFloat = 6
        let leadingDefaultSpacing: CGFloat = 0
        let leadingSmallestFont: CGFloat = 12
        let leadingLargestFont: CGFloat = 14
        
        let trailingCornerRadius: CGFloat = 8
        let trailingImageWidth: CGFloat = 24
        let trailingImageHeight: CGFloat = 24
        let trailingStackWidth: CGFloat = 40
        let trailingStackHeight: CGFloat = 40
    }
}

#Preview {
    MainScreen(viewModel: MainViewModel())
        .environmentObject(SharedData())
}
