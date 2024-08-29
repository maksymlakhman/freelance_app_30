import Foundation
import UserNotifications

protocol OnboardingViewModelProtocol: ObservableObject {
    var backgroundImage: String { get }
    var onboardingTextBlockTitleTextOne: String { get }
    var onboardingTextBlockTitleTextTwo: String { get }
    var onboardingTextBlockTitleTextThree: String { get }
    var onboardingTextBlockSubTitle: String { get }
    var onboardingGetStartedLabelButtonText: String { get }
    
    func mainScreenAction()
}

final class OnboardingViewModel: OnboardingViewModelProtocol, OnboardingFlowStateProtocol {
    
    // MARK: - Flow State
    @Published var activeLink: OnboardingLink?
    @Published var hasStarted = UserDefaults.standard.bool(forKey: "hasStarted")
    
    // MARK: - TextViews
    let backgroundImage: String = "OnboardingBackgroundImage"
    let onboardingTextBlockTitleTextOne = "Quick and Easy"
    let onboardingTextBlockTitleTextTwo: String = "table reservations"
    let onboardingTextBlockTitleTextThree: String = "The Penalty Box"
    let onboardingTextBlockSubTitle: String = "Check out our menu, learn about us, make reservations and share the entry with friends"
    let onboardingGetStartedLabelButtonText: String = "Get Started"
    
    // MARK: - Actions
    func mainScreenAction() {
        UserDefaults.standard.set(true, forKey: "hasStarted")
        hasStarted = true
        requestNotificationPermission()
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            if granted {
                self?.scheduleNotification()
            }
            DispatchQueue.main.async {
                self?.activeLink = .mainScreenLink
            }
        }
    }
    @Published var reservationDate: Date = Date()
    private func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Table reservation"
        content.body = "Please be reminded that you have a reservation at \(DateFormatter.localizedString(from: reservationDate, dateStyle: .none, timeStyle: .short))."
        content.sound = UNNotificationSound.default
        
        let triggerDate = Calendar.current.date(byAdding: .hour, value: -1, to: reservationDate)!
        let triggerComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in }
    }
}

