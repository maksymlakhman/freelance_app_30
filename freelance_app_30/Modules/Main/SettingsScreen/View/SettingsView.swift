import SwiftUI
import StoreKit

struct SettingsView: View {
    @EnvironmentObject var viewModel: SettingsViewModel
    
    var body: some View {
        ZStack(alignment: .center) {
            Color.layerThree
            VStack(alignment: .center, spacing: SettingsViewConstants.Spacing.smallest) {
                notificationsView()
                privatePolicyView()
                termOfUseView()
                rateUsView()
                shareAppView()
                contactUsView
                Spacer()
            }
            .background(Color.layerThree)
            .padding(SettingsViewConstants.Padding.all)
        }
        .ignoresSafeArea(edges: .bottom)
        .background(Color.backgroundTwo)
    }
    
    @ViewBuilder
    private func notificationsView() -> some View {
        SettingsNotificationButtonView(title: viewModel.notificationTitleText) {
            UIApplication.shared.openAppSettings()
        }
    }
    
    @ViewBuilder
    private func privatePolicyView() -> some View {
        SettingsButtonView(title: viewModel.privacyPolicyTitleText, description: viewModel.privacyPolicyDescriptionText) {
            if let url = URL(string: SettingsViewConstants.URLs.privacyPolicy) {
                UIApplication.shared.open(url)
            }
        }
    }

    @ViewBuilder
    private func termOfUseView() -> some View {
        SettingsButtonView(title: viewModel.termOfUseTitleText, description: viewModel.termOfUseDescriptionText) {
            if let url = URL(string: SettingsViewConstants.URLs.termOfUse) {
                UIApplication.shared.open(url)
            }
        }
    }

    @ViewBuilder
    private func rateUsView() -> some View {
        SettingsButtonView(title: viewModel.rateUsTitleText, description: viewModel.rateUsDescriptionText) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: windowScene)
            }
        }
    }

    @ViewBuilder
    private func shareAppView() -> some View {
        SettingsButtonView(title: viewModel.shareAppTitleText, description: viewModel.shareAppDescriptionText) {
            let activityVC = UIActivityViewController(activityItems: [SettingsViewConstants.URLs.appLink], applicationActivities: nil)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
            }
        }
    }
    
    @ViewBuilder
    private var contactUsView: some View {
        VStack(alignment: .leading, spacing: SettingsViewConstants.Spacing.smallest) {
            Text(viewModel.contactUsTitleText)
                .font(.inter(.medium, size: SettingsViewConstants.FontSize.large))
                .foregroundStyle(.accent)
            Text(viewModel.contactUsTextMessage)
                .font(.inter(.regular, size: SettingsViewConstants.FontSize.small))
                .foregroundStyle(.layerFive)
            HStack {
                Image(viewModel.contactUsImage)
                    .resizable()
                    .frame(width: SettingsViewConstants.ContactUsView.imageWidth, height: SettingsViewConstants.ContactUsView.imageHeight)
                    .foregroundStyle(.accent)
                Text(viewModel.contactUsTextEmail)
                    .font(.inter(.regular, size: SettingsViewConstants.FontSize.small))
                    .foregroundStyle(.layerOne)
                Spacer()
            }
        }
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: SettingsViewConstants.ContactUsView.cornerRadius)
                .strokeBorder(Color.backgroundTwo, lineWidth: SettingsViewConstants.ContactUsView.lineWidth)
        }
        .padding(.vertical, SettingsViewConstants.ContactUsView.verticalPadding)
    }
    
    private struct SettingsViewConstants {
        struct Padding {
            static let all: CGFloat = 16
        }

        struct ContactUsView {
            static let cornerRadius: CGFloat = 8
            static let lineWidth: CGFloat = 1
            static let imageWidth: CGFloat = 24
            static let imageHeight: CGFloat = 24
            static let verticalPadding: CGFloat = 8
        }
        
        struct FontSize {
            static let small: CGFloat = 12
            static let large: CGFloat = 16
        }
        
        struct Spacing {
            static let defaultZero: CGFloat = 0
            static let smallest: CGFloat = 8
        }
        
        struct URLs {
            static let privacyPolicy = "https://www.google.com"
            static let termOfUse = "https://www.google.com"
            static let appLink = "Check out this app: https://www.google.com"
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(SettingsViewModel())
}
