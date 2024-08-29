import SwiftUI

struct AllMenuBtnView: View {
    @EnvironmentObject var viewModel : MainViewModel
    var spacing: CGFloat
    var fontSize: CGFloat
    var body: some View {
        Button(action: viewModel.menuScreenAction) {
            VStack(spacing : spacing) {
                Image(viewModel.allMenuBtnViewImage)
                Text(viewModel.allMenuBtnViewText)
                    .foregroundStyle(.layerOne)
                    .font(.inter(.semibold, size: fontSize))
                    .fixedSize()
            }
        }
    }
}

#Preview {
    AllMenuBtnView(spacing: 12, fontSize: 16)
        .background(.backgroundTwo)
        .environmentObject(MainViewModel())
}
