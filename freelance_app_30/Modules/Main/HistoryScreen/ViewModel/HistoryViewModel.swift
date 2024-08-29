import SwiftUI
import Firebase

protocol HistoryViewModelProtocol: ObservableObject {
    // MARK: - NavigationBar/Toolbar
    var leftNavBarTextOne: String { get }
    var leftNavBarImage: String { get }

    // MARK: - EmptyHistoryView
    var emptyHistory: Bool { get }
    var emptyHistoryTitleText: String { get }
    var emptyHistoryDescriptionText: String { get }
    var emptyHistoryReserveButtonText: String { get }
    
    // MARK: - Flow State
    func reservationScreenAction()
    var showShareReservationSheet: Bool { get set }
    var isLoading: Bool { get set }
    
    // MARK: - HistoryItems
    var reservations: [HistoryRowItemModel] { get set }
    var selectedReservation: HistoryRowItemModel? { get set }
//    func getShareReservationURL(for reservation: HistoryRowItemModel) -> String?
    func getShareText(for reservation: HistoryRowItemModel) -> String
    func shareReservation(_ reservation: HistoryRowItemModel)
    func fetchReservations()
    
    // MARK: - HistoryRowItem
    var historyRowItemImage: String { get }
}

final class HistoryViewModel: HistoryViewModelProtocol, HistoryFlowStateProtocol {
    // MARK: - NavigationBar/Toolbar
    let leftNavBarTextOne: String = "Reservation History"
    let leftNavBarImage: String = "arrow.left"
    
    // MARK: - EmptyHistoryView
    @Published var emptyHistory: Bool = false
    let emptyHistoryTitleText: String = "History is empty"
    let emptyHistoryDescriptionText: String = "Reserve your first table in our cafe online\nto showcase the story"
    let emptyHistoryReserveButtonText: String = "Reserve Table"

    // MARK: - Flow State
    @Published var activeLink: HistoryLink?
    @Published var showShareReservationSheet: Bool = false
    @Published var isLoading: Bool = true
    
    // MARK: - HistoryItems
    @Published var reservations: [HistoryRowItemModel] = []
    @Published var selectedReservation: HistoryRowItemModel?
    func getShareText(for reservation: HistoryRowItemModel) -> String {
        let appName = "freelance_app_30"
        let userName = reservation.userName
        let numberOfPersons = reservation.numbersOfPersons
        let reservationDate = DateFormatter.localizedString(from: reservation.reservationDate, dateStyle: .medium, timeStyle: .none)
        let reservationTime = DateFormatter.localizedString(from: reservation.reservationTime, dateStyle: .none, timeStyle: .short)

        return "\(appName)\n\nБронювання:\nІм'я: \(userName)\nКількість гостей: \(numberOfPersons)\nДата: \(reservationDate)\nЧас: \(reservationTime)"
    }
//    func getShareReservationURL(for reservation: HistoryRowItemModel) -> String? {
//        let baseURL = "https://console.firebase.google.com/u/0/project/freelanceapp30-ebd1d/database/freelanceapp30-ebd1d-default-rtdb/data/~2F/reservations/"
//        return baseURL + reservation.id.uuidString
//    }
    func shareReservation(_ reservation: HistoryRowItemModel) {
        self.selectedReservation = reservation
        self.showShareReservationSheet = true
    }
    func reservationScreenAction() {
        activeLink = .reservationScreenLink
    }

    init() {
        databaseRef = Database.database().reference()
        fetchReservations()
    }
    private var databaseRef: DatabaseReference!
    func fetchReservations() {
        isLoading = true
        let deviceID = DeviceIdentifier.shared.deviceID
        databaseRef.child("users").child(deviceID).child("reservations").observeSingleEvent(of: .value) { snapshot in
            var newReservations: [HistoryRowItemModel] = []
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let data = childSnapshot.value as? [String: Any],
                   let userName = data["userName"] as? String,
                   let date = data["date"] as? TimeInterval,
                   let stepperValue = data["stepperValue"] as? Int {
                    let reservation = HistoryRowItemModel(
                        userName: userName,
                        reservationDate: Date(timeIntervalSince1970: date),
                        reservationTime: Date(timeIntervalSince1970: date),
                        numbersOfPersons: stepperValue
                    )
                    newReservations.append(reservation)
                }
            }
            self.reservations = newReservations
            self.emptyHistory = newReservations.isEmpty
            self.isLoading = false
        }
    }

    
    // MARK: - HistoryRowItem
    let historyRowItemImage: String = "arrowshape.turn.up.right.fill"
}
