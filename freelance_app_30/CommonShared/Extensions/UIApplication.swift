import SwiftUI

extension UIApplication {
    func openAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        if canOpenURL(settingsUrl) {
            open(settingsUrl)
        }
    }
}
