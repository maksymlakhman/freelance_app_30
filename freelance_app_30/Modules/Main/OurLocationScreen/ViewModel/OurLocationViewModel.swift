import SwiftUI

protocol OurLocationViewModelProtocol: ObservableObject {
    var activeLink: OurLocationLink? { get set }
    var googleMapAPIKey : String { get }
    var googleMapMarkerTitle : String { get }
    var googleMapMarkerSnippet : String { get }
    var googleMapMarkerIcon : String { get }
    
    // MARK: - NavigationBar/Toolbar
    var leftNavBarIcon: String { get }
    var leftNavBarText: String { get }
}

final class OurLocationViewModel: ObservableObject, OurLocationViewModelProtocol, OurLocationFlowStateProtocol {
    
    @Published var activeLink: OurLocationLink?
    
    let googleMapAPIKey: String = "AIzaSyDHtVaWg3AFdT5kJhKw9otYgfK4i8ZrydI"
    
    let googleMapMarkerTitle: String = "The Penalty Box"
    
    let googleMapMarkerSnippet: String = "Cafe"
    
    let googleMapMarkerIcon: String = "custom_marker"
    
    // MARK: - NavigationBar/Toolbar
    let leftNavBarIcon: String = "arrow.left"
    let leftNavBarText: String = "Location"

}
