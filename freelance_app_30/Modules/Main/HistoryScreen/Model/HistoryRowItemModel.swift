import SwiftUI

struct HistoryRowItemModel: Identifiable {
    let id: UUID = UUID()
    let userName: String
    let reservationDate: Date
    let reservationTime: Date
    let numbersOfPersons: Int
}


