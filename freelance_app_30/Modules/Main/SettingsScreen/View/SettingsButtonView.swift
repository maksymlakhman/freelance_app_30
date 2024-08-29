import SwiftUI

struct SettingsButtonView: View {
    @EnvironmentObject var viewModel: SettingsViewModel
    var title: String
    var description: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: SettingsButtonViewConstants.Spacing.smallest) {
                VStack(alignment: .leading, spacing: SettingsButtonViewConstants.Spacing.none) {
                    Text(title)
                        .font(.inter(.medium, size: SettingsButtonViewConstants.FontSize.large))
                        .foregroundStyle(.accent)
                    Text(description)
                        .font(.inter(.regular, size: SettingsButtonViewConstants.FontSize.small))
                        .foregroundStyle(.layerOne)
                }
                .multilineTextAlignment(.leading)
                Spacer()
                Image(systemName: viewModel.chevronIconImage)
                    .resizable()
                    .frame(width: SettingsButtonViewConstants.Image.width, height: SettingsButtonViewConstants.Image.height)
                    .foregroundStyle(.accent)
            }
            .padding(SettingsButtonViewConstants.Padding.all)
            .background(Color.layerThree)
            .overlay {
                RoundedRectangle(cornerRadius: SettingsButtonViewConstants.cornerRadius)
                    .stroke(Color.backgroundTwo, lineWidth: SettingsButtonViewConstants.lineWidth)
            }
        }
    }
    
    private struct SettingsButtonViewConstants {
        static let cornerRadius: CGFloat = 8
        static let lineWidth: CGFloat = 1
        
        struct Padding {
            static let all: CGFloat = 16
        }
        
        struct Image {
            static let width: CGFloat = 24
            static let height: CGFloat = 24
        }
        
        struct FontSize {
            static let small: CGFloat = 12
            static let large: CGFloat = 16
        }
        
        struct Spacing {
            static let none: CGFloat = 0
            static let smallest: CGFloat = 8
        }
    }
}

#Preview {
    SettingsButtonView(title: "Privacy Policy", description: "Here you can read the application's privacy policy") {}
        .environmentObject(SettingsViewModel())
}
