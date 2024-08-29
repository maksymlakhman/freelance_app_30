import SwiftUI

struct EmptyHistoryView: View {
    @EnvironmentObject var viewModel: HistoryViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: Constants.Spacing.smallest) {
            emptyHistoryTitle
            Text(viewModel.emptyHistoryDescriptionText)
                .foregroundStyle(.layerOne)
                .font(.inter(.regular, size: Constants.FontSize.medium))
                .multilineTextAlignment(.center)
                .padding(.horizontal, Constants.paddingHorizontal)
                .fixedSize()
            reserveButton
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.backgroundOne)
    }
    
    @ViewBuilder
    private var emptyHistoryTitle: some View {
        Text(viewModel.emptyHistoryTitleText)
            .foregroundStyle(.accent)
            .font(.inter(.medium, size: Constants.FontSize.large))
            .fixedSize()
    }
    
    @ViewBuilder
    private var reserveButton: some View {
        Button(action: viewModel.reservationScreenAction) {
            ZStack {
                RoundedRectangle(cornerRadius: Constants.ReserveButton.cornerRadius)
                    .fill(.accent)
                Text(viewModel.emptyHistoryReserveButtonText)
                    .foregroundStyle(.layerTwo)
                    .fixedSize()
            }
            .frame(width: Constants.ReserveButton.width, height: Constants.ReserveButton.height)
        }
    }
    
    private struct Constants {
        static let paddingHorizontal: CGFloat = 8
        
        struct ReserveButton {
            static let width: CGFloat = 164
            static let height: CGFloat = 52
            static let cornerRadius: CGFloat = 8
        }
        
        struct FontSize {
            static let medium: CGFloat = 16
            static let large: CGFloat = 18
        }
        
        struct Spacing {
            static let smallest: CGFloat = 6
        }
    }
}

#Preview {
    EmptyHistoryView()
        .environmentObject(HistoryViewModel())
}
