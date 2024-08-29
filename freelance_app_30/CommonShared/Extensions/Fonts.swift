import SwiftUI

enum Inter: String {
    case regular = "Inter-Regular"
    case medium = "Inter-Medium"
    case semibold = "Inter-SemiBold"
    case lightItalic = "Inter-LightItalic"
}

//extension Font {
//    static func inter(_ style: Inter, size: CGFloat) -> Font {
//        return Font.custom(style.rawValue, size: size)
//    }
//}

extension Font {
    static func inter(_ style: Inter, size: CGFloat) -> Font {
        let uiFont = UIFont(name: style.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
        return Font(uiFont)
    }
}



//extension Font {
//    static func interFixed(_ style: Inter, size: CGFloat) -> Font {
//        let uiFont = UIFont(name: style.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
//        return Font(uiFont)
//    }
//}

