import SwiftUI

struct MainPopulatFoodAndDrinksSectionView: View {
    @EnvironmentObject var viewModel: MainViewModel

    var body: some View {
        Section {
            LazyVGrid(columns: [GridItem(), GridItem()]) {
                ForEach(viewModel.menuItems) { item in
                    if item.isPopulatItem {
                        VStack(alignment: .leading, spacing: Constants.Spacing.smallest) {
                            Image(item.itemImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: Constants.Dimensions.imageWidth, height: Constants.Dimensions.imageHeight)
                                .overlay {
                                    RoundedRectangle(cornerRadius: Constants.Dimensions.imageCornerRadius)
                                        .stroke(Color.layerOne, lineWidth: Constants.Dimensions.imageStrokeLineWidth)
                                }
                            VStack(alignment: .leading, spacing: Constants.Spacing.zero) {
                                Text(item.itemName)
                                    .foregroundStyle(.layerOne)
                                    .font(.inter(.medium, size: Constants.FontSize.average))
                                    .fixedSize()
                                Text("$" + String(item.itemPrice))
                                    .foregroundStyle(.accent)
                                    .font(.inter(.medium, size: Constants.FontSize.smallest))
                                    .fixedSize()
                            }
                            .padding(.bottom, Constants.Padding.bottom)
                        }
                    }
                }
            }
        } header: {
            HStack {
                Text(viewModel.mainPopulatFoodAndDrinksSectionHeader)
                    .foregroundStyle(.white)
                    .font(.inter(.semibold, size: Constants.FontSize.average))
                    .fixedSize()
                Spacer()
            }
            .padding(.top, Constants.Padding.top)
        }
        .padding(.horizontal, Constants.Padding.horizontal)
    }
    
    private struct Constants {
        struct Spacing {
            static let zero: CGFloat = 0
            static let smallest: CGFloat = 8
        }
        
        struct Dimensions {
            static let imageWidth: CGFloat = 172
            static let imageHeight: CGFloat = 163.5
            static let imageCornerRadius: CGFloat = 8
            static let imageStrokeLineWidth: CGFloat = 0.5
        }
        
        struct Padding {
            static let bottom: CGFloat = 8
            static let top: CGFloat = 16
            static let horizontal: CGFloat = 16
        }
        
        struct FontSize {
            static let smallest: CGFloat = 14
            static let average: CGFloat = 16
        }
    }
}

#Preview {
    MainScreen(viewModel: MainViewModel())
        .environmentObject(SharedData())
}

#Preview {
    MainPopulatFoodAndDrinksSectionView()
        .padding()
        .background(.backgroundOne)
        .environmentObject(MainViewModel())
}
