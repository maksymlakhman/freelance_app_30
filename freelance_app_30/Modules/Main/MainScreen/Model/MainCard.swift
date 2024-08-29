import Foundation

struct MainCard : Identifiable, Hashable {
    let id : UUID = UUID()
    let titleText : String
    let subText : String
    let imageName : String
}


