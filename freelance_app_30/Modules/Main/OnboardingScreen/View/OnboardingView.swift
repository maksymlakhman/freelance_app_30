import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var viewModel: OnboardingViewModel
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    
    var body: some View {
        ZStack(alignment: .center) {
            Image(viewModel.backgroundImage)
                .resizable()
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: Constants.Spacing.zero) {
                Spacer()
                VStack(alignment: .leading, spacing: Constants.Spacing.small) {
                    OnboardingTextBlockTitle()
                    OnboardingTextBlockSubTitle()
                }
                Button(action: viewModel.mainScreenAction) {
                    OnboardingGetStartedLabelButtonView()
                }
            }
            .padding(.horizontal, Constants.Spacing.horizontalPadding)
            .frame(height: UIScreen.main.bounds.height)
        }
    }
    
    @ViewBuilder
    func OnboardingTextBlockTitle() -> some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.zero) {
            Group {
                Text(viewModel.onboardingTextBlockTitleTextOne)
                    .foregroundStyle(.accent)
                    .font(.inter(.medium, size: Constants.FontSizes.large))
                    .fixedSize()
                Text(viewModel.onboardingTextBlockTitleTextTwo)
                    .font(.inter(.semibold, size: Constants.FontSizes.large))
                    .fixedSize()
                Text(viewModel.onboardingTextBlockTitleTextThree)
                    .font(.inter(.lightItalic, size: Constants.FontSizes.large))
                    .fixedSize()
            }
            .foregroundStyle(.layerOne)
            
        }
    }
    
    @ViewBuilder
    func OnboardingTextBlockSubTitle() -> some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.zero) {
            Group {
                Text(viewModel.onboardingTextBlockSubTitle)
                    .foregroundStyle(.layerOne)
                    .font(.inter(.regular, size: Constants.FontSizes.medium))
            }
        }
    }
    
    @ViewBuilder
    func OnboardingGetStartedLabelButtonView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: Constants.Dimensions.buttonCornerRadius)
                .fill(.accent)
            Text(viewModel.onboardingGetStartedLabelButtonText)
                .foregroundStyle(.layerTwo)
                .font(.inter(.semibold, size: Constants.FontSizes.medium))
                .fixedSize()
        }
        .frame(height: Constants.Dimensions.buttonHeight)
        .padding(.vertical, Constants.Spacing.buttonPadding)
    }
    
    private struct Constants {
        struct Spacing {
            static let zero: CGFloat = 0
            static let small: CGFloat = 12
            static let buttonPadding: CGFloat = 52
            static let horizontalPadding: CGFloat = 16
        }
        
        struct Dimensions {
            static let buttonCornerRadius: CGFloat = 8
            static let buttonHeight: CGFloat = 52
        }
        
        struct FontSizes {
            static let large: CGFloat = 32
            static let medium: CGFloat = 16
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(OnboardingViewModel())
}
