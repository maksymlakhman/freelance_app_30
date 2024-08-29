import SwiftUI
import GoogleMaps

struct GoogleMapView: UIViewRepresentable {
  @EnvironmentObject var viewModel: OurLocationViewModel

    func makeUIView(context: Context) -> GMSMapView {
      GMSServices.provideAPIKey(viewModel.googleMapAPIKey)
      let camera = GMSCameraPosition.camera(
        withLatitude: GoogleMapViewConstants.latitude,
        longitude: GoogleMapViewConstants.longitude,
        zoom: GoogleMapViewConstants.zoom
      )
      let mapView = GMSMapView()
        mapView.frame = CGRect(x: .zero, y: .zero, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
      mapView.camera = camera

      setupMarker(for: mapView)
      return mapView
    }

  func updateUIView(_ uiView: GMSMapView, context: Context) { }

  private func setupMarker(for mapView: GMSMapView) {
    let marker = GMSMarker()
    marker.position = CLLocationCoordinate2D(
      latitude: GoogleMapViewConstants.latitude,
      longitude: GoogleMapViewConstants.longitude
    )
    marker.title = viewModel.googleMapMarkerTitle
    marker.snippet = viewModel.googleMapMarkerSnippet
    marker.icon = UIImage(named: viewModel.googleMapMarkerIcon)
    marker.map = mapView
  }

  private struct GoogleMapViewConstants {
    static let latitude: CLLocationDegrees = 37.773077498321236
    static let longitude: CLLocationDegrees = -122.42048269100255
    static let zoom: Float = 12.0
  }
}

#Preview {
  GoogleMapView()
    .environmentObject(OurLocationViewModel())
}
