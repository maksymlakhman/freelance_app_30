import SwiftUI

struct MainView: View {
    @EnvironmentObject var viewModel: MainViewModel
    
    var body: some View {
        VStack(spacing: Constants.spacing) {
            ScrollView(.vertical, showsIndicators: false) {
                MainCardsView()
                MainMenuAndLocationView()
                MainOnlineReservationView()
                MainPopulatFoodAndDrinksSectionView()
                appVersionView()
            }
        }
        .background(Color.backgroundOne)
    }
    
    @ViewBuilder
    private func appVersionView() -> some View {
        Text(viewModel.mainViewAppVersionText)
            .font(.inter(.medium, size: Constants.FontSize.fontSize))
            .foregroundColor(.layerFive)
            .padding(Constants.Padding.appVersionViewPadding)
            .fixedSize()
    }
    
    private struct Constants {
        static let spacing: CGFloat = 12
        struct FontSize {
            static let fontSize: CGFloat = 14
        }
        struct Padding {
            static let appVersionViewPadding: CGFloat = 6
        }
    }
}

#Preview {
    MainView()
        .environmentObject(MainViewModel())
}
