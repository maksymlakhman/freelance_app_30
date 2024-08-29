import SwiftUI

struct ToastView: View {
    @Binding var navigateToHistoryView: Bool
    @EnvironmentObject var viewModel: ToastViewModel
    @EnvironmentObject var sharedData: SharedData
    
    var body: some View {
        VStack(spacing: Constants.Spacing.zero) {
            Spacer()
            HStack(spacing: Constants.Spacing.zero) {
                toastMessage
                Spacer()
                historyButtonView
            }
            .padding(.horizontal, Constants.Spacing.horizontalPadding)
            .padding(.vertical, Constants.Spacing.verticalPadding)
            .background(
                Capsule()
                    .foregroundColor(Color.layerOne)
                    .cornerRadius(Constants.Dimensions.cornerRadius, corners: .allCorners)
            )
            .transition(.opacity)
            .frame(maxWidth: Constants.Dimensions.maxWidth, maxHeight: Constants.Dimensions.maxHeight)
            .padding(.bottom, Constants.Spacing.bottomPadding)
        }
    }
    
    @ViewBuilder
    private var toastMessage: some View {
        Text(viewModel.message)
            .foregroundStyle(.black)
            .font(.inter(.medium, size: Constants.FontSizes.body))
            .fixedSize()
    }
    
    @ViewBuilder
    private var historyButtonView: some View {
        Button {
            self.navigateToHistoryView = true
            self.sharedData.isToastShowing = false
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: Constants.Dimensions.buttonCornerRadius)
                    .fill(Color.accentColor)
                    .frame(width: Constants.Dimensions.buttonWidth, height: Constants.Dimensions.buttonHeight)
                Text(viewModel.btnText)
                    .foregroundStyle(.black)
                    .font(.inter(.medium, size: Constants.FontSizes.button))
                    .fixedSize()
            }
            .transition(.slide)
        }
    }
    
    private struct Constants {
        struct Spacing {
            static let zero: CGFloat = 0
            static let horizontalPadding: CGFloat = 16
            static let verticalPadding: CGFloat = 8
            static let bottomPadding: CGFloat = 8
        }
        
        struct Dimensions {
            static let maxWidth: CGFloat = 361
            static let maxHeight: CGFloat = 57
            static let cornerRadius: CGFloat = 16
            static let buttonCornerRadius: CGFloat = 8
            static let buttonWidth: CGFloat = 117
            static let buttonHeight: CGFloat = 41
        }
        
        struct FontSizes {
            static let body: CGFloat = 16
            static let button: CGFloat = 14
        }
    }
}

#Preview {
    ToastView(navigateToHistoryView: .constant(true))
        .environmentObject(SharedData())
        .environmentObject(ToastViewModel())
}
