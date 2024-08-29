import SwiftUI

struct MainCardsView: View {
    @EnvironmentObject var viewModel: MainViewModel

    var body: some View {
        MainCardsScrollTabView(
            selectedTab: $viewModel.mainCardsViewSelected,
            spacing: Constants.Spacing.largest,
            views: viewModel.cards.map { card in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: Constants.Dimensions.cornerRadius)
                        .fill(Color.backgroundOne)
                        .overlay {
                            Image(card.imageName)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: Constants.Dimensions.cornerRadius))
                    VStack(alignment: .leading, spacing: Constants.Spacing.smallest) {
                        Text(card.titleText)
                            .foregroundStyle(.accent)
                            .font(.inter(.medium, size: Constants.FontSize.largest))
                            .fixedSize()
                        Text(card.subText)
                            .foregroundStyle(.layerOne)
                            .font(.inter(.regular, size: Constants.FontSize.smallest))
                            .fixedSize()
                    }
                    .padding(.leading, Constants.Spacing.leadingPadding)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: Constants.Dimensions.cornerRadius)
                        .stroke(Color.layerFour, lineWidth: Constants.Dimensions.rRLineWidth)
                }
                .frame(height: UIScreen.main.bounds.width * Constants.Dimensions.adaptabilityMultiplier)
                .animation(.spring(), value: viewModel.mainCardsViewSelected)
            }
        )
    }
    
    private struct Constants {
        struct Spacing {
            static let smallest: CGFloat = 6
            static let largest: CGFloat = 14
            static let leadingPadding: CGFloat = 20
        }
        
        struct Dimensions {
            static let cornerRadius: CGFloat = 16
            static let rRLineWidth: CGFloat = 1.5
            static let adaptabilityMultiplier: CGFloat = 0.27
        }
        
        struct FontSize {
            static let smallest: CGFloat = 12
            static let largest: CGFloat = 16
        }
    }
}

#Preview {
    MainCardsView()
        .background(.backgroundTwo)
        .environmentObject(MainViewModel())
}
