import SwiftUI

struct HistoryRowItem: View {
    let historyItem: HistoryRowItemModel
    @EnvironmentObject var viewModel: HistoryViewModel

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: HistoryRowItemConstants.DateFormatter.localeIdentifier)
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: HistoryRowItemConstants.DateFormatter.localeIdentifier)
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: HistoryRowItemConstants.Spacing.smallest) {
            HStack {
                VStack(alignment: .leading, spacing: HistoryRowItemConstants.Spacing.defaultZero) {
                    Text(historyItem.userName)
                        .foregroundStyle(.layerOne)
                        .font(.inter(.medium, size: HistoryRowItemConstants.FontSize.large))
                        .fixedSize()
                    HStack {
                        Text(dateFormatter.string(from: historyItem.reservationDate))
                            .fixedSize()
                        Divider()
                            .background(Color.accent)
                            .frame(width: HistoryRowItemConstants.Divider.width, height: HistoryRowItemConstants.Divider.height)
                        Text(timeFormatter.string(from: historyItem.reservationTime))
                            .fixedSize()
                    }
                    .foregroundStyle(.accent)
                    .font(.inter(.medium, size: HistoryRowItemConstants.FontSize.large))
                }
                Spacer()
                Button {
                    viewModel.shareReservation(historyItem)
                    viewModel.showShareReservationSheet = true
                } label: {
                    Image(systemName: viewModel.historyRowItemImage)
                        .frame(width: HistoryRowItemConstants.ImageDimensions.width, height: HistoryRowItemConstants.ImageDimensions.height)
                        .foregroundStyle(.accent)
                        .background(RoundedRectangle(cornerRadius: HistoryRowItemConstants.ImageDimensions.cornerRadius)
                            .fill(.backgroundOne)
                            .frame(width: HistoryRowItemConstants.StackDimensions.width, height: HistoryRowItemConstants.StackDimensions.height)
                        )
                }
            }
            Text("\(historyItem.numbersOfPersons) person(s)")
                .foregroundStyle(.layerFive)
                .font(.inter(.medium, size: HistoryRowItemConstants.FontSize.small))
                .fixedSize()
        }
        .padding(HistoryRowItemConstants.Padding.all)
        .background(.layerFour)
        .cornerRadius(8, corners: .allCorners)
        .padding(.horizontal, HistoryRowItemConstants.Padding.horizontal)
        .padding(.vertical, HistoryRowItemConstants.Padding.vertical)
    }
    
    private struct HistoryRowItemConstants {
        struct Padding {
            static let all: CGFloat = 16
            static let horizontal: CGFloat = 16
            static let vertical: CGFloat = 4
        }

        struct ImageDimensions {
            static let cornerRadius: CGFloat = 8
            static let width: CGFloat = 24
            static let height: CGFloat = 24
        }
        
        struct StackDimensions {
            static let width: CGFloat = 40
            static let height: CGFloat = 40
        }

        struct FontSize {
            static let small: CGFloat = 14
            static let large: CGFloat = 18
        }
        
        struct Spacing {
            static let defaultZero: CGFloat = 0
            static let smallest: CGFloat = 8
        }
        
        struct Divider {
            static let width: CGFloat = 4
            static let height: CGFloat = 19
        }
        
        struct DateFormatter {
            static let localeIdentifier = "en_US"
        }
    }
}

#Preview {
    HistoryRowItem(historyItem: HistoryRowItemModel(userName: "Max", reservationDate: Date.now, reservationTime: Date.now, numbersOfPersons: 5))
        .environmentObject(HistoryViewModel())
}
