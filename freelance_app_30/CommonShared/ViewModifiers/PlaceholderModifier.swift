import SwiftUI

struct PlaceholderModifier: ViewModifier {
    var placeholder: String
    @Binding var text: String
    var color: Color
    var font: Font

    func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            HStack(spacing : 0) {
                Text(placeholder)
                    .foregroundColor(color)
                    .font(font)
                    .opacity(0.5)
                    .fixedSize()
                Spacer()
            }
            
            content
        }
    }
}
