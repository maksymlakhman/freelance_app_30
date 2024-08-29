import Foundation

class DeviceIdentifier {
    static let shared = DeviceIdentifier()
    
    private init() {}
    
    private let deviceIDKey = "deviceID"
    
    var deviceID: String {
        if let id = KeychainHelper.shared.get(key: deviceIDKey) {
            return id
        } else {
            let newID = UUID().uuidString
            KeychainHelper.shared.save(key: deviceIDKey, data: newID)
            return newID
        }
    }
}
