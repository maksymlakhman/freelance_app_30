import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var viewModel: HistoryViewModel
    
    var body: some View {
        Group {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center, spacing: Constants.Spacing.defaultZeroSpacing) {
                    ForEach(viewModel.reservations.reversed()) { item in
                        historyRow(item: item)
                    }
                }
                .padding(.top, Constants.paddingTop)
            }
            .navigationBarBackButtonHidden(true)
            .background(.backgroundOne)
        }
    }
    
    @ViewBuilder
    private func historyRow(item: HistoryRowItemModel) -> some View {
        HistoryRowItem(historyItem: item)
    }
    
    private struct Constants {
        static let paddingTop: CGFloat = 12
        struct Spacing {
            static let defaultZeroSpacing: CGFloat = 0
        }
    }
}

#Preview {
    HistoryView()
        .environmentObject(HistoryViewModel())
}
