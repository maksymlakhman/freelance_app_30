import SwiftUI

struct OurLocationBtnView: View {
    @EnvironmentObject var viewModel : MainViewModel
    var spacing: CGFloat
    var fontSize: CGFloat
    var body: some View {
        Button(action: viewModel.ourLocationScreenAction) {
            VStack(spacing : spacing) {
                Image(viewModel.ourLocationBtnViewImage)
                Text(viewModel.ourLocationBtnViewText)
                    .foregroundStyle(.layerOne)
                    .font(.inter(.semibold, size: fontSize))
                    .fixedSize()
            }
        }
    }
}

#Preview {
    OurLocationBtnView(spacing: 12, fontSize: 16)
        .background(.backgroundTwo)
        .environmentObject(MainViewModel())
}

