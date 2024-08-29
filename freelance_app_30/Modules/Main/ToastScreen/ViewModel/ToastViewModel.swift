import SwiftUI

final class ToastViewModel: ObservableObject{
    @EnvironmentObject var sharedData: SharedData
    var message: String = "Table's reserved"
    var btnText: String = "View history"
}


