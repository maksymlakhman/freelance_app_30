import SwiftUI

extension View {
    func configureNavigationBar() -> some View {
        self.modifier(NavigationBarModifier())
    }
}

extension View {
    func hiddenNavigationBarStyle() -> some View {
        modifier( HiddenNavigationBarModifier() )
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

extension View {
    func placeholder(placeholder: String, text: Binding<String>, color: Color, font: Font) -> some View {
        self.modifier(PlaceholderModifier(placeholder: placeholder, text: text, color: color, font: font))
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

extension View {
    func navigationBarPaddingBottomPercentage() -> some View {
        self.padding(.bottom, UIScreen.main.bounds.height * 0.01)
    }
}
