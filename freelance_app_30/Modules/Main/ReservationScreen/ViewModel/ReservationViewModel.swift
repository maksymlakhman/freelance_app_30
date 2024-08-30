import SwiftUI
import Firebase

enum UserNameError: String {
    case isNameTooShort = "Short Name"
}

enum UserPhoneError: String {
    case isPhoneTooShort = "Short Phone"
    case isPhoneTooLong = "Long Phone"
}

protocol ReservationViewModelProtocol: ObservableObject {
    // MARK: - Flow State
    var activeLink: ReservationLink? { get set }
    
    // MARK: - NavigationBar/Toolbar
    var leftNavBarTextOne: String { get }
    var leftNavBarImage: String { get }
    
    // MARK: - Focusable
    var isFocusedName: Bool { get set }
    var isFocusedPhone: Bool { get set }
    
    // MARK: - Picker
    var date: Date { get set }
    // MARK: - DatePicker
    var showDatePickerSheet: Bool { get set }
    var datePickerLabelText: String { get }
    // MARK: - TimePicker
    var showTimePickerSheet: Bool { get set }
    var timePickerLabelText: String { get }
    
    // MARK: - Alert
    var showingAlert: Bool { get set }
    var alertTitle: String { get }
    var alertMessageText: String { get }
    var editCancelActionButton: String { get }
    var cancelDestructiveActionButton: String { get }
    
    // MARK: - Stepper
    var labelStepperText: String { get }
    var stepperValue: Int { get set }
    
    // MARK: - UserNameTextField
    var reservationUserName: String { get set }
    var isNameTooShort: Bool { get set }
    var reservationUserNameHeaderText: String { get }
    var reservationUserNamePlaceholderText: String { get }
    var userNameErrors: UserNameError { get set }
    
    // MARK: - UserPhoneNumberTextField
    var reservationUserPhoneNumber: String { get set }
    var isPhoneTooShort: Bool { get set }
    var isPhoneTooLong: Bool { get set }
    var reservationUserPhoneNumberHeaderText: String { get }
    var reservationUserPhoneNumberPlaceholderText: String { get }
    func formatPhoneNumber(_ number: String) -> String
    var userPhoneErrors: UserPhoneError { get set }
    
    // MARK: - ReservationBtn
    var reservationButtonText: String { get }
    var isReservationButtonEnabled: Bool { get }
    func validateReservationUserName() -> Bool
    func validateReservationUserPhone() -> Bool
    func validateAll() -> Bool
    func saveReservation()
}

final class ReservationViewModel: ReservationViewModelProtocol, ReservationFlowStateProtocol {
    // MARK: - Flow State
    @Published var activeLink: ReservationLink?
    
    // MARK: - NavigationBar/Toolbar
    let leftNavBarTextOne: String = "Reservation"
    let leftNavBarImage: String = "arrow.left"
    
    // MARK: - Focusable
    @Published var isFocusedName: Bool = false
    @Published var isFocusedPhone: Bool = false
    
    // MARK: - Picker
    @Published var date: Date = Date()
    // MARK: - DatePicker
    @Published var showDatePickerSheet: Bool = false
    let datePickerLabelText: String = "Date"
    // MARK: - TimePicker
    @Published var showTimePickerSheet: Bool = false
    let timePickerLabelText: String = "Time"
    
    // MARK: - Alert
    @Published var showingAlert: Bool = false
    let alertMessageText: String = "On exit, all changes will be lost"
    let cancelDestructiveActionButton: String = "Cancel changes"
    let alertTitle: String = "Undo your changes"
    let editCancelActionButton: String = "Edit further"
    
    // MARK: - Stepper
    @Published var stepperValue: Int = 2
    let labelStepperText: String = "Guests"
    
    // MARK: - UserNameTextField
    @Published var reservationUserName: String = ""
    @Published var isNameTooShort: Bool = false
    @Published var userNameErrors: UserNameError = .isNameTooShort
    let reservationUserNameHeaderText: String = "Name"
    let reservationUserNamePlaceholderText: String = "Your Name"
    
    // MARK: - UserPhoneNumberTextField
    @Published var reservationUserPhoneNumber: String = ""
    @Published var isPhoneTooShort: Bool = false
    @Published var isPhoneTooLong: Bool = false
    @Published var userPhoneErrors: UserPhoneError = .isPhoneTooShort
    let reservationUserPhoneNumberHeaderText: String = "Phone"
    let reservationUserPhoneNumberPlaceholderText: String = "+55(000)000-00-00"
    
    func formatPhoneNumber(_ number: String) -> String {
        var cleanNumber = number
        
        if cleanNumber.hasPrefix("+55(") {
            cleanNumber.removeFirst(4)
        }
        
        cleanNumber = cleanNumber.filter { "0123456789".contains($0) }
        
        var formattedNumber = ""
        
        for (index, digit) in cleanNumber.prefix(10).enumerated() {
            if index == 0 && !formattedNumber.isEmpty {
                formattedNumber.append(" ")
            }
            
            if index == 0 {
                formattedNumber.append("+55(")
            }
            
            if index == 3 {
                formattedNumber.append(")")
            } else if index == 6 {
                formattedNumber.append("-")
            } else if index == 8 {
                formattedNumber.append("-")
            }
            
            formattedNumber.append(digit)
        }
        
        if cleanNumber.count > 10 {
            isPhoneTooShort = false
            isPhoneTooLong = true
            userPhoneErrors = .isPhoneTooLong
        }
        
        if cleanNumber.count == 10 {
            isPhoneTooShort = false
            isPhoneTooLong = false
        }
        
        return formattedNumber
    }
    
    // MARK: - ReservationBtn
    let reservationButtonText: String = "Reserve table"
    
    var isReservationButtonEnabled: Bool {
        let minNameLength = 3
        let maxNameLength = 24
        let containsNumbers = reservationUserName.range(of: "[0-9]", options: .regularExpression) != nil

        let containsInvalidCharacters = reservationUserName.range(of: "[^a-zA-Zа-яА-Яà-ÿÀ-ŸіІїЇєЄ ]", options: .regularExpression) != nil
        
        let spaceCount = reservationUserName.components(separatedBy: " ").count - 1
        let isNameValid = reservationUserName.count >= minNameLength &&
                          reservationUserName.count <= maxNameLength &&
                          !containsNumbers &&
                          !containsInvalidCharacters
        

        let isPhoneValid = reservationUserPhoneNumber.count == 17

        let now = Date()
        let isDateValid = date >= now
        
        let calendar = Calendar.current
        let nowComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: now)
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        
        let isTimeValid: Bool
        if dateComponents.year == nowComponents.year && dateComponents.month == nowComponents.month && dateComponents.day == nowComponents.day {
            let selectedTime = calendar.date(bySettingHour: dateComponents.hour!, minute: dateComponents.minute!, second: 0, of: now)!
            isTimeValid = selectedTime >= now
        } else {
            isTimeValid = true
        }
        
        return isNameValid && isPhoneValid && isDateValid && isTimeValid && !isNameTooShort
    }

    
    func validateReservationUserName() -> Bool {
        let minNameLength = 3
        let maxNameLength = 24
        
        let trimmedName = reservationUserName.trimmingCharacters(in: .whitespaces)
        
        let spaceCount = reservationUserName.components(separatedBy: " ").count - 1
        let containsMultipleSpaces = spaceCount > 1
        
        if trimmedName.count < minNameLength {
            isNameTooShort = true
            userNameErrors = .isNameTooShort
        } else if trimmedName.count > maxNameLength || containsMultipleSpaces {
            isNameTooShort = false
        } else {
            isNameTooShort = false
        }
        
        reservationUserName = reservationUserName
        return !isNameTooShort && !containsMultipleSpaces && spaceCount == 1
    }





    
    func validateReservationUserPhone() -> Bool {
        let requiredPhoneLength = 17
        if reservationUserPhoneNumber.count < requiredPhoneLength {
            userPhoneErrors = .isPhoneTooShort
            isPhoneTooShort = true
            return false
        } else {
            isPhoneTooShort = false
            return true
        }
    }
    
    func validateAll() -> Bool {
        let isUserNameValid = validateReservationUserName()
        let isUserPhoneValid = validateReservationUserPhone()
        let isDateValid = date >= Date()
        let isTimeValid = (Calendar.current.dateComponents([.year, .month, .day], from: Date()) == Calendar.current.dateComponents([.year, .month, .day], from: date)) ? date >= Date() : true
        return isUserNameValid && isUserPhoneValid && isDateValid && isTimeValid
    }

    
    private var databaseRef: DatabaseReference!
    
    init() {
        databaseRef = Database.database().reference()
    }
    
    func saveReservation() {
        let deviceID = DeviceIdentifier.shared.deviceID
        let reservationData: [String: Any] = [
            "userName": reservationUserName,
            "userPhoneNumber": reservationUserPhoneNumber,
            "date": date.timeIntervalSince1970,
            "stepperValue": stepperValue
        ]
        
        databaseRef.child("users").child(deviceID).child("reservations").childByAutoId().setValue(reservationData) { error, _ in }
    }

}
