import Foundation

protocol SettingsViewModelProtocol: ObservableObject {
    // MARK: - ChevronIconImage
    var chevronIconImage : String { get }
    
    // MARK: - Toolbar
    var leftNavBarTextOne: String { get }
    var leftNavBarImage: String { get }
    
    // MARK: - NotificationButton
    var notificationTitleText : String { get }
    
    // MARK: - PrivacyPolicyButton
    var privacyPolicyTitleText : String { get }
    var privacyPolicyDescriptionText : String { get }
    
    // MARK: - TermOfUseButton
    var termOfUseTitleText : String { get }
    var termOfUseDescriptionText : String { get }
    
    // MARK: - RateUsButton
    var rateUsTitleText : String { get }
    var rateUsDescriptionText : String { get }
    
    // MARK: - ShareAppButton
    var shareAppTitleText : String { get }
    var shareAppDescriptionText : String { get }
    
    // MARK: - Contact Us
    var contactUsTitleText: String { get }
    var contactUsTextMessage: String { get }
    var contactUsTextEmail: String { get }
    var contactUsImage: String { get }
}

final class SettingsViewModel: SettingsViewModelProtocol, SettingsFlowStateProtocol {
    // MARK: - ChevronIconImage
    let chevronIconImage : String = "chevron.right.square.fill"
    
    // MARK: - Toolbar
    let leftNavBarTextOne: String = "More"
    let leftNavBarImage: String = "arrow.left"
    
    // MARK: - NotificationButton
    let notificationTitleText : String = "Notification"
    
    // MARK: - PrivacyPolicyButton
    let privacyPolicyTitleText : String = "Privacy Policy"
    let privacyPolicyDescriptionText : String = "Here you can read the application's privacy policy"
    
    // MARK: - TermOfUseButton
    let termOfUseTitleText : String = "Terms of Use"
    let termOfUseDescriptionText : String = "Here you can read the terms of use of the application"
    
    // MARK: - RateUsButton
    let rateUsTitleText : String = "Rate Us"
    let rateUsDescriptionText : String = "Rate our application in the app store"
    
    // MARK: - ShareAppButton
    let shareAppTitleText : String = "Share App"
    let shareAppDescriptionText : String = "Share the application with your friends"
    
    // MARK: - Contact Us
    let contactUsTitleText: String = "Contact Us"
    let contactUsTextMessage: String = "If you have any questions, you can contact us, we will be happy to help you."
    let contactUsTextEmail: String = "lasadaw220@noefa.com"
    let contactUsImage: String = "SettingsMailImage"
    
    // MARK: - Flow State
    @Published var activeLink: SettingsLink?

}
