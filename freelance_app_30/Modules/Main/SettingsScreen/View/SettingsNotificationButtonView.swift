import SwiftUI

struct SettingsNotificationButtonView: View {
    var title: String
    var action: () -> Void
    @EnvironmentObject var viewModel: SettingsViewModel

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: SettingsNotificationButtonViewConstants.Spacing.defaultSpacing) {
                    Text(title)
                        .font(.inter(.medium, size: SettingsNotificationButtonViewConstants.FontSize.large))
                        .foregroundStyle(.accent)
                        .fixedSize()
                }
                Spacer()
                Image(systemName: viewModel.chevronIconImage)
                    .resizable()
                    .frame(width: SettingsNotificationButtonViewConstants.Image.width, height: SettingsNotificationButtonViewConstants.Image.height)
                    .foregroundStyle(.accent)
            }
            .padding(SettingsNotificationButtonViewConstants.Padding.all)
            .background(Color.layerThree)
            .overlay {
                RoundedRectangle(cornerRadius: SettingsNotificationButtonViewConstants.cornerRadius)
                    .stroke(Color.backgroundTwo, lineWidth: SettingsNotificationButtonViewConstants.lineWidth)
            }
        }
    }
    
    private struct SettingsNotificationButtonViewConstants {
        struct Padding {
            static let all: CGFloat = 16
        }
        
        struct Image {
            static let width: CGFloat = 24
            static let height: CGFloat = 24
        }
        
        struct FontSize {
            static let large: CGFloat = 16
        }
        
        struct Spacing {
            static let defaultSpacing: CGFloat = 8
        }
        
        static let cornerRadius: CGFloat = 8
        static let lineWidth: CGFloat = 1
    }
}

#Preview {
    SettingsNotificationButtonView(title: "Notification") {}
        .environmentObject(SettingsViewModel())
}
