import SwiftUI

struct MainMenuAndLocationView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .fill(Color.layerFour)
            HStack(alignment: .center, spacing: Constants.Spacing.zero) {
                AllMenuBtnView(spacing: Constants.Button.spacing, fontSize: Constants.Button.fontSize)
                Divider()
                    .frame(width: Constants.Divider.width, height: Constants.Divider.height)
                    .background(Color.layerFive)
                OurLocationBtnView(spacing: Constants.Button.spacing, fontSize: Constants.Button.fontSize)
            }
            .padding(Constants.padding)
        }
        .padding(Constants.padding)
    }
    
    private struct Constants {
        struct Divider {
            static let width: CGFloat = 2
            static let height: CGFloat = 80
        }
        
        struct Button {
            static let spacing: CGFloat = 12
            static let fontSize: CGFloat = 16
        }
        
        struct Spacing {
            static let zero: CGFloat = 0
        }
        
        static let cornerRadius: CGFloat = 16
        static let padding: CGFloat = 16
    }
}

#Preview {
    MainMenuAndLocationView()
        .environmentObject(MainViewModel())
}
