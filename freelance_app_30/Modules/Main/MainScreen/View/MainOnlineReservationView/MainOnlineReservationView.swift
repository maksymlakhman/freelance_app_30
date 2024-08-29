import SwiftUI

struct MainOnlineReservationView: View {
    @EnvironmentObject var viewModel: MainViewModel

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: Constants.Dimensions.largestCornerRadius)
                .fill(Color.accent)
                .overlay {
                    VStack(alignment: .leading, spacing: Constants.Spacing.average) {
                        HStack {
                            VStack(alignment: .leading, spacing: Constants.Spacing.smallest) {
                                Text(viewModel.mainOnlineReservationViewTextOne)
                                    .font(.inter(.semibold, size: Constants.FontSize.largest))
                                    .fixedSize()
                                Text(viewModel.mainOnlineReservationViewTextTwo)
                                    .font(.inter(.regular, size: Constants.FontSize.smallest))
                                    .fixedSize()
                            }
                            .foregroundStyle(Color.layerTwo)
                            Spacer()
                            Image(viewModel.mainOnlineReservationViewImage)
                                .resizable()
                                .frame(width: Constants.Dimensions.imageWidth, height: Constants.Dimensions.imageHeight)
                        }
                        HStack(spacing: Constants.Spacing.largest) {
                            Button(action: viewModel.reservationScreenAction) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: Constants.Dimensions.smallestCornerRadius)
                                        .fill(Color.layerOne)
                                    Text(viewModel.mainOnlineReservationViewBtnOneText)
                                        .font(.inter(.medium, size: Constants.FontSize.average))
                                        .foregroundStyle(Color.layerTwo)
                                        .fixedSize()
                                }
                                .frame(height: Constants.Dimensions.btnHeight)
                            }
                            Button(action: viewModel.historyScreenAction) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: Constants.Dimensions.smallestCornerRadius)
                                        .stroke(Color.layerTwo, lineWidth: Constants.Dimensions.btnStrokeLineWidth)
                                    Text(viewModel.mainOnlineReservationViewBtnTwoText)
                                        .font(.inter(.medium, size: Constants.FontSize.average))
                                        .foregroundStyle(Color.layerTwo)
                                        .fixedSize()
                                }
                                .frame(height: Constants.Dimensions.btnHeight)
                            }
                        }
                    }
                    .padding(.horizontal, Constants.Padding.horizontal)
                }
        }
        .frame(height: Constants.Dimensions.height)
        .padding(.horizontal, Constants.Padding.horizontal)
    }

    private struct Constants {
        struct Dimensions {
            static let height: CGFloat = 144
            static let imageWidth: CGFloat = 90
            static let imageHeight: CGFloat = 60
            static let smallestCornerRadius: CGFloat = 8
            static let largestCornerRadius: CGFloat = 16
            static let btnHeight: CGFloat = 44
            static let btnStrokeLineWidth: CGFloat = 2
        }
        
        struct Padding {
            static let horizontal: CGFloat = 16
        }
        
        struct FontSize {
            static let smallest: CGFloat = 12
            static let average: CGFloat = 14
            static let largest: CGFloat = 16
        }
        
        struct Spacing {
            static let zero: CGFloat = 0
            static let smallest: CGFloat = 4
            static let average: CGFloat = 6
            static let largest: CGFloat = 8
        }
    }
}

#Preview {
    MainOnlineReservationView()
        .background(.backgroundOne)
        .environmentObject(MainViewModel())
}
